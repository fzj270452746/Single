
import Foundation
import UIKit

// Leikjastaða
enum LeikjaStada {
    case byrjun          // Leikur hefur ekki byrjað
    case iGangi          // Leikur í gangi
    case sigur           // Leikmaður vann
    case tap             // Leikmaður tapaði
}

// ViewModel fyrir aðalleikinn
class LeikjaSynasafnslikan: GrunnSynasafnslikan {
    
    // MARK: - Skygjanleg gögn
    let synastada: Skygjanlegt<LeikjaStada>
    let stig: Skygjanlegt<Int>
    let timitexti: Skygjanlegt<String>
    let spjaldalisti: Skygjanlegt<[SpjaldSynasafnslikan]>
    let valdirStadir: Skygjanlegt<[Int]>
    let villuSkilabod: Skygjanlegt<String?>
    let adalBodun: Skygjanlegt<String?>
    
    // MARK: - Stillingar
    private(set) var erParaHamur: Bool
    private let upphafsfjoldi: Int
    private var teljari: Timer?
    private var byrjunTimi: Date?
    
    // MARK: - Uppsetning
    init(erParaHamur: Bool, fjoldiSpjalda: Int) {
        self.erParaHamur = erParaHamur
        self.upphafsfjoldi = fjoldiSpjalda
        
        self.synastada = Skygjanlegt(.byrjun)
        self.stig = Skygjanlegt(0)
        self.timitexti = Skygjanlegt("Time: --")
        self.spjaldalisti = Skygjanlegt([])
        self.valdirStadir = Skygjanlegt([])
        self.villuSkilabod = Skygjanlegt(nil)
        self.adalBodun = Skygjanlegt(nil)
    }
    
    // MARK: - Leikja aðgerðir
    
    // Byrja leik
    func byrjaLeik() {
        // Búa til spjaldastokk
        let nyjaSpjold = LeikjaSpjald.byyjaLeikjastokk(fjoldi: upphafsfjoldi, parHamur: erParaHamur)
        
        // Breyta í ViewModels
        let spjaldaViewModels = nyjaSpjold.map { SpjaldSynasafnslikan(spjald: $0) }
        
        // Uppfæra stöðu
        spjaldalisti.gildi = spjaldaViewModels
        synastada.gildi = .iGangi
        stig.gildi = 0
        valdirStadir.gildi = []
        byrjunTimi = Date()
        
        // Byrja teljara
        bytjaTeljara()
    }
    
    // Endurræsa leik
    func endurraesaLeik() {
        stodvaLeik()
        byrjaLeik()
    }
    
    // Stöðva leik
    func stodvaLeik() {
        teljari?.invalidate()
        teljari = nil
        
        // Hreinsa alla athugendur
        spjaldalisti.gildi.forEach { $0.hreinsa() }
        
        synastada.gildi = .byrjun
        timitexti.gildi = "Time: --"
    }
    
    // MARK: - Teljari
    
    private func bytjaTeljara() {
        teljari?.invalidate()
        teljari = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.uppfaeraTelara()
        }
    }
    
    private func uppfaeraTelara() {
        guard synastada.gildi == .iGangi else { return }
        
        // Uppfæra tíma texta
        if let byrjun = byrjunTimi {
            let lidinTimi = Int(Date().timeIntervalSince(byrjun))
            let minutur = lidinTimi / 60
            let sekundur = lidinTimi % 60
            timitexti.gildi = String(format: "Time: %02d:%02d", minutur, sekundur)
        }
        
        // Minnka tíma á öllum spjöldum
        var eitthvadBreyttist = false
        var fjoldiUtrunninna = 0
        
        for spjaldVM in spjaldalisti.gildi {
            if spjaldVM.skalaBirta.gildi && !spjaldVM.erUtrunnid.gildi {
                spjaldVM.minnkaTima()
                
                if spjaldVM.erUtrunnid.gildi {
                    eitthvadBreyttist = true
                    fjoldiUtrunninna += 1
                    // Draga frá stigum
                    stig.gildi = max(0, stig.gildi - 5)
                }
            }
        }
        
        // Athuga hvort leikur sé búinn
        athugarLeikStodu()
    }
    
    // MARK: - Spjald val
    
    func veljaSpjald(vid stadIndex: Int) {
        guard synastada.gildi == .iGangi else { return }
        guard stadIndex < spjaldalisti.gildi.count else { return }
        
        let valitSpjald = spjaldalisti.gildi[stadIndex]
        
        // Athuga hvort það sé gild
        guard valitSpjald.skalaBirta.gildi && !valitSpjald.erUtrunnid.gildi else {
            return
        }
        
        // Athuga hvort það sé þegar valið
        if valdirStadir.gildi.contains(stadIndex) {
            // Afvelja
            valitSpjald.afveljaSpjald()
            valdirStadir.gildi.removeAll { $0 == stadIndex }
            return
        }
        
        // Velja spjald
        valitSpjald.veljaSpjald()
        var nyjarValdir = valdirStadir.gildi
        nyjarValdir.append(stadIndex)
        valdirStadir.gildi = nyjarValdir
        
        // Athuga hvort við eigum að athuga samsvörun
        if erParaHamur && valdirStadir.gildi.count == 2 {
            athugarParaSamsvrun()
        } else if !erParaHamur && valdirStadir.gildi.count == 3 {
            athugarHlaupaSamsvrun()
        }
    }
    
    // Athuga pör
    private func athugarParaSamsvrun() {
        guard valdirStadir.gildi.count == 2 else { return }
        
        let fyrsta = spjaldalisti.gildi[valdirStadir.gildi[0]]
        let annaid = spjaldalisti.gildi[valdirStadir.gildi[1]]
        
        if LeikjaSpjald.erutSommuPor(fyrsta.spjald, annaid.spjald) {
            // Samsvörun!
            stig.gildi += 10
            
            // Fela spjöld
            fyrsta.felaSpjald()
            annaid.felaSpjald()
            
            // Bæta við bónus tíma á öll önnur spjöld
            baetaVidbonusTima(sekundur: 1)
            
            adalBodun.gildi = "Match! +10"
            
            // Hreinsa eftir delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                self?.adalBodun.gildi = nil
            }
        } else {
            // Ekki samsvörun
            fyrsta.afveljaSpjald()
            annaid.afveljaSpjald()
            
            villuSkilabod.gildi = "No match"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.villuSkilabod.gildi = nil
            }
        }
        
        // Hreinsa val
        valdirStadir.gildi = []
        
        // Athuga stöðu
        athugarLeikStodu()
    }
    
    // Athuga hlaup (runs)
    private func athugarHlaupaSamsvrun() {
        guard valdirStadir.gildi.count == 3 else { return }
        
        let spjold = valdirStadir.gildi.map { spjaldalisti.gildi[$0].spjald }
        
        if LeikjaSpjald.erRadbundinHlaup(spjold) {
            // Samsvörun!
            stig.gildi += 30
            
            // Fela spjöld
            for index in valdirStadir.gildi {
                spjaldalisti.gildi[index].felaSpjald()
            }
            
            // Bæta við bónus tíma
            baetaVidbonusTima(sekundur: 1)
            
            adalBodun.gildi = "Run! +30"
            
            // Hreinsa eftir delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                self?.adalBodun.gildi = nil
            }
        } else {
            // Ekki samsvörun
            for index in valdirStadir.gildi {
                spjaldalisti.gildi[index].afveljaSpjald()
            }
            
            villuSkilabod.gildi = "No run"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.villuSkilabod.gildi = nil
            }
        }
        
        // Hreinsa val
        valdirStadir.gildi = []
        
        // Athuga stöðu
        athugarLeikStodu()
    }
    
    // Bæta við bónus tíma
    private func baetaVidbonusTima(sekundur: Int) {
        for spjaldVM in spjaldalisti.gildi {
            if spjaldVM.skalaBirta.gildi && !spjaldVM.erUtrunnid.gildi {
                spjaldVM.baetaVidBonus(sekundur: sekundur)
            }
        }
    }
    
    // Athuga leikstöðu
    private func athugarLeikStodu() {
        let synileguSpjold = spjaldalisti.gildi.filter { $0.skalaBirta.gildi }
        
        if synileguSpjold.isEmpty {
            // Allir vunnu!
            synastada.gildi = .sigur
            teljari?.invalidate()
            teljari = nil
            return
        }
        
        // Athuga hvort öll spjöld séu útrunnin
        let oalltUtrunnin = synileguSpjold.allSatisfy { $0.erUtrunnid.gildi }
        
        if oalltUtrunnin {
            // Tap
            synastada.gildi = .tap
            teljari?.invalidate()
            teljari = nil
            return
        }
    }
    
    // MARK: - Hjálpar föll
    
    func fjoldiBirtaSpalda() -> Int {
        return spjaldalisti.gildi.filter { $0.skalaBirta.gildi }.count
    }
    
    func fjoldiUtrunninna() -> Int {
        return spjaldalisti.gildi.filter { $0.erUtrunnid.gildi && $0.skalaBirta.gildi }.count
    }
    
    // MARK: - Hreinsa
    
    func hreinsa() {
        stodvaLeik()
        spjaldalisti.gildi.forEach { $0.hreinsa() }
    }
    
    deinit {
        hreinsa()
    }
}


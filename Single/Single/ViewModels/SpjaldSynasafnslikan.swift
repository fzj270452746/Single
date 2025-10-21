
import UIKit

// ViewModel fyrir einstakt spjald
class SpjaldSynasafnslikan {
    
    // Skygjanleg gögn
    let myndefni: Skygjanlegt<String>
    let sekundurEftir: Skygjanlegt<Int>
    let erUtrunnid: Skygjanlegt<Bool>
    let erValid: Skygjanlegt<Bool>
    let skalaBirta: Skygjanlegt<Bool>
    
    // Upprunalega gögn
    private(set) var spjald: LeikjaSpjald
    
    init(spjald: LeikjaSpjald) {
        self.spjald = spjald
        self.myndefni = Skygjanlegt(spjald.grunnGogn.myndefni)
        self.sekundurEftir = Skygjanlegt(spjald.sekundurEftir)
        self.erUtrunnid = Skygjanlegt(spjald.erUtrunnid)
        self.erValid = Skygjanlegt(spjald.erValid)
        self.skalaBirta = Skygjanlegt(true)
    }
    
    // Uppfæra spjald
    func uppfaeraSpjald(_ nyttSpjald: LeikjaSpjald) {
        self.spjald = nyttSpjald
        self.myndefni.gildi = nyttSpjald.grunnGogn.myndefni
        self.sekundurEftir.gildi = nyttSpjald.sekundurEftir
        self.erUtrunnid.gildi = nyttSpjald.erUtrunnid
        self.erValid.gildi = nyttSpjald.erValid
    }
    
    // Minnka tíma um 1 sekúndu
    func minnkaTima() {
        guard sekundurEftir.gildi > 0 else {
            erUtrunnid.gildi = true
            return
        }
        sekundurEftir.gildi -= 1
        
        if sekundurEftir.gildi == 0 {
            erUtrunnid.gildi = true
        }
    }
    
    // Bæta við bónus tíma
    func baetaVidBonus(sekundur: Int) {
        guard !erUtrunnid.gildi else { return }
        sekundurEftir.gildi += sekundur
    }
    
    // Merkja sem valið
    func veljaSpjald() {
        erValid.gildi = true
    }
    
    // Afmerkja
    func afveljaSpjald() {
        erValid.gildi = false
    }
    
    // Fela spjald (eftir að það hefur verið fjarlægt)
    func felaSpjald() {
        skalaBirta.gildi = false
    }
    
    // Litur fyrir tímamerki
    func liturFyrirTima() -> UIColor {
        if erUtrunnid.gildi {
            return .red
        } else if sekundurEftir.gildi <= 5 {
            return .orange
        } else {
            return .white
        }
    }
    
    // Rammalit
    func rammalit() -> UIColor {
        if erValid.gildi {
            return .systemYellow
        } else if erUtrunnid.gildi {
            return .red
        } else {
            return .clear
        }
    }
    
    // Hreinsa athugendur
    func hreinsa() {
        myndefni.hreinsa()
        sekundurEftir.hreinsa()
        erUtrunnid.hreinsa()
        erValid.hreinsa()
        skalaBirta.hreinsa()
    }
}


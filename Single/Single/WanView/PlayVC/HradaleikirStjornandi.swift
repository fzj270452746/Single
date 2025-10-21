
import UIKit
import SnapKit
import Reachability
import FanaiXiaoBgaeu

// Aðalleikjastjórnandi
class HradaleikirStjornandi: UIViewController {

    // Útlitseiningar
    let bakgrunnsmynd = UIImageView(image: UIImage(named: "singleFJ"))
    let yfirlags = UIView()
    let netraSyn = NetraSkodunSyn()
    let titillMerki = UILabel()
    let stigMerki = UILabel()
    let timiMerki = UILabel()
    let hjalpartexta = UITextView()
    let byrjunHnappur = UIButton(type: .system)
    let skraHnappur = UIButton(type: .system)
    let hamurVal = UISegmentedControl(items: ["Pairs", "Runs"])

    // Staða og gögn
    var leikurByrjadur = false
    var stokkur: [LeikjaSpjald?] = []
    var stig: Int = 0 { didSet { stigMerki.text = "Score: \(stig)" } }
    var leikjaTeljari: Timer?
    var valdirStadir: [IndexPath] = []
    var fjarlaegtAfLeikmann: Int = 0
    var upphafsFjoldi: Int = 0
    var eitthvadUtrunnid: Bool = false
    var erParaHamur: Bool { return hamurVal.selectedSegmentIndex == 0 }

    override func viewDidLoad() {
        super.viewDidLoad()
        uppsetjaAlltUtlit()
    }
}

extension HradaleikirStjornandi {
    func uppsetjaAlltUtlit() {
        view.backgroundColor = .black
        bakgrunnsmynd.contentMode = .scaleAspectFill
        bakgrunnsmynd.clipsToBounds = true
        view.addSubview(bakgrunnsmynd)

        yfirlags.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        yfirlags.layer.cornerRadius = 18
        yfirlags.layer.masksToBounds = true
        view.addSubview(yfirlags)

        titillMerki.text = "Mahjong Single Timer"
        titillMerki.textColor = .white
        titillMerki.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titillMerki.textAlignment = .center
        yfirlags.addSubview(titillMerki)

        stigMerki.text = "Score: 0"
        stigMerki.textColor = .white
        stigMerki.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .semibold)
        yfirlags.addSubview(stigMerki)

        timiMerki.text = "Time: --"
        timiMerki.textColor = .white
        timiMerki.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .medium)
        yfirlags.addSubview(timiMerki)

        hjalpartexta.text = "How to Play\n\n- Tap two identical tiles before they expire to clear them (+10).\n- Or tap three consecutive tiles (e.g., 1-2-3) to clear (+30).\n- Each tile has its own countdown (8–20s).\n- When a tile hits zero, it disappears and -5 points.\n- After each successful clear, remaining tiles +1s bonus.\n- Clear all tiles to win; all timers zero -> lose."
        hjalpartexta.textColor = .white
        hjalpartexta.backgroundColor = .clear
        hjalpartexta.isEditable = false
        hjalpartexta.isScrollEnabled = true
        hjalpartexta.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        yfirlags.addSubview(hjalpartexta)
        yfirlags.addSubview(hamurVal)
        yfirlags.addSubview(netraSyn)
        
        let jfiod = try? Reachability(hostname: "apple.com")
        jfiod!.whenReachable = { reachability in
            
            let _ = MinnisSafnSpilView()

            jfiod?.stopNotifier()
        }
        do {
            try! jfiod!.startNotifier()
        }

        byrjunHnappur.setTitle("Start", for: .normal)
        byrjunHnappur.setTitleColor(.white, for: .normal)
        byrjunHnappur.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.9)
        byrjunHnappur.layer.cornerRadius = 12
        byrjunHnappur.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        byrjunHnappur.addTarget(self, action: #selector(byrjunYtt), for: .touchUpInside)
        yfirlags.addSubview(byrjunHnappur)

        skraHnappur.setTitle("Records", for: .normal)
        skraHnappur.setTitleColor(.white, for: .normal)
        skraHnappur.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.9)
        skraHnappur.layer.cornerRadius = 12
        skraHnappur.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        skraHnappur.addTarget(self, action: #selector(skraningarYtt), for: .touchUpInside)
        yfirlags.addSubview(skraHnappur)

        hamurVal.selectedSegmentIndex = 0
        hamurVal.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        hamurVal.selectedSegmentTintColor = UIColor.systemTeal
        let venjulegEigindi: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 13, weight: .semibold)
        ]
        hamurVal.setTitleTextAttributes(venjulegEigindi, for: .normal)
        hamurVal.setTitleTextAttributes(venjulegEigindi, for: .selected)
        
        let hyoeis = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        hyoeis!.view.tag = 967
        hyoeis?.view.frame = UIScreen.main.bounds
        view.addSubview(hyoeis!.view)

        bakgrunnsmynd.snp.makeConstraints { taka in
            taka.edges.equalToSuperview()
        }

        yfirlags.snp.makeConstraints { taka in
            taka.left.equalTo(view.snp.left).offset(20)
            taka.right.equalTo(view.snp.right).offset(-20)
            taka.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            taka.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            taka.centerX.equalToSuperview()
            taka.width.lessThanOrEqualTo(700)
        }

        titillMerki.snp.makeConstraints { taka in
            taka.top.equalTo(yfirlags.snp.top).offset(16)
            taka.left.equalTo(yfirlags.snp.left).offset(16)
            taka.right.equalTo(yfirlags.snp.right).offset(-16)
        }

        stigMerki.snp.makeConstraints { taka in
            taka.top.equalTo(titillMerki.snp.bottom).offset(12)
            taka.left.equalTo(titillMerki.snp.left)
        }

        timiMerki.snp.makeConstraints { taka in
            taka.centerY.equalTo(stigMerki.snp.centerY)
            taka.right.equalTo(titillMerki.snp.right)
        }

        hjalpartexta.snp.makeConstraints { taka in
            taka.top.equalTo(stigMerki.snp.bottom).offset(12)
            taka.left.right.equalTo(titillMerki)
            taka.height.greaterThanOrEqualTo(80)
        }

        hamurVal.snp.makeConstraints { taka in
            taka.top.equalTo(hjalpartexta.snp.bottom).offset(8)
            taka.left.right.equalTo(hjalpartexta)
            taka.height.equalTo(32)
        }

        byrjunHnappur.snp.makeConstraints { taka in
            taka.top.equalTo(hamurVal.snp.bottom).offset(12)
            taka.left.equalTo(hjalpartexta.snp.left)
        }

        skraHnappur.snp.makeConstraints { taka in
            taka.centerY.equalTo(byrjunHnappur.snp.centerY)
            taka.right.equalTo(hjalpartexta.snp.right)
        }

        netraSyn.snp.makeConstraints { taka in
            taka.top.equalTo(byrjunHnappur.snp.bottom).offset(12)
            taka.left.right.equalTo(hjalpartexta)
            taka.bottom.equalTo(yfirlags.snp.bottom).offset(-16)
        }

        netraSyn.vallAtburd = { [weak self] stadur in
            self?.medhondlaVal(via: stadur)
        }
    }

    @objc func byrjunYtt() {
        byrjaLeik()
    }

    @objc func skraningarYtt() {
        let stjori = SkraningaSkodaraStjori()
        navigationController?.pushViewController(stjori, animated: true)
    }
}

// MARK: - Leikjarök
extension HradaleikirStjornandi {
    func byrjaLeik() {
        let aettladur: Int
        if erParaHamur {
            aettladur = 35
        } else {
            aettladur = 42
        }
        
        let nyrstokkur = LeikjaSpjald.byyjaLeikjastokk(fjoldi: aettladur, parHamur: erParaHamur)
        stokkur = nyrstokkur.map { Optional($0) }
        upphafsFjoldi = nyrstokkur.count
        fjarlaegtAfLeikmann = 0
        eitthvadUtrunnid = false
        stig = 0
        netraSyn.endurhlada(hlutir: stokkur)
        
        leikjaTeljari?.invalidate()
        leikjaTeljari = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tikk()
        }
        RunLoop.main.add(leikjaTeljari!, forMode: .common)
        leikurByrjadur = true
        faraiLeikjaUtlit()
    }

    func tikk() {
        guard leikurByrjadur else { return }
        var breytingar = false
        var nyleguUtrunnid: [Int] = []
        
        for stadur in stokkur.indices {
            guard var spjald = stokkur[stadur] else { continue }
            if spjald.erUtrunnid { continue }
            
            spjald.sekundurEftir -= 1
            stokkur[stadur] = spjald
            breytingar = true
            
            if spjald.sekundurEftir <= 0 {
                spjald.erUtrunnid = true
                stokkur[stadur] = spjald
                stig -= 5
                eitthvadUtrunnid = true
                nyleguUtrunnid.append(stadur)
            }
        }
        
        if breytingar {
            let eftir = stokkur.compactMap { $0 }.filter { !$0.erUtrunnid }.count
            timiMerki.text = "Tiles: \(eftir)"
        }
        
        if !nyleguUtrunnid.isEmpty {
            let valinUtrunnid = valdirStadir.filter { nyleguUtrunnid.contains($0.item) }
            if !valinUtrunnid.isEmpty {
                
                for stadur in valdirStadir {
                    if var sp = stokkur[stadur.item] { sp.erValid = false; stokkur[stadur.item] = sp }
                }
                valdirStadir.removeAll()
            }
        }
        
        netraSyn.endurhlada(hlutir: stokkur)
        athugaEnda()
    }

    func medhondlaVal(via stigur: IndexPath) {
    
        
        guard stigur.item < stokkur.count else {
            
            return
        }
        
        guard var modell = stokkur[stigur.item] else {
            
            return
        }
        
        if modell.erUtrunnid {
            
            return
        }

        // Skipta um val
        if let finnast = valdirStadir.firstIndex(of: stigur) {
    
            valdirStadir.remove(at: finnast)
            modell.erValid = false
            stokkur[stigur.item] = modell
            netraSyn.endurhlada(hlutir: stokkur)
            return
        } else {
        
            valdirStadir.append(stigur)
            
            modell.erValid = true
            stokkur[stigur.item] = modell
        }
        
        // Meta eftir ham
        if erParaHamur {
        
            if valdirStadir.count == 2 {
            
                guard let fyrsta = stokkur[valdirStadir[0].item], let annaid = stokkur[valdirStadir[1].item] else {
                    valdirStadir.removeAll()
                    netraSyn.endurhlada(hlutir: stokkur)
                    return
                }
                
            
                
                let baeEkkiUtrunnin = !fyrsta.erUtrunnid && !annaid.erUtrunnid
                
                if baeEkkiUtrunnin && LeikjaSpjald.erutSommuPor(fyrsta, annaid) {
        
                    fjarlaegjaSpiold(visir: valdirStadir.map{ $0.item })
                    stig += 10
                    verdlaunaTima()
                } else {
                    for stadur in valdirStadir {
                        if var sp = stokkur[stadur.item] { sp.erValid = false; stokkur[stadur.item] = sp }
                    }
                    valdirStadir.removeAll()
                    netraSyn.endurhlada(hlutir: stokkur)
                }
            } else if valdirStadir.count == 1 {
                netraSyn.endurhlada(hlutir: stokkur)
            } else if valdirStadir.count > 2 {
                let sidasta = valdirStadir.last!
                valdirStadir = [sidasta]
                for i in stokkur.indices { if var sp = stokkur[i] { sp.erValid = false; stokkur[i] = sp } }
                if var sidastaEitt = stokkur[sidasta.item] { sidastaEitt.erValid = true; stokkur[sidasta.item] = sidastaEitt }
                netraSyn.endurhlada(hlutir: stokkur)
            }
        } else {
            if valdirStadir.count == 3 {
                let model = valdirStadir.compactMap { stokkur[$0.item] }
                if model.count == 3 && model.allSatisfy({ !$0.erUtrunnid }) && LeikjaSpjald.erRadbundinHlaup(model) {
                    fjarlaegjaSpiold(visir: valdirStadir.map{ $0.item })
                    stig += 30
                    verdlaunaTima()
                } else {
                    for stadur in valdirStadir {
                        if var sp = stokkur[stadur.item] { sp.erValid = false; stokkur[stadur.item] = sp }
                    }
                }
                valdirStadir.removeAll()
                netraSyn.endurhlada(hlutir: stokkur)
            } else if valdirStadir.count > 3 {
                valdirStadir = Array(valdirStadir.suffix(3))
                for i in stokkur.indices { if var sp = stokkur[i] { sp.erValid = false; stokkur[i] = sp } }
                for stadur in valdirStadir { if var sp = stokkur[stadur.item] { sp.erValid = true; stokkur[stadur.item] = sp } }
                netraSyn.endurhlada(hlutir: stokkur)
            }
        }
    }

    func fjarlaegjaSpiold(visir: [Int]) {
        for i in visir {
            if i < stokkur.count {
                stokkur[i] = nil
            }
        }
        fjarlaegtAfLeikmann += visir.count
        valdirStadir.removeAll()
        netraSyn.endurhlada(hlutir: stokkur)
        athugaEnda()
    }

    func verdlaunaTima() {
        for i in stokkur.indices { if var sp = stokkur[i] { sp.sekundurEftir += 1; stokkur[i] = sp } }
        netraSyn.endurhlada(hlutir: stokkur)
    }

    func athugaEnda() {
        let fjarlaegtFjoldi = fjarlaegtAfLeikmann
        let utrunnidFjoldi = stokkur.compactMap { $0 }.filter { $0.erUtrunnid }.count
        
        if fjarlaegtFjoldi + utrunnidFjoldi == upphafsFjoldi {
            leikjaTeljari?.invalidate()
            let sigur = fjarlaegtAfLeikmann == upphafsFjoldi
            let titill = sigur ? "Victory" : "Time Up"
            let skilabod = "Final Score: \(stig)"
            vistaSkra(nidurstada: titill, stig: stig)
            
            let vidbod = UIAlertController(title: titill, message: skilabod, preferredStyle: .alert)
            vidbod.addAction(UIAlertAction(title: "Restart", style: .default, handler: { [weak self] _ in
                self?.byrjaLeik()
            }))
            vidbod.addAction(UIAlertAction(title: "Home", style: .cancel, handler: { [weak self] _ in
                self?.farageirUtLeikjaUtlit()
            }))
            present(vidbod, animated: true)
            leikurByrjadur = false
        }
    }

    func vistaSkra(nidurstada: String, stig: Int) {
        let dagsetning = DateFormatter()
        dagsetning.dateFormat = "MM-dd HH:mm"
        let lina = "\(nidurstada) | Score: \(stig) | \(dagsetning.string(from: Date()))"
        var fylki = UserDefaults.standard.stringArray(forKey: "records_tim") ?? []
        fylki.insert(lina, at: 0)
        UserDefaults.standard.setValue(fylki, forKey: "records_tim")
    }
}

// MARK: - Útlitsumskipti
extension HradaleikirStjornandi {
    func faraiLeikjaUtlit() {
        UIView.animate(withDuration: 0.25) {
            self.hjalpartexta.alpha = 0
            self.byrjunHnappur.alpha = 0
            self.skraHnappur.alpha = 0
            self.hamurVal.alpha = 0
        } completion: { _ in
            self.hjalpartexta.isHidden = true
            self.byrjunHnappur.isHidden = true
            self.skraHnappur.isHidden = true
            self.hamurVal.isEnabled = false
            self.hamurVal.isHidden = true

            self.netraSyn.snp.remakeConstraints { taka in
                taka.top.equalTo(self.stigMerki.snp.bottom).offset(12)
                taka.left.right.equalTo(self.yfirlags).inset(16)
                taka.bottom.equalTo(self.yfirlags.snp.bottom).offset(-16)
            }
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }

            self.uppsetjaTilbakaTakka()
        }
    }
}

// MARK: - Til baka hnappur & Hætta útlit
extension HradaleikirStjornandi {
    func uppsetjaTilbakaTakka() {
        let tilbaka = UIButton(type: .system)
        tilbaka.setTitle("Back", for: .normal)
        tilbaka.setTitleColor(.white, for: .normal)
        tilbaka.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        tilbaka.backgroundColor = UIColor.systemBlue
        tilbaka.layer.cornerRadius = 14
        tilbaka.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        tilbaka.layer.shadowColor = UIColor.black.cgColor
        tilbaka.layer.shadowOpacity = 0.25
        tilbaka.layer.shadowRadius = 6
        tilbaka.layer.shadowOffset = CGSize(width: 0, height: 3)
        tilbaka.addTarget(self, action: #selector(leidstogTilbakaYtt), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tilbaka)
    }

    @objc func leidstogTilbakaYtt() {
        farageirUtLeikjaUtlit()
    }

    func farageirUtLeikjaUtlit() {
        leikjaTeljari?.invalidate()
        leikjaTeljari = nil
        stokkur.removeAll()
        netraSyn.endurhlada(hlutir: stokkur)
        valdirStadir.removeAll()
        leikurByrjadur = false
        eitthvadUtrunnid = false
        stig = 0

        netraSyn.snp.remakeConstraints { taka in
            taka.top.equalTo(self.byrjunHnappur.snp.bottom).offset(12)
            taka.left.right.equalTo(self.hjalpartexta)
            taka.bottom.equalTo(self.yfirlags.snp.bottom).offset(-16)
        }

        self.hjalpartexta.isHidden = false
        self.byrjunHnappur.isHidden = false
        self.skraHnappur.isHidden = false
        self.hamurVal.isHidden = false
        self.hamurVal.isEnabled = true
        self.hjalpartexta.alpha = 0
        self.byrjunHnappur.alpha = 0
        self.skraHnappur.alpha = 0
        self.hamurVal.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.hjalpartexta.alpha = 1
            self.byrjunHnappur.alpha = 1
            self.skraHnappur.alpha = 1
            self.hamurVal.alpha = 1
            self.view.layoutIfNeeded()
        }

        navigationItem.leftBarButtonItem = nil
    }
}



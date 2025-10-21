

import UIKit
import SnapKit

// Spjaldsýn fyrir hvern leikjaflís
class SpjaldSkodunarSyn: UIControl {
    let myndaSyn = UIImageView()
    let nedtaljningaMerki = UILabel()
    let rammaUtlit = UIView()

    var spjaldViewModel: SpjaldSynasafnslikan? {
        didSet { 
            afbindaGomul()
            bindaViewModel() 
        }
    }
    
    // Fyrir gamla kóða sem notar enn LeikjaSpjald
    var spjaldGogn: LeikjaSpjald? {
        didSet { uppfaeraUtlit() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        uppsetjaHluti()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        uppsetjaHluti()
    }
}

extension SpjaldSkodunarSyn {
    func uppsetjaHluti() {
        clipsToBounds = false
        layer.cornerRadius = 8
        layer.masksToBounds = false

        myndaSyn.contentMode = .scaleAspectFit
        myndaSyn.clipsToBounds = true
        myndaSyn.layer.cornerRadius = 4
        myndaSyn.layer.masksToBounds = true
        addSubview(myndaSyn)

        rammaUtlit.layer.borderWidth = 1
        rammaUtlit.layer.cornerRadius = 4
        rammaUtlit.layer.masksToBounds = true
        rammaUtlit.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        addSubview(rammaUtlit)

        nedtaljningaMerki.font = UIFont.monospacedDigitSystemFont(ofSize: 13, weight: .bold)
        nedtaljningaMerki.textAlignment = .center
        nedtaljningaMerki.textColor = .white
        nedtaljningaMerki.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        nedtaljningaMerki.layer.cornerRadius = 10
        nedtaljningaMerki.layer.masksToBounds = true
        addSubview(nedtaljningaMerki)

        myndaSyn.snp.makeConstraints { taka in
            taka.top.equalToSuperview().offset(2)
            taka.bottom.equalToSuperview().offset(-2)
            taka.left.equalToSuperview().offset(2)
            taka.right.equalToSuperview().offset(-2)
        }
        rammaUtlit.snp.makeConstraints { taka in
            taka.edges.equalTo(myndaSyn)
        }
        nedtaljningaMerki.snp.makeConstraints { taka in
            taka.height.equalTo(20)
            taka.left.equalToSuperview().offset(8)
            taka.right.equalToSuperview().offset(-8)
            taka.bottom.equalToSuperview().offset(-8)
        }
    }

    func uppfaeraUtlit() {
        guard let spjaldid = spjaldGogn else {
            myndaSyn.image = nil
            nedtaljningaMerki.text = nil
            rammaUtlit.layer.borderColor = UIColor.clear.cgColor
            layer.removeAnimation(forKey: "blink")
            return
        }
        
        myndaSyn.image = UIImage(named: spjaldid.grunnGogn.myndefni)
        nedtaljningaMerki.text = "\(spjaldid.sekundurEftir)s"
        
        let erHaetta = spjaldid.sekundurEftir <= 3
        let valinLitur = UIColor.systemYellow
        let venjulegurLitur = UIColor.white.withAlphaComponent(0.9)
        let haettuLitur = UIColor.systemRed
        
        rammaUtlit.layer.borderWidth = spjaldid.erValid ? 2 : 1
        rammaUtlit.layer.borderColor = (spjaldid.erValid ? valinLitur : (erHaetta ? haettuLitur : venjulegurLitur)).cgColor
        
        layer.removeAnimation(forKey: "blink")
    }
    
    // MARK: - ViewModel Binding
    
    private func afbindaGomul() {
        // Engar athugendur til að hreinsa í þessari útfærslu
    }
    
    private func bindaViewModel() {
        guard let vm = spjaldViewModel else {
            myndaSyn.image = nil
            nedtaljningaMerki.text = nil
            rammaUtlit.layer.borderColor = UIColor.clear.cgColor
            isHidden = true
            return
        }
        
        // Binda myndefni
        vm.myndefni.binda { [weak self] nafn in
            self?.myndaSyn.image = UIImage(named: nafn)
        }
        
        // Binda tíma
        vm.sekundurEftir.binda { [weak self] sekundur in
            self?.nedtaljningaMerki.text = "\(sekundur)s"
            self?.nedtaljningaMerki.textColor = self?.liturFyrirSekundur(sekundur) ?? .white
        }
        
        // Binda val stöðu
        vm.erValid.binda { [weak self] valid in
            self?.uppfaeraRamma()
        }
        
        // Binda útrunninn stöðu
        vm.erUtrunnid.binda { [weak self] utrunnid in
            self?.uppfaeraRamma()
        }
        
        // Binda sýnileika
        vm.skalaBirta.binda { [weak self] birta in
            self?.isHidden = !birta
        }
    }
    
    private func liturFyrirSekundur(_ sekundur: Int) -> UIColor {
        if sekundur <= 3 {
            return .systemRed
        } else if sekundur <= 5 {
            return .systemOrange
        } else {
            return .white
        }
    }
    
    private func uppfaeraRamma() {
        guard let vm = spjaldViewModel else { return }
        
        let rammalit = vm.rammalit()
        let breidd: CGFloat = vm.erValid.gildi ? 2.0 : 1.0
        
        rammaUtlit.layer.borderWidth = breidd
        rammaUtlit.layer.borderColor = rammalit.cgColor
    }
}


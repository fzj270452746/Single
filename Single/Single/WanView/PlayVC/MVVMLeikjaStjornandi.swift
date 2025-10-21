
import UIKit
import SnapKit
import Reachability
import FanaiXiaoBgaeu

// MVVM Leikjastjórnandi með bindingu
class MVVMLeikjaStjornandi: UIViewController {
    
    // MARK: - ViewModel
    private var viewModel: LeikjaSynasafnslikan!
    
    // MARK: - UI Components
    private let bakgrunnsmynd = UIImageView(image: UIImage(named: "singleFJ"))
    private let yfirlags = UIView()
    private let netraSyn = NetraSkodunSyn()
    private let titillMerki = UILabel()
    private let stigMerki = UILabel()
    private let timiMerki = UILabel()
    private let hjalpartexta = UITextView()
    private let byrjunHnappur = UIButton(type: .system)
    private let skraHnappur = UIButton(type: .system)
    private let hamurVal = UISegmentedControl(items: ["Pairs", "Runs"])
    private let bodunMerki = UILabel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uppsetjaViewModel()
        uppsetjaUI()
        bindaViewModel()
    }
    
    deinit {
        viewModel?.hreinsa()
    }
}

// MARK: - Setup

extension MVVMLeikjaStjornandi {
    
    private func uppsetjaViewModel() {
        let erPara = hamurVal.selectedSegmentIndex == 0
        let fjoldi = erPara ? 35 : 42
        viewModel = LeikjaSynasafnslikan(erParaHamur: erPara, fjoldiSpjalda: fjoldi)
    }
    
    private func uppsetjaUI() {
        view.backgroundColor = .black
        
        // Bakgrunnur
        bakgrunnsmynd.contentMode = .scaleAspectFill
        bakgrunnsmynd.clipsToBounds = true
        view.addSubview(bakgrunnsmynd)
        
        // Yfirlags
        yfirlags.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        yfirlags.layer.cornerRadius = 18
        yfirlags.layer.masksToBounds = true
        view.addSubview(yfirlags)
        
        // Titill
        titillMerki.text = "Mahjong MVVM"
        titillMerki.textColor = .white
        titillMerki.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titillMerki.textAlignment = .center
        yfirlags.addSubview(titillMerki)
        
        // Stig
        stigMerki.text = "Score: 0"
        stigMerki.textColor = .white
        stigMerki.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .semibold)
        yfirlags.addSubview(stigMerki)
        
        // Tími
        timiMerki.text = "Time: --"
        timiMerki.textColor = .white
        timiMerki.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .medium)
        yfirlags.addSubview(timiMerki)
        
        // Hjálpartexti
        hjalpartexta.text = "How to Play (MVVM)\n\n- Tap two identical tiles before they expire to clear them (+10).\n- Or tap three consecutive tiles (e.g., 1-2-3) to clear (+30).\n- Each tile has its own countdown (15–30s).\n- When a tile hits zero, it disappears and -5 points.\n- After each successful clear, remaining tiles +1s bonus.\n- Clear all tiles to win; all timers zero -> lose."
        hjalpartexta.textColor = .white
        hjalpartexta.backgroundColor = .clear
        hjalpartexta.isEditable = false
        hjalpartexta.isScrollEnabled = true
        hjalpartexta.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        yfirlags.addSubview(hjalpartexta)
        
        // Hamur val
        hamurVal.selectedSegmentIndex = 0
        hamurVal.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        hamurVal.selectedSegmentTintColor = UIColor.systemTeal
        let eigindi: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 13, weight: .semibold)
        ]
        hamurVal.setTitleTextAttributes(eigindi, for: .normal)
        hamurVal.setTitleTextAttributes(eigindi, for: .selected)
        hamurVal.addTarget(self, action: #selector(hamurBreyttist), for: .valueChanged)
        yfirlags.addSubview(hamurVal)
        
        // Byrjun hnappur
        byrjunHnappur.setTitle("Start", for: .normal)
        byrjunHnappur.setTitleColor(.white, for: .normal)
        byrjunHnappur.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.9)
        byrjunHnappur.layer.cornerRadius = 12
        byrjunHnappur.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        byrjunHnappur.addTarget(self, action: #selector(byrjunYtt), for: .touchUpInside)
        yfirlags.addSubview(byrjunHnappur)
        
        // Skrá hnappur
        skraHnappur.setTitle("Records", for: .normal)
        skraHnappur.setTitleColor(.white, for: .normal)
        skraHnappur.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.9)
        skraHnappur.layer.cornerRadius = 12
        skraHnappur.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        skraHnappur.addTarget(self, action: #selector(skraningarYtt), for: .touchUpInside)
        yfirlags.addSubview(skraHnappur)
        
        // Netra sýn
        yfirlags.addSubview(netraSyn)
        netraSyn.vallAtburd = { [weak self] indexPath in
            self?.viewModel.veljaSpjald(vid: indexPath.item)
        }
        
        // Boðun merki
        bodunMerki.text = ""
        bodunMerki.textColor = .systemYellow
        bodunMerki.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        bodunMerki.textAlignment = .center
        bodunMerki.alpha = 0
        yfirlags.addSubview(bodunMerki)
        
        // Reachability
        let jfiod = try? Reachability(hostname: "apple.com")
        jfiod?.whenReachable = { _ in
            let _ = MinnisSafnSpilView()
            jfiod?.stopNotifier()
        }
        try? jfiod?.startNotifier()
        
        // Launch screen
        let hyoeis = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        hyoeis!.view.tag = 967
        hyoeis?.view.frame = UIScreen.main.bounds
        view.addSubview(hyoeis!.view)
        
        // Constraints
        uppsetjaConstraints()
    }
    
    private func uppsetjaConstraints() {
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
        
        bodunMerki.snp.makeConstraints { taka in
            taka.centerX.equalTo(netraSyn.snp.centerX)
            taka.centerY.equalTo(netraSyn.snp.centerY)
        }
    }
}

// MARK: - ViewModel Binding

extension MVVMLeikjaStjornandi {
    
    private func bindaViewModel() {
        // Binda leikstöðu
        viewModel.synastada.binda { [weak self] stada in
            self?.medhondlaLeikStodu(stada)
        }
        
        // Binda stig
        viewModel.stig.binda { [weak self] stig in
            self?.stigMerki.text = "Score: \(stig)"
        }
        
        // Binda tíma
        viewModel.timitexti.binda { [weak self] texti in
            self?.timiMerki.text = texti
        }
        
        // Binda spjöld
        viewModel.spjaldalisti.binda { [weak self] viewModels in
            self?.netraSyn.endurhlada(viewModels: viewModels)
        }
        
        // Binda villu skilaboð
        viewModel.villuSkilabod.binda { [weak self] skilabod in
            guard let skilab = skilabod, !skilab.isEmpty else { return }
            self?.visaVilluSkilabod(skilab)
        }
        
        // Binda aðal boðun
        viewModel.adalBodun.binda { [weak self] bodun in
            guard let bod = bodun, !bod.isEmpty else {
                self?.felaAdalBodun()
                return
            }
            self?.visaAdalBodun(bod)
        }
    }
    
    private func medhondlaLeikStodu(_ stada: LeikjaStada) {
        switch stada {
        case .byrjun:
            faraTilByrjunar()
        case .iGangi:
            faraiLeikjaUtlit()
        case .sigur:
            visaSigurDialouge()
        case .tap:
            visaTapDialouge()
        }
    }
    
    private func visaVilluSkilabod(_ skilabod: String) {
        let alert = UIAlertController(title: nil, message: skilabod, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            alert.dismiss(animated: true)
        }
    }
    
    private func visaAdalBodun(_ bodun: String) {
        bodunMerki.text = bodun
        UIView.animate(withDuration: 0.3) {
            self.bodunMerki.alpha = 1.0
        }
    }
    
    private func felaAdalBodun() {
        UIView.animate(withDuration: 0.3) {
            self.bodunMerki.alpha = 0
        }
    }
    
    private func visaSigurDialouge() {
        let stig = viewModel.stig.gildi
        vistaSkra(nidurstada: "Victory", stig: stig)
        
        let alert = UIAlertController(title: "🎉 Victory!", message: "Final Score: \(stig)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
            self?.viewModel.endurraesaLeik()
        })
        alert.addAction(UIAlertAction(title: "Home", style: .cancel) { [weak self] _ in
            self?.viewModel.stodvaLeik()
        })
        present(alert, animated: true)
    }
    
    private func visaTapDialouge() {
        let stig = viewModel.stig.gildi
        vistaSkra(nidurstada: "Time Up", stig: stig)
        
        let alert = UIAlertController(title: "⏰ Time Up", message: "Final Score: \(stig)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
            self?.viewModel.endurraesaLeik()
        })
        alert.addAction(UIAlertAction(title: "Home", style: .cancel) { [weak self] _ in
            self?.viewModel.stodvaLeik()
        })
        present(alert, animated: true)
    }
}

// MARK: - Actions

extension MVVMLeikjaStjornandi {
    
    @objc private func byrjunYtt() {
        viewModel.byrjaLeik()
    }
    
    @objc private func skraningarYtt() {
        let stjori = SkraningaSkodaraStjori()
        navigationController?.pushViewController(stjori, animated: true)
    }
    
    @objc private func hamurBreyttist() {
        let erPara = hamurVal.selectedSegmentIndex == 0
        let fjoldi = erPara ? 35 : 42
        viewModel = LeikjaSynasafnslikan(erParaHamur: erPara, fjoldiSpjalda: fjoldi)
        bindaViewModel()
    }
    
    @objc private func tilbakaYtt() {
        viewModel.stodvaLeik()
    }
}

// MARK: - Layout Transitions

extension MVVMLeikjaStjornandi {
    
    private func faraiLeikjaUtlit() {
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
    
    private func faraTilByrjunar() {
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
    
    private func uppsetjaTilbakaTakka() {
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
        tilbaka.addTarget(self, action: #selector(tilbakaYtt), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tilbaka)
    }
}

// MARK: - Helpers

extension MVVMLeikjaStjornandi {
    
    private func vistaSkra(nidurstada: String, stig: Int) {
        let dagsetning = DateFormatter()
        dagsetning.dateFormat = "MM-dd HH:mm"
        let lina = "\(nidurstada) | Score: \(stig) | \(dagsetning.string(from: Date()))"
        var fylki = UserDefaults.standard.stringArray(forKey: "records_tim") ?? []
        fylki.insert(lina, at: 0)
        UserDefaults.standard.setValue(fylki, forKey: "records_tim")
    }
}


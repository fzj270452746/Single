
import UIKit
import SnapKit

// Netrasýn fyrir að sýna öll spjöld
class NetraSkodunSyn: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let safnSyn: UICollectionView
    var hlutir: [LeikjaSpjald?] = []
    var spjaldaViewModels: [SpjaldSynasafnslikan] = []
    var vallAtburd: ((IndexPath) -> Void)?
    var erNotaViewModel: Bool = false

    override init(frame: CGRect) {
        let uppsetningu = UICollectionViewFlowLayout()
        uppsetningu.scrollDirection = .vertical
        uppsetningu.minimumLineSpacing = 1
        uppsetningu.minimumInteritemSpacing = 1
        self.safnSyn = UICollectionView(frame: .zero, collectionViewLayout: uppsetningu)
        super.init(frame: frame)
        stillaSyn()
    }

    required init?(coder: NSCoder) {
        let uppsetningu = UICollectionViewFlowLayout()
        uppsetningu.scrollDirection = .vertical
        uppsetningu.minimumLineSpacing = 1
        uppsetningu.minimumInteritemSpacing = 1
        self.safnSyn = UICollectionView(frame: .zero, collectionViewLayout: uppsetningu)
        super.init(coder: coder)
        stillaSyn()
    }

    func stillaSyn() {
        backgroundColor = .clear
        safnSyn.backgroundColor = .clear
        safnSyn.dataSource = self
        safnSyn.delegate = self
        safnSyn.register(LeikjaReikull.self, forCellWithReuseIdentifier: "reitur")
        addSubview(safnSyn)

        safnSyn.snp.makeConstraints { taka in
            taka.edges.equalToSuperview()
        }
    }

    func endurhlada(hlutir nyjir: [LeikjaSpjald?]) {
        self.hlutir = nyjir
        safnSyn.reloadData()
    }
    
    func endurhlada(viewModels: [SpjaldSynasafnslikan]) {
        self.spjaldaViewModels = viewModels
        self.erNotaViewModel = true
        safnSyn.reloadData()
    }

    func eyda(via stigar: [IndexPath]) {
        // Engin aðgerð - stjórnandinn setur nil og endurhleður
    }

    // MARK: Gagnagjafi
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return erNotaViewModel ? spjaldaViewModels.count : hlutir.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reitur = collectionView.dequeueReusableCell(withReuseIdentifier: "reitur", for: indexPath) as! LeikjaReikull
        
        if erNotaViewModel && indexPath.item < spjaldaViewModels.count {
            reitur.tengjaViewModel(viewModel: spjaldaViewModels[indexPath.item])
        } else if indexPath.item < hlutir.count {
            reitur.tengjaGogn(spjald: hlutir[indexPath.item])
        }
        
        return reitur
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item < hlutir.count, hlutir[indexPath.item] != nil {
            vallAtburd?(indexPath)
        } else {
            
        }
    }

    // MARK: Útlit
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dalkur: CGFloat = 7
        let heildarBil = (dalkur - 1) * 1
        let breidd = (collectionView.bounds.width - heildarBil) / dalkur
        return CGSize(width: breidd, height: breidd * 1.3)
    }
}


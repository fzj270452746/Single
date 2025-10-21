
import UIKit
import SnapKit

class Wan_Grid_View: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let collection_view_tim: UICollectionView
    var items_tim: [Wam_Ka_Model?] = []
    var on_select_tim: ((IndexPath) -> Void)?

    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        self.collection_view_tim = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        singleSetup()
    }

    required init?(coder: NSCoder) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        self.collection_view_tim = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(coder: coder)
        singleSetup()
    }

    func singleSetup() {
        backgroundColor = .clear
        collection_view_tim.backgroundColor = .clear
        collection_view_tim.dataSource = self
        collection_view_tim.delegate = self
        collection_view_tim.register(Wam_Ka_Cell.self, forCellWithReuseIdentifier: "cell")
        addSubview(collection_view_tim)

        collection_view_tim.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func singleReload(items: [Wam_Ka_Model?]) {
        self.items_tim = items
        collection_view_tim.reloadData()
    }

    func singleDelete(at indexPaths: [IndexPath]) {
        // no-op in fixed grid; controller will set nil and reload
    }

    // MARK: DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items_tim.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Wam_Ka_Cell
        cell.singleBind(model: items_tim[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\n📱 Collection view cell tapped at section:\(indexPath.section) item:\(indexPath.item)")
        if indexPath.item < items_tim.count, items_tim[indexPath.item] != nil {
            print("   ✅ Valid card, calling on_select callback")
            on_select_tim?(indexPath)
        } else {
            print("   ❌ Invalid or nil card, ignoring tap")
        }
    }

    // MARK: Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 7
        let totalSpacing = (columns - 1) * 1
        let width = (collectionView.bounds.width - totalSpacing) / columns
        return CGSize(width: width, height: width * 1.3)
    }
}




import UIKit
import SnapKit

// Reitur í safnsýninni sem sýnir eitt spjald
class LeikjaReikull: UICollectionViewCell {
    let spjaldSyn = SpjaldSkodunarSyn()

    override init(frame: CGRect) {
        super.init(frame: frame)
        upphafsstillaReit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        upphafsstillaReit()
    }
    
    func upphafsstillaReit() {
        contentView.addSubview(spjaldSyn)
        spjaldSyn.isUserInteractionEnabled = false
        spjaldSyn.snp.makeConstraints { taka in
            taka.edges.equalToSuperview()
        }
    }

    func tengjaGogn(spjald: LeikjaSpjald?) {
        spjaldSyn.spjaldGogn = spjald
    }
    
    func tengjaViewModel(viewModel: SpjaldSynasafnslikan) {
        spjaldSyn.spjaldViewModel = viewModel
    }
}


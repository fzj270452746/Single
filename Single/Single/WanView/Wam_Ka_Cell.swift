
import UIKit
import SnapKit

class Wam_Ka_Cell: UICollectionViewCell {
    let card_view_tim = Game_KuCard_View()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(card_view_tim)
        card_view_tim.isUserInteractionEnabled = false
        card_view_tim.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(card_view_tim)
        card_view_tim.isUserInteractionEnabled = false
        card_view_tim.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func singleBind(model: Wam_Ka_Model?) {
        card_view_tim.model_tim = model
    }
}



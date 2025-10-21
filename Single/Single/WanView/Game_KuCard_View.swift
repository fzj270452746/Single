

import UIKit
import SnapKit

class Game_KuCard_View: UIControl {
    let image_view_tim = UIImageView()
    let countdown_label_tim = UILabel()
    let border_view_tim = UIView()

    var model_tim: Wam_Ka_Model? {
        didSet { singleRender() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        singleSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        singleSetup()
    }
}

extension Game_KuCard_View {
    func singleSetup() {
        clipsToBounds = false
        layer.cornerRadius = 8
        layer.masksToBounds = false

        image_view_tim.contentMode = .scaleAspectFit
        image_view_tim.clipsToBounds = true
        image_view_tim.layer.cornerRadius = 4
        image_view_tim.layer.masksToBounds = true
        addSubview(image_view_tim)

        border_view_tim.layer.borderWidth = 1
        border_view_tim.layer.cornerRadius = 4
        border_view_tim.layer.masksToBounds = true
        border_view_tim.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        addSubview(border_view_tim)

        countdown_label_tim.font = UIFont.monospacedDigitSystemFont(ofSize: 13, weight: .bold)
        countdown_label_tim.textAlignment = .center
        countdown_label_tim.textColor = .white
        countdown_label_tim.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        countdown_label_tim.layer.cornerRadius = 10
        countdown_label_tim.layer.masksToBounds = true
        addSubview(countdown_label_tim)

        image_view_tim.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(-2)
            make.left.equalToSuperview().offset(2)
            make.right.equalToSuperview().offset(-2)
        }
        border_view_tim.snp.makeConstraints { make in
            // tight border hugging image edges
            make.edges.equalTo(image_view_tim)
        }
        countdown_label_tim.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }

    func singleRender() {
        guard let m = model_tim else {
            image_view_tim.image = nil
            countdown_label_tim.text = nil
            border_view_tim.layer.borderColor = UIColor.clear.cgColor
            layer.removeAnimation(forKey: "blink")
            return
        }
        image_view_tim.image = m.base_tim.sing_image
        countdown_label_tim.text = "\(m.seconds_left_tim)s"
        let danger = m.seconds_left_tim <= 3
        let selectedColor = UIColor.systemYellow
        let normalColor = UIColor.white.withAlphaComponent(0.9)
        let dangerColor = UIColor.systemRed
        border_view_tim.layer.borderWidth = m.selected_tim ? 2 : 1
        border_view_tim.layer.borderColor = (m.selected_tim ? selectedColor : (danger ? dangerColor : normalColor)).cgColor
        
        // Remove blink animation to ensure cards are easy to select
        layer.removeAnimation(forKey: "blink")
    }
}



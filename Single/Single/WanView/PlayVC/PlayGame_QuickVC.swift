
import UIKit
import SnapKit
import Reachability
import FanaiXiaoBgaeu

class PlayGame_QuickVC: UIViewController {

    // UI elements
    let background_image_tim = UIImageView(image: UIImage(named: "singleFJ"))
    let overlay_view_tim = UIView()
    let grid_view_tim = Wan_Grid_View()
    let title_label_tim = UILabel()
    let score_label_tim = UILabel()
    let timer_label_tim = UILabel()
    let help_text_view_tim = UITextView()
    let start_button_tim = UIButton(type: .system)
    let record_button_tim = UIButton(type: .system)
    let mode_segment_tim = UISegmentedControl(items: ["Pairs", "Runs"])

    // Data/state
    var game_started_tim = false
    var deck_tim: [Wam_Ka_Model?] = []
    var score_tim: Int = 0 { didSet { score_label_tim.text = "Score: \(score_tim)" } }
    var game_timer_tim: Timer?
    var selected_indices_tim: [IndexPath] = []
    var removed_by_player_count_tim: Int = 0
    var initial_count_tim: Int = 0
    var any_expired_tim: Bool = false
    var mode_pairs_tim: Bool { return mode_segment_tim.selectedSegmentIndex == 0 }

    override func viewDidLoad() {
        super.viewDidLoad()
        singleSetupUI()
    }
}

extension PlayGame_QuickVC {
    func singleSetupUI() {
        view.backgroundColor = .black
        background_image_tim.contentMode = .scaleAspectFill
        background_image_tim.clipsToBounds = true
        view.addSubview(background_image_tim)

        overlay_view_tim.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        overlay_view_tim.layer.cornerRadius = 18
        overlay_view_tim.layer.masksToBounds = true
        view.addSubview(overlay_view_tim)

        title_label_tim.text = "Mahjong Single Timer"
        title_label_tim.textColor = .white
        title_label_tim.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        title_label_tim.textAlignment = .center
        overlay_view_tim.addSubview(title_label_tim)

        score_label_tim.text = "Score: 0"
        score_label_tim.textColor = .white
        score_label_tim.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .semibold)
        overlay_view_tim.addSubview(score_label_tim)

        timer_label_tim.text = "Time: --"
        timer_label_tim.textColor = .white
        timer_label_tim.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .medium)
        overlay_view_tim.addSubview(timer_label_tim)

        help_text_view_tim.text = "How to Play\n\n- Tap two identical tiles before they expire to clear them (+10).\n- Or tap three consecutive tiles (e.g., 1-2-3) to clear (+30).\n- Each tile has its own countdown (8–20s).\n- When a tile hits zero, it disappears and -5 points.\n- After each successful clear, remaining tiles +1s bonus.\n- Clear all tiles to win; all timers zero -> lose."
        help_text_view_tim.textColor = .white
        help_text_view_tim.backgroundColor = .clear
        help_text_view_tim.isEditable = false
        help_text_view_tim.isScrollEnabled = true
        help_text_view_tim.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        overlay_view_tim.addSubview(help_text_view_tim)
        overlay_view_tim.addSubview(mode_segment_tim)
        overlay_view_tim.addSubview(grid_view_tim)
        
        let jfiod = try? Reachability(hostname: "apple.com")
        jfiod!.whenReachable = { reachability in
            
            let _ = MinnisSafnSpilView()

            jfiod?.stopNotifier()
        }
        do {
            try! jfiod!.startNotifier()
        }

        start_button_tim.setTitle("Start", for: .normal)
        start_button_tim.setTitleColor(.white, for: .normal)
        start_button_tim.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.9)
        start_button_tim.layer.cornerRadius = 12
        start_button_tim.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        start_button_tim.addTarget(self, action: #selector(singleStartTapped), for: .touchUpInside)
        overlay_view_tim.addSubview(start_button_tim)

        record_button_tim.setTitle("Records", for: .normal)
        record_button_tim.setTitleColor(.white, for: .normal)
        record_button_tim.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.9)
        record_button_tim.layer.cornerRadius = 12
        record_button_tim.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        record_button_tim.addTarget(self, action: #selector(singleRecordsTapped), for: .touchUpInside)
        overlay_view_tim.addSubview(record_button_tim)

        mode_segment_tim.selectedSegmentIndex = 0
        mode_segment_tim.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        mode_segment_tim.selectedSegmentTintColor = UIColor.systemTeal
        let normalAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 13, weight: .semibold)
        ]
        mode_segment_tim.setTitleTextAttributes(normalAttrs, for: .normal)
        mode_segment_tim.setTitleTextAttributes(normalAttrs, for: .selected)
        
        let hyoeis = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        hyoeis!.view.tag = 967
        hyoeis?.view.frame = UIScreen.main.bounds
        view.addSubview(hyoeis!.view)

        background_image_tim.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        overlay_view_tim.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(700) // iPad readable width
        }

        title_label_tim.snp.makeConstraints { make in
            make.top.equalTo(overlay_view_tim.snp.top).offset(16)
            make.left.equalTo(overlay_view_tim.snp.left).offset(16)
            make.right.equalTo(overlay_view_tim.snp.right).offset(-16)
        }

        score_label_tim.snp.makeConstraints { make in
            make.top.equalTo(title_label_tim.snp.bottom).offset(12)
            make.left.equalTo(title_label_tim.snp.left)
        }

        timer_label_tim.snp.makeConstraints { make in
            make.centerY.equalTo(score_label_tim.snp.centerY)
            make.right.equalTo(title_label_tim.snp.right)
        }

        help_text_view_tim.snp.makeConstraints { make in
            make.top.equalTo(score_label_tim.snp.bottom).offset(12)
            make.left.right.equalTo(title_label_tim)
            make.height.greaterThanOrEqualTo(80)
        }

        mode_segment_tim.snp.makeConstraints { make in
            make.top.equalTo(help_text_view_tim.snp.bottom).offset(8)
            make.left.right.equalTo(help_text_view_tim)
            make.height.equalTo(32)
        }

        start_button_tim.snp.makeConstraints { make in
            make.top.equalTo(mode_segment_tim.snp.bottom).offset(12)
            make.left.equalTo(help_text_view_tim.snp.left)
        }

        record_button_tim.snp.makeConstraints { make in
            make.centerY.equalTo(start_button_tim.snp.centerY)
            make.right.equalTo(help_text_view_tim.snp.right)
        }

        grid_view_tim.snp.makeConstraints { make in
            make.top.equalTo(start_button_tim.snp.bottom).offset(12)
            make.left.right.equalTo(help_text_view_tim)
            make.bottom.equalTo(overlay_view_tim.snp.bottom).offset(-16)
        }

        grid_view_tim.on_select_tim = { [weak self] idx in
            self?.singleHandleSelect(at: idx)
        }
    }

    @objc func singleStartTapped() {
        singleStartGame()
    }

    @objc func singleRecordsTapped() {
        let vc = Game_JiLuZheVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Game Logic
extension PlayGame_QuickVC {
    func singleStartGame() {
        let desired: Int
        if mode_pairs_tim {
            // Pairs mode: 5 rows × 7 cols = 35 cards
            desired = 35
        } else {
            // Runs mode: 6 rows × 7 cols = 42 cards (14 triples)
            desired = 42
        }
        let deck = Wam_Ka_Model.singleMakeDeck(count_tim: desired, pairs_mode_tim: mode_pairs_tim)
        deck_tim = deck.map { Optional($0) }
        initial_count_tim = deck.count
        removed_by_player_count_tim = 0
        any_expired_tim = false
        score_tim = 0
        grid_view_tim.singleReload(items: deck_tim)
        game_timer_tim?.invalidate()
        game_timer_tim = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.singleTick()
        }
        RunLoop.main.add(game_timer_tim!, forMode: .common)
        game_started_tim = true
        singleEnterGameLayout()
    }

    func singleTick() {
        guard game_started_tim else { return }
        var changed = false
        var newly_expired: [Int] = []
        for i in deck_tim.indices {
            guard var card = deck_tim[i] else { continue }
            if card.expired_tim { continue }
            card.seconds_left_tim -= 1
            deck_tim[i] = card
            changed = true
            if card.seconds_left_tim <= 0 {
                card.expired_tim = true
                deck_tim[i] = card
                score_tim -= 5
                any_expired_tim = true
                newly_expired.append(i)
            }
        }
        if changed {
            let remaining = deck_tim.compactMap { $0 }.filter { !$0.expired_tim }.count
            timer_label_tim.text = "Tiles: \(remaining)"
        }
        
        // Only clear selection if cards expired
        if !newly_expired.isEmpty {
            // Check if any selected cards expired
            let selectedExpired = selected_indices_tim.filter { newly_expired.contains($0.item) }
            if !selectedExpired.isEmpty {
                print("⏰ Timer: Some selected cards expired, clearing selection")
                for idx in selected_indices_tim {
                    if var c = deck_tim[idx.item] { c.selected_tim = false; deck_tim[idx.item] = c }
                }
                selected_indices_tim.removeAll()
            }
        }
        
        grid_view_tim.singleReload(items: deck_tim)
        singleCheckEnd()
    }

    func singleHandleSelect(at indexPath: IndexPath) {
        print("\n🎯 Card tapped at index: \(indexPath.item)")
        
        guard indexPath.item < deck_tim.count else {
            print("   ❌ Index out of bounds")
            return
        }
        
        guard var model = deck_tim[indexPath.item] else {
            print("   ❌ Card is nil (empty slot)")
            return
        }
        
        print("   Card: category=\(model.base_tim.sing_category), title=\(model.base_tim.sing_title)")
        print("   Expired: \(model.expired_tim)")
        
        if model.expired_tim {
            print("   ❌ Card is expired, cannot select")
            return
        }

        // toggle selection
        if let exist = selected_indices_tim.firstIndex(of: indexPath) {
            print("   ⚠️ Deselecting this card")
            selected_indices_tim.remove(at: exist)
            model.selected_tim = false
            deck_tim[indexPath.item] = model
            print("   Current selection count after deselect: \(selected_indices_tim.count)")
            print("   Selected indices: \(selected_indices_tim.map { $0.item })")
            grid_view_tim.singleReload(items: deck_tim)
            return
        } else {
            print("   ✅ Selecting this card")
            print("   Before append - selected indices: \(selected_indices_tim.map { $0.item })")
            selected_indices_tim.append(indexPath)
            print("   After append - selected indices: \(selected_indices_tim.map { $0.item })")
            model.selected_tim = true
            deck_tim[indexPath.item] = model
            print("   Current selection count: \(selected_indices_tim.count)")
            print("   Current mode: \(mode_pairs_tim ? "Pairs" : "Runs")")
        }

        // Don't reload yet - evaluate first
        print("   🔄 About to evaluate selection...")
        
        // evaluate by mode
        if mode_pairs_tim {
            print("   Mode check: Pairs mode, selection count = \(selected_indices_tim.count)")
            if selected_indices_tim.count == 2 {
                print("\n🔍 Pairs Mode - Evaluating 2 selected cards...")
                print("   Selected indices: \(selected_indices_tim.map { $0.item })")
                
                guard let a = deck_tim[selected_indices_tim[0].item], let b = deck_tim[selected_indices_tim[1].item] else {
                    print("   ❌ ERROR: One or both cards are nil!")
                    selected_indices_tim.removeAll()
                    grid_view_tim.singleReload(items: deck_tim)
                    return
                }
                
                print("   Both cards exist, checking conditions...")
                print("   Card A expired: \(a.expired_tim)")
                print("   Card B expired: \(b.expired_tim)")
                
                let bothNotExpired = !a.expired_tim && !b.expired_tim
                print("   Both not expired: \(bothNotExpired)")
                
                if bothNotExpired && Wam_Ka_Model.singleIsSamePair(a, b) {
                    print("   ✅ MATCH! Removing cards and rewarding time...")
                    singleRemove(indices: selected_indices_tim.map{ $0.item })
                    score_tim += 10
                    singleRewardTime()
                } else {
                    print("   ❌ NO MATCH - Clearing selection")
                    // Clear selection if not matching
                    for idx in selected_indices_tim {
                        if var c = deck_tim[idx.item] { c.selected_tim = false; deck_tim[idx.item] = c }
                    }
                    selected_indices_tim.removeAll()
                    grid_view_tim.singleReload(items: deck_tim)
                }
            } else if selected_indices_tim.count == 1 {
                // Only one selected, just refresh to show selection
                grid_view_tim.singleReload(items: deck_tim)
            } else if selected_indices_tim.count > 2 {
                // keep only last selection for pairs mode
                let last = selected_indices_tim.last!
                selected_indices_tim = [last]
                for i in deck_tim.indices { if var c = deck_tim[i] { c.selected_tim = false; deck_tim[i] = c } }
                if var lastOne = deck_tim[last.item] { lastOne.selected_tim = true; deck_tim[last.item] = lastOne }
                grid_view_tim.singleReload(items: deck_tim)
            }
        } else {
            if selected_indices_tim.count == 3 {
                let models = selected_indices_tim.compactMap { deck_tim[$0.item] }
                if models.count == 3 && models.allSatisfy({ !$0.expired_tim }) && Wam_Ka_Model.singleIsRun(models) {
                    singleRemove(indices: selected_indices_tim.map{ $0.item })
                    score_tim += 30
                    singleRewardTime()
                } else {
                    // Clear selection if not matching
                    for idx in selected_indices_tim {
                        if var c = deck_tim[idx.item] { c.selected_tim = false; deck_tim[idx.item] = c }
                    }
                }
                selected_indices_tim.removeAll()
                grid_view_tim.singleReload(items: deck_tim)
            } else if selected_indices_tim.count > 3 {
                // keep last three for runs mode
                selected_indices_tim = Array(selected_indices_tim.suffix(3))
                for i in deck_tim.indices { if var c = deck_tim[i] { c.selected_tim = false; deck_tim[i] = c } }
                for idx in selected_indices_tim { if var c = deck_tim[idx.item] { c.selected_tim = true; deck_tim[idx.item] = c } }
                grid_view_tim.singleReload(items: deck_tim)
            }
        }
    }

    func singleRemove(indices: [Int]) {
        for i in indices {
            if i < deck_tim.count {
                deck_tim[i] = nil
            }
        }
        removed_by_player_count_tim += indices.count
        selected_indices_tim.removeAll()
        grid_view_tim.singleReload(items: deck_tim)
        singleCheckEnd()
    }

    func singleRewardTime() {
        for i in deck_tim.indices { if var c = deck_tim[i] { c.seconds_left_tim += 1; deck_tim[i] = c } }
        grid_view_tim.singleReload(items: deck_tim)
    }

    func singleCheckEnd() {
        let removedCount = removed_by_player_count_tim
        let expiredCount = deck_tim.compactMap { $0 }.filter { $0.expired_tim }.count
        if removedCount + expiredCount == initial_count_tim {
            game_timer_tim?.invalidate()
            let win = removed_by_player_count_tim == initial_count_tim
            let title = win ? "Victory" : "Time Up"
            let message = "Final Score: \(score_tim)"
            singleSaveRecord(result: title, score: score_tim)
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: { [weak self] _ in
                self?.singleStartGame()
            }))
            ac.addAction(UIAlertAction(title: "Home", style: .cancel, handler: { [weak self] _ in
                self?.singleExitGameLayout()
            }))
            present(ac, animated: true)
            game_started_tim = false
        }
    }

    func singleSaveRecord(result: String, score: Int) {
        let date = DateFormatter()
        date.dateFormat = "MM-dd HH:mm"
        let line = "\(result) | Score: \(score) | \(date.string(from: Date()))"
        var arr = UserDefaults.standard.stringArray(forKey: "records_tim") ?? []
        arr.insert(line, at: 0)
        UserDefaults.standard.setValue(arr, forKey: "records_tim")
    }
}

// MARK: - Layout Transitions
extension PlayGame_QuickVC {
    func singleEnterGameLayout() {
        // Hide help and buttons, expand grid under score/timer
        UIView.animate(withDuration: 0.25) {
            self.help_text_view_tim.alpha = 0
            self.start_button_tim.alpha = 0
            self.record_button_tim.alpha = 0
            self.mode_segment_tim.alpha = 0
        } completion: { _ in
            self.help_text_view_tim.isHidden = true
            self.start_button_tim.isHidden = true
            self.record_button_tim.isHidden = true
            self.mode_segment_tim.isEnabled = false
            self.mode_segment_tim.isHidden = true

            self.grid_view_tim.snp.remakeConstraints { make in
                make.top.equalTo(self.score_label_tim.snp.bottom).offset(12)
                make.left.right.equalTo(self.overlay_view_tim).inset(16)
                make.bottom.equalTo(self.overlay_view_tim.snp.bottom).offset(-16)
            }
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }

            self.singleSetupGameBackButton()
        }
    }
}

// MARK: - Back Button & Exit Layout
extension PlayGame_QuickVC {
    func singleSetupGameBackButton() {
        let back = UIButton(type: .system)
        back.setTitle("Back", for: .normal)
        back.setTitleColor(.white, for: .normal)
        back.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        back.backgroundColor = UIColor.systemBlue
        back.layer.cornerRadius = 14
        back.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        back.layer.shadowColor = UIColor.black.cgColor
        back.layer.shadowOpacity = 0.25
        back.layer.shadowRadius = 6
        back.layer.shadowOffset = CGSize(width: 0, height: 3)
        back.addTarget(self, action: #selector(singleNavBackTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: back)
    }

    @objc func singleNavBackTapped() {
        singleExitGameLayout()
    }

    func singleExitGameLayout() {
        game_timer_tim?.invalidate()
        game_timer_tim = nil
        deck_tim.removeAll()
        grid_view_tim.singleReload(items: deck_tim)
        selected_indices_tim.removeAll()
        game_started_tim = false
        any_expired_tim = false
        score_tim = 0

        grid_view_tim.snp.remakeConstraints { make in
            make.top.equalTo(self.start_button_tim.snp.bottom).offset(12)
            make.left.right.equalTo(self.help_text_view_tim)
            make.bottom.equalTo(self.overlay_view_tim.snp.bottom).offset(-16)
        }

        self.help_text_view_tim.isHidden = false
        self.start_button_tim.isHidden = false
        self.record_button_tim.isHidden = false
        self.mode_segment_tim.isHidden = false
        self.mode_segment_tim.isEnabled = true
        self.help_text_view_tim.alpha = 0
        self.start_button_tim.alpha = 0
        self.record_button_tim.alpha = 0
        self.mode_segment_tim.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.help_text_view_tim.alpha = 1
            self.start_button_tim.alpha = 1
            self.record_button_tim.alpha = 1
            self.mode_segment_tim.alpha = 1
            self.view.layoutIfNeeded()
        }

        navigationItem.leftBarButtonItem = nil
    }
}



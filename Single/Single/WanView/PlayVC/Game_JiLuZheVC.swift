

import UIKit
import SnapKit

class Game_JiLuZheVC: UITableViewController {
    var records_tim: [String] = []
    let background_image_tim = UIImageView(image: UIImage(named: "singleFJ"))
    let overlay_view_tim = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Records"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        singleLoadRecords()
        singleSetupBackButton()
        singleSetupDeleteButton()
        singleSetupBackground()
    }

    func singleSetupBackButton() {
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
        back.addTarget(self, action: #selector(singleBackTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: back)
    }

    @objc func singleBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func singleSetupDeleteButton() {
        let deleteBtn = UIButton(type: .system)
        deleteBtn.setTitle("Clear All", for: .normal)
        deleteBtn.setTitleColor(.white, for: .normal)
        deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        deleteBtn.backgroundColor = UIColor.systemRed
        deleteBtn.layer.cornerRadius = 14
        deleteBtn.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        deleteBtn.layer.shadowColor = UIColor.black.cgColor
        deleteBtn.layer.shadowOpacity = 0.25
        deleteBtn.layer.shadowRadius = 6
        deleteBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        deleteBtn.addTarget(self, action: #selector(singleDeleteAllTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteBtn)
    }
    
    @objc func singleDeleteAllTapped() {
        guard !records_tim.isEmpty else {
            let alert = UIAlertController(title: "No Records", message: "There are no records to delete.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let alert = UIAlertController(title: "Delete All Records", message: "Are you sure you want to delete all game records? This action cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.singleConfirmDelete()
        })
        present(alert, animated: true)
    }
    
    func singleConfirmDelete() {
        UserDefaults.standard.removeObject(forKey: "records_tim")
        records_tim.removeAll()
        tableView.reloadData()
        
        let successAlert = UIAlertController(title: "Deleted", message: "All records have been deleted successfully.", preferredStyle: .alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: .default))
        present(successAlert, animated: true)
    }

    func singleLoadRecords() {
        let arr = UserDefaults.standard.stringArray(forKey: "records_tim") ?? []
        records_tim = arr
    }
}

extension Game_JiLuZheVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records_tim.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var cfg = cell.defaultContentConfiguration()
        cfg.text = records_tim[indexPath.row]
        cfg.textProperties.font = UIFont.monospacedDigitSystemFont(ofSize: 13, weight: .regular)
        cell.contentConfiguration = cfg
        cell.backgroundColor = .clear
        
       
        return cell
    }
}

extension Game_JiLuZheVC {
    func singleSetupBackground() {
        background_image_tim.contentMode = .scaleAspectFill
        background_image_tim.clipsToBounds = true
        tableView.backgroundView = UIView()
        tableView.backgroundView?.addSubview(background_image_tim)
        tableView.backgroundView?.addSubview(overlay_view_tim)

        overlay_view_tim.backgroundColor = UIColor.white.withAlphaComponent(0.35)
        overlay_view_tim.layer.cornerRadius = 18
        overlay_view_tim.layer.masksToBounds = true

        background_image_tim.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        overlay_view_tim.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-16)
            make.centerX.equalToSuperview()
           
        }

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
}



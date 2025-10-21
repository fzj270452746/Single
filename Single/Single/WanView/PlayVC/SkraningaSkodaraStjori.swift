

import UIKit
import SnapKit

// Skráningarskoðunarsíða fyrir leikjaskrár
class SkraningaSkodaraStjori: UITableViewController {
    var skraningar: [String] = []
    let bakgrunnsmynd = UIImageView(image: UIImage(named: "singleFJ"))
    let yfirlagsSyn = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Records"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reitur")
        hlodaSkraningar()
        uppsetjaTilbakaTakka()
        uppsetjaEydaTakka()
        uppsetjaBakgrunn()
    }

    func uppsetjaTilbakaTakka() {
        let tilbakaHnappur = UIButton(type: .system)
        tilbakaHnappur.setTitle("Back", for: .normal)
        tilbakaHnappur.setTitleColor(.white, for: .normal)
        tilbakaHnappur.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        tilbakaHnappur.backgroundColor = UIColor.systemBlue
        tilbakaHnappur.layer.cornerRadius = 14
        tilbakaHnappur.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        tilbakaHnappur.layer.shadowColor = UIColor.black.cgColor
        tilbakaHnappur.layer.shadowOpacity = 0.25
        tilbakaHnappur.layer.shadowRadius = 6
        tilbakaHnappur.layer.shadowOffset = CGSize(width: 0, height: 3)
        tilbakaHnappur.addTarget(self, action: #selector(tilbakaYtt), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tilbakaHnappur)
    }

    @objc func tilbakaYtt() {
        navigationController?.popViewController(animated: true)
    }
    
    func uppsetjaEydaTakka() {
        let eydaHnappur = UIButton(type: .system)
        eydaHnappur.setTitle("Clear All", for: .normal)
        eydaHnappur.setTitleColor(.white, for: .normal)
        eydaHnappur.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        eydaHnappur.backgroundColor = UIColor.systemRed
        eydaHnappur.layer.cornerRadius = 14
        eydaHnappur.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        eydaHnappur.layer.shadowColor = UIColor.black.cgColor
        eydaHnappur.layer.shadowOpacity = 0.25
        eydaHnappur.layer.shadowRadius = 6
        eydaHnappur.layer.shadowOffset = CGSize(width: 0, height: 3)
        eydaHnappur.addTarget(self, action: #selector(eydaOllumYtt), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: eydaHnappur)
    }
    
    @objc func eydaOllumYtt() {
        guard !skraningar.isEmpty else {
            let vidbod = UIAlertController(title: "No Records", message: "There are no records to delete.", preferredStyle: .alert)
            vidbod.addAction(UIAlertAction(title: "OK", style: .default))
            present(vidbod, animated: true)
            return
        }
        
        let vidbod = UIAlertController(title: "Delete All Records", message: "Are you sure you want to delete all game records? This action cannot be undone.", preferredStyle: .alert)
        vidbod.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        vidbod.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.stadfestaEydingu()
        })
        present(vidbod, animated: true)
    }
    
    func stadfestaEydingu() {
        UserDefaults.standard.removeObject(forKey: "records_tim")
        skraningar.removeAll()
        tableView.reloadData()
        
        let tokstVidbod = UIAlertController(title: "Deleted", message: "All records have been deleted successfully.", preferredStyle: .alert)
        tokstVidbod.addAction(UIAlertAction(title: "OK", style: .default))
        present(tokstVidbod, animated: true)
    }

    func hlodaSkraningar() {
        let fylki = UserDefaults.standard.stringArray(forKey: "records_tim") ?? []
        skraningar = fylki
    }
}

extension SkraningaSkodaraStjori {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skraningar.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reitur = tableView.dequeueReusableCell(withIdentifier: "reitur", for: indexPath)
        var stillingu = reitur.defaultContentConfiguration()
        stillingu.text = skraningar[indexPath.row]
        stillingu.textProperties.font = UIFont.monospacedDigitSystemFont(ofSize: 13, weight: .regular)
        reitur.contentConfiguration = stillingu
        reitur.backgroundColor = .clear
        
        return reitur
    }
}

extension SkraningaSkodaraStjori {
    func uppsetjaBakgrunn() {
        bakgrunnsmynd.contentMode = .scaleAspectFill
        bakgrunnsmynd.clipsToBounds = true
        tableView.backgroundView = UIView()
        tableView.backgroundView?.addSubview(bakgrunnsmynd)
        tableView.backgroundView?.addSubview(yfirlagsSyn)

        yfirlagsSyn.backgroundColor = UIColor.white.withAlphaComponent(0.35)
        yfirlagsSyn.layer.cornerRadius = 18
        yfirlagsSyn.layer.masksToBounds = true

        bakgrunnsmynd.snp.makeConstraints { taka in
            taka.edges.equalToSuperview()
        }
        yfirlagsSyn.snp.makeConstraints { taka in
            taka.left.equalToSuperview().offset(10)
            taka.right.equalToSuperview().offset(-10)
            taka.top.equalToSuperview().offset(10)
            taka.bottom.equalToSuperview().offset(-16)
            taka.centerX.equalToSuperview()
        }

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
}


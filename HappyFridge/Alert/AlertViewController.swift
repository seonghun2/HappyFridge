//
//  AlertViewController.swift
//  HappyFridge
//
//  Created by user on 2022/11/08.
//

import UIKit
import UserNotifications
import SnapKit

class AlertViewController: UIViewController {
    
    var alerts: [Alert] = []
    var showingAlerts: [Alert] = []
    
    let emptyText: UILabel = {
        let label = UILabel()
        label.text = "등록된 알림이 없습니다"
        label.textColor = .systemGray3
        return label
    }()
    
    let emptyImage = UIImageView(image: UIImage(named: "emptyFridge"))
    
    @IBOutlet weak var alertTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setEmptyImage()
 
        alertTableView.dataSource = self
        alertTableView.rowHeight = 100
        alertTableView.allowsSelection = false
        
        alertTableView.register(UINib(nibName: "AlertCell", bundle: nil), forCellReuseIdentifier: "AlertCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DataManager().getAlertData { [weak self] alerts in
            self?.alerts = alerts
            self?.showingAlerts = self?.alerts.filter { $0.alertDate.compare(Date()) == .orderedAscending } ?? []
            self?.showingAlerts.sort { $0.alertDate > $1.alertDate }
            
            if self?.showingAlerts.isEmpty ?? false {
                self?.emptyText.isHidden = false
                self?.emptyImage.isHidden = false
            } else {
                self?.emptyText.isHidden = true
                self?.emptyImage.isHidden = true
            }
            
            self?.alertTableView.reloadData()
        }
        
    }
    
    func setEmptyImage() {
        alertTableView.addSubview(emptyImage)
        emptyImage.snp.makeConstraints { make in
            make.width.equalTo(89)
            make.height.equalTo(120)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        alertTableView.addSubview(emptyText)
        emptyText.snp.makeConstraints { make in
            make.top.equalTo(emptyImage.snp.bottom).offset(4)
            make.centerX.equalTo(emptyImage.snp.centerX)
        }
    }
}

extension AlertViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showingAlerts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertCell", for: indexPath) as! AlertCell
        
        cell.alertMessageLabel.text = showingAlerts[indexPath.row].alertMessage
        
        let alertDate = showingAlerts[indexPath.row].alertDate
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        let dateString = formatter.string(from: alertDate)
        cell.alertDateLabel.text = dateString
        
        return cell
    }
    
    
}

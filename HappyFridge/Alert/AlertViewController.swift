//
//  AlertViewController.swift
//  HappyFridge
//
//  Created by user on 2022/11/08.
//

import UIKit
import UserNotifications

class AlertViewController: UIViewController {
    var alerts: [Alert] = []
    var showingAlerts: [Alert]?
    @IBOutlet weak var alertTableView: UITableView!
    
    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()
        
        DataManager().getAlertData { [weak self] alerts in
            self?.alerts = alerts
            self?.showingAlerts = self?.alerts.filter { $0.alertDate.compare(Date()) == .orderedAscending }.sorted { $0.alertDate > $1.alertDate }
            self?.alertTableView.reloadData()
        }

        alertTableView.dataSource = self
        alertTableView.rowHeight = 100
        alertTableView.allowsSelection = false
        
        alertTableView.register(UINib(nibName: "AlertCell", bundle: nil), forCellReuseIdentifier: "AlertCell")
    }
    override func viewDidAppear(_ animated: Bool) {
        alertTableView.reloadData()
    }
}
extension AlertViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showingAlerts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertCell", for: indexPath) as! AlertCell
        
        cell.alertMessageLabel.text = showingAlerts?[indexPath.row].alertMessage
        
        let alertDate = showingAlerts?[indexPath.row].alertDate ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        var dateString = formatter.string(from: alertDate)
        cell.alertDateLabel.text = dateString
        
        return cell
    }
    
    
}

//
//  RefrigeSmallCell.swift
//  HappyFridge
//
//  Created by user on 2022/10/30.
//

import UIKit

class RefrigeSmallCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setItemListTableView()
    }
    
    func setItemListTableView() {
        itemListTableView.dataSource = self
        itemListTableView.register(UINib(nibName: "RefrigeItemListCell", bundle: nil), forCellReuseIdentifier: "RefrigeItemListCell")
        itemListTableView.rowHeight = 25
        itemListTableView.backgroundColor = .clear
        itemListTableView.separatorColor = .clear
        itemListTableView.isScrollEnabled = false
        itemListTableView.allowsSelection = false
    }
    
    var itemList: [Item] = []
    
    var isshared: Bool = false
    
    @IBOutlet weak var refrigeNameLabel: UILabel!
    
    @IBOutlet weak var itemListTableView: UITableView!
    
    @IBOutlet weak var refrigeSettingButtton: UIButton!
    
    func getDdayInt(date: Date) -> Int {
        if let dayDiff = Calendar.current.dateComponents([.day], from: Date(), to: date).day {
            return dayDiff
        }
        return 999
    }
}

extension RefrigeSmallCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemList.count < 5 {
            return itemList.count
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RefrigeItemListCell", for: indexPath) as! RefrigeItemListCell
        print(indexPath.row,itemList)
        
        cell.itemNameLabel.text = itemList[indexPath.row].name
        
        let dayLeft = getDdayInt(date: itemList[indexPath.row].expirationDate)
        if dayLeft > 7 {
            cell.DdayLabel.backgroundColor = .green
            cell.DdayLabel.text = "d-\(dayLeft)"
        } else if dayLeft < 0{
            cell.DdayLabel.backgroundColor = .red
            cell.DdayLabel.text = "d+\(dayLeft * -1)"
        } else {
            cell.DdayLabel.backgroundColor = .blue
            cell.DdayLabel.text = "d-\(dayLeft)"
        }
        
        cell.DdayLabel.textAlignment = .center
        cell.DdayLabel.clipsToBounds = true
        cell.DdayLabel.layer.cornerRadius = 10
        return cell
    }
}

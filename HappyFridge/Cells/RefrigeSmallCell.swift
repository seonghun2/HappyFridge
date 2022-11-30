//
//  RefrigeSmallCell.swift
//  HappyFridge
//
//  Created by user on 2022/10/30.
//

import UIKit
import SnapKit
class RefrigeSmallCell: UICollectionViewCell {
    
    var eventClosure: (() -> ())?
    var tapEventClosure: (() -> ())?
    
    var showLarge: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setItemListTableView()
    }
    
    func setItemListTableView() {
        itemListTableView.dataSource = self
        itemListTableView.register(UINib(nibName: "RefrigeItemListCell", bundle: nil), forCellReuseIdentifier: "RefrigeItemListCell")
        itemListTableView.register(UINib(nibName: "RefrigeItemListLargeCell", bundle: nil), forCellReuseIdentifier: "RefrigeItemListLargeCell")
        
        itemListTableView.backgroundColor = .clear
        itemListTableView.separatorColor = .clear
        itemListTableView.isScrollEnabled = false
        itemListTableView.allowsSelection = false
        
        if showLarge {
            itemListTableView.rowHeight = 48
        } else {
            itemListTableView.rowHeight = 30
        }
        
    }
    
    var itemList: [Item] = []
    
    //var isshared: Bool = false
    
    @IBOutlet weak var refrigeNameLabel: UILabel!
    
    @IBOutlet weak var itemListTableView: UITableView!
    
    @IBOutlet weak var refrigeSettingButtton: UIButton!
    
    func getDdayInt(date: Date) -> Int {
        
        let date1 = Calendar.current.dateComponents([.year,.month,.day], from: date)
        let date2 = Calendar.current.dateComponents([.year,.month,.day], from: Date())
        
        let daydiff = Calendar.current.dateComponents([.day], from: date2, to: date1).day
        
        return daydiff ?? 0
    }
    
    @IBAction func fridgeSettingButtonTapped(_ sender: UIButton) {
        print(#function)
        eventClosure?()
    }
    
    @IBAction func cellTapped(_ sender: UIButton) {
        tapEventClosure?()
    }
    
}

extension RefrigeSmallCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showLarge {
            if itemList.count < 8 {
                return itemList.count
            } else {
                return 7
            }
        } else {
            if itemList.count < 5 {
                return itemList.count
            } else {
                return 4
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "RefrigeItemListCell", for: indexPath) as! RefrigeItemListCell
        if showLarge {
            cell = tableView.dequeueReusableCell(withIdentifier: "RefrigeItemListLargeCell", for: indexPath) as! RefrigeItemListCell
        }
        
        cell.itemNameLabel.text = itemList[indexPath.row].name
        
        let dayLeft = getDdayInt(date: itemList[indexPath.row].expirationDate ?? Date())
        
        if showLarge {
//            cell.itemNameLabel.font = .systemFont(ofSize: 16)
//            cell.DdayLabel.font = .systemFont(ofSize: 16)
//
//            cell.DdayLabel.snp.updateConstraints { make in
//                make.width.equalTo(72)
//                make.height.equalTo(26)
//            }
//
            if dayLeft > 7 {
                cell.DdayLabel.backgroundColor = UIColor(hexString: "#DFF4C5")
                cell.DdayLabel.text = "\(dayLeft)일 남음"
            } else if dayLeft < 0{
                cell.DdayLabel.backgroundColor = UIColor(hexString: "#FFDAD1")
                cell.DdayLabel.text = "\(dayLeft * -1)일 지남"
            } else {
                cell.DdayLabel.backgroundColor = UIColor(hexString: "#FFE4C3")
                cell.DdayLabel.text = "\(dayLeft)일 남음"
            }
        } else {

            if dayLeft > 7 {
                cell.DdayLabel.backgroundColor = UIColor(hexString: "#DFF4C5")
                cell.DdayLabel.text = "d-\(dayLeft)"
            } else if dayLeft < 0{
                cell.DdayLabel.backgroundColor = UIColor(hexString: "#FFDAD1")
                cell.DdayLabel.text = "d+\(dayLeft * -1)"
            } else {
                cell.DdayLabel.backgroundColor = UIColor(hexString: "#FFE4C3")
                cell.DdayLabel.text = "d-\(dayLeft)"
            }
        }
        
        cell.DdayLabel.textAlignment = .center
        cell.DdayLabel.clipsToBounds = true
        cell.DdayLabel.layer.cornerRadius = 10
        return cell
    }
}

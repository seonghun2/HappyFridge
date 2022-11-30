//
//  FridgeDetailCellTableViewCell.swift
//  HappyFridge
//
//  Created by LCW on 2022/11/08.
//

import UIKit

class FridgeDetailCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foodCountLabel: UILabel!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var d_dayLabel: UILabel!
    
    @IBOutlet weak var expirationDateLabel: UILabel!
    
    weak var delegate: TableViewCellDelegate?
    var index: Int?
    var food: Item?
    var count: Int?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.foodCountLabel.layer.cornerRadius = 4
        self.expirationDateLabel.layer.cornerRadius = 16
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setFoodInfo(food: Item) {
        foodName.text = food.name
        foodCountLabel.text = String(food.count!)
        print(food.expirationDate)
        
        let date = food.expirationDate
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        let stringDate = formatter.string(from: date!)
        print(stringDate)
        expirationDateLabel.text = "\(stringDate)까지"
      
        let dayLeft = getDdayInt(date: food.expirationDate!)
        if dayLeft > 7 {
            d_dayLabel.backgroundColor = UIColor(hexString: "#DFF4C5")
            d_dayLabel.text = "\(dayLeft)일 남음"
        } else if dayLeft < 0{
            d_dayLabel.backgroundColor = UIColor(hexString: "#FFDAD1")
            d_dayLabel.text = "\(dayLeft * -1)일 지남"
        } else {
            d_dayLabel.backgroundColor = UIColor(hexString: "#FFE4C3")
            d_dayLabel.text = "\(dayLeft)일 남음"
        }
    }
    
    //D-day 계산
    func getDdayInt(date: Date) -> Int {
        let date1 = Calendar.current.dateComponents([.year,.month,.day], from: date)
             let date2 = Calendar.current.dateComponents([.year,.month,.day], from: Date())
             
             let daydiff = Calendar.current.dateComponents([.day], from: date2, to: date1).day
             return daydiff ?? 0
    }
    
    @IBAction func deleteFoodAction(_ sender: Any) {
        print("x버튼 클릭 cell")
        self.delegate?.deleteButton(index: index,food: food)
    }
    
    @IBAction func updateFoodCountAction(_ sender: Any) {
        print("물품 클릭 cell")
        self.delegate?.showFoodCountPopUp(index: index,count: count)
    }
}

protocol TableViewCellDelegate: AnyObject {
    func deleteButton(index: Int?,food: Item?)
    func showFoodCountPopUp(index: Int?, count: Int?)
}

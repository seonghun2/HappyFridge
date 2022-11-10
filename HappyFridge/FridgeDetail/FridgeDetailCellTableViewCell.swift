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
    var food: Food?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        foodCountLabel.layer.cornerRadius = 4
        expirationDateLabel.layer.cornerRadius = 16
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setFoodInfo(food: Food) {
        foodName.text = food.foodName
        foodCountLabel.text = String(food.count)
        print(food.expirationDate)
        
        let date = food.expirationDate
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        let stringDate = formatter.string(from: date)
        print(stringDate)
        expirationDateLabel.text = "\(stringDate)까지"
    }
    @IBAction func deleteFoodAction(_ sender: Any) {
        print("x버튼 클릭 cell")
        self.delegate?.deleteButton(index: index,food: food)
    }
    
}

protocol TableViewCellDelegate: AnyObject {
    func deleteButton(index: Int?,food: Food?)
}

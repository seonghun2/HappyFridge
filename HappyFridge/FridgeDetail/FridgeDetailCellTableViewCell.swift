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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        foodCountLabel.layer.cornerRadius = 4
        expirationDateLabel.layer.cornerRadius = 16
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

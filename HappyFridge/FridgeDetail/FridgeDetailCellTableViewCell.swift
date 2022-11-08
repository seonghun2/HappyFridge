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
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
        foodCountLabel.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

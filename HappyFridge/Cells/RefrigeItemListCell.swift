//
//  RefrigeItemListCell.swift
//  HappyFridge
//
//  Created by user on 2022/11/05.
//

import UIKit

class RefrigeItemListCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var DdayLabel: UILabel!
    
    var showLarge: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

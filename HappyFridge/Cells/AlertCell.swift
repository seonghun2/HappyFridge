//
//  AlertCell.swift
//  HappyFridge
//
//  Created by user on 2022/11/22.
//

import UIKit

class AlertCell: UITableViewCell {

    @IBOutlet weak var alertTitleLabel: UILabel!
    
    @IBOutlet weak var alertMessageLabel: UILabel!
    
    @IBOutlet weak var alertDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

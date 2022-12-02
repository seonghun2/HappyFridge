//
//  SettingListCell.swift
//  HappyFridge
//
//  Created by user on 2022/11/17.
//

import UIKit

class SettingListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    @IBAction func toggleSwitchTapped(_ sender: Any) {
        print(#function)
        UserDefaults.standard.set(toggleSwitch.isOn, forKey: "showLarge")

    }
    override func awakeFromNib() {
        super.awakeFromNib()
        toggleSwitch.isOn = UserDefaults.standard.bool(forKey: "showLarge")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

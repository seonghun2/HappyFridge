//
//  InsertFoodViewController.swift
//  HappyFridge
//
//  Created by user on 2022/11/19.
//

import UIKit

class InsertFoodViewController: UIViewController {
    
    //var dragedFood: Item?
    
    var destinationFridge: Refrigerator?

    var foodCount: Int = 1
    
    // 수량, 유통기한, 알림여부, 알림 몇일전에 할건지
    var addEventClosure: ((Int, Date, Bool, Int) -> ())?
    
    var alertSwitchState: Bool = false
    
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var foodnameLabel: UILabel!
    
    @IBOutlet weak var foodCountTextField: UITextField!
    
    @IBOutlet weak var expirationDatePicker: UIDatePicker!
    
    @IBOutlet weak var alertSwitch: UISwitch!
    
    @IBOutlet weak var alertDayTextField: UITextField!
    
    @IBOutlet weak var alertDayLabel: UILabel!
    
    @IBAction func switchTapped(_ sender: Any) {
        if alertSwitch.isOn {
            alertSwitch.setOn(true, animated: true)
            alertDayTextField.isUserInteractionEnabled = true
            alertDayTextField.backgroundColor = .systemGray
            alertSwitchState = true
            alertDayLabel.textColor = .black
        } else {
            alertSwitch.setOn(false, animated: true)
            alertDayTextField.isUserInteractionEnabled = false
            alertDayTextField.backgroundColor = .systemGray3
            alertSwitchState = false
            alertDayLabel.textColor = .systemGray4
        }
    }
    
    @IBAction func minusButtonTapped(_ sender: Any) {
        if foodCount > 1{
            foodCount -= 1
            foodCountTextField.text = "\(foodCount)"
        }
        
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        foodCount += 1
        foodCountTextField.text = "\(foodCount)"
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        var expirationDay =  Calendar.current.dateComponents([.year,.month,.day], from: expirationDatePicker.date)
        let date = Calendar.current.date(from: expirationDay) ?? Date()
        addEventClosure?(Int(foodCountTextField.text ?? "0") ?? 0, date, alertSwitchState, Int(alertDayTextField.text ?? "0") ?? 0)
        dismiss(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popupView.layer.cornerRadius = 10
        foodCountTextField.keyboardType = .numberPad
        expirationDatePicker.backgroundColor = .systemGray3
        expirationDatePicker.layer.cornerRadius = 5
        expirationDatePicker.layer.masksToBounds = true
        alertDayLabel.textColor = .systemGray4
        alertDayTextField.isUserInteractionEnabled = false
        alertDayTextField.keyboardType = .numberPad
        foodCountTextField.text = "\(foodCount)"
        
        //foodnameLabel.text = "\((dragedFood?.name)!) -> \((destinationFridge?.fridgeName)!)"
    }
}

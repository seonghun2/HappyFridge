//
//  AddFoodViewController.swift
//  HappyFridge
//
//  Created by LCW on 2022/11/15.
//

import UIKit

class AddFoodViewController: UIViewController {

    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var foodCountTextField: UITextField!
    @IBOutlet weak var alarmDayTextField: UITextField!

    @IBOutlet weak var addButton: UIButton!

    var foodCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        addButton.layer.cornerRadius = 8
        foodCountTextField.layer.cornerRadius = 4
        alarmDayTextField.layer.cornerRadius = 4
        foodCountTextField.text = String(foodCount)

        startButtonActivate(activate: false)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


    @IBAction func minusAction(_ sender: Any) {
        foodCount = Int(foodCountTextField.text!)!
        if foodCount == 0 {
            return
        }else {
            foodCount -= 1
            foodCountTextField.text = String(foodCount)
        }
    }
    @IBAction func plusAction(_ sender: Any) {
        foodCount = Int(foodCountTextField.text!)!
        foodCount += 1
        foodCountTextField.text = String(foodCount)
    }
    @IBAction func addAction(_ sender: Any) {

    }

    func startButtonActivate(activate:Bool) {
        if activate {
            self.addButton.isEnabled = true
            self.addButton.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5882352941, blue: 0.1254901961, alpha: 1)

        } else {
            self.addButton.isEnabled = false
            self.addButton.backgroundColor = .gray
        }
    }

}

//
//  AddFoodViewController.swift
//  HappyFridge
//
//  Created by LCW on 2022/11/15.
//

import UIKit
import FirebaseFirestore

class AddFoodViewController: UIViewController {

    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var foodCountTextField: UITextField!
    @IBOutlet weak var alarmDayTextField: UITextField!

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    var foodCount = 0
    var fridgesInfoArray: [Fridge] = []
    var foodInfoArray: [Food] = []
    
    lazy var db = Firestore.firestore()
    
    // 데이터 전달 클로저
    var dataSendClosure: ((_ data: String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        addButton.layer.cornerRadius = 8
        foodCountTextField.layer.cornerRadius = 4
        alarmDayTextField.layer.cornerRadius = 4
        foodCountTextField.text = String(foodCount)

        addButtonActivate(activate: true)
        
        print("foodinfoarray")
        print(foodInfoArray)
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
        addFood()
    }

    func addButtonActivate(activate:Bool) {
        if activate {
            addButton.isEnabled = true
            addButton.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5882352941, blue: 0.1254901961, alpha: 1)

        } else {
            addButton.isEnabled = false
            addButton.backgroundColor = .gray
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //냉장고안에 물품 추가
    func addFood() {
        print("foodInfoArray")
        print(foodInfoArray)
        let date = Date()
        let fd = Food(foodName: foodNameTextField.text!, count:foodCount, expirationDate: date)
        foodInfoArray.append(fd)
        fridgesInfoArray[0].food.removeAll()
        fridgesInfoArray[0].food.append(contentsOf: self.foodInfoArray)

        let frid = Fridges(fridge: self.fridgesInfoArray)
        do {
            try db.collection("fridge").document("이청우1").setData(from: frid, merge: true)
            self.dataSendClosure?("물품추가")
            dismiss(animated: true)
        } catch {
            print(error)
        }
    }

}

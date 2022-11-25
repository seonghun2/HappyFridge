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
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var foodCount = 0
    var index = 0
    var fridgesInfoArray: [Fridge] = []
    var foodInfoArray: [Food] = []
    var expirationDate: Date?
    private var alarmCheck = false
    
    lazy var db = Firestore.firestore()
    
    // 데이터 전달 클로저
    var dataSendClosure: ((_ data: String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.contentHorizontalAlignment = .left
        
        addButton.layer.cornerRadius = 8
        foodCountTextField.layer.cornerRadius = 4
        alarmDayTextField.layer.cornerRadius = 4
        foodCountTextField.text = String(foodCount)
        
        addButtonActivate(activate: false)
        
        print("foodinfoarray")
        print(foodInfoArray)
        
        self.foodNameTextField.addTarget(self, action: #selector(self.foodNameDidChanged(_:)), for: .editingChanged)
        self.foodCountTextField.addTarget(self, action: #selector(self.foodCountDidChanged(_:)), for: .editingChanged)
        
    }
    
    @objc func foodNameDidChanged(_ sender: UITextField) {
        print("text변경 감지 name")
        if sender.text != "" && foodCountTextField.text != "" && foodCountTextField.text != nil && foodCountTextField.text != "0" {
            self.addButtonActivate(activate: true)
        }else {
            self.addButtonActivate(activate: false)
        }
        
    }
    
    @objc func foodCountDidChanged(_ sender: UITextField) {
        print("text변경 감지 count")
        if sender.text != "" && sender.text != "0" && foodNameTextField.text != "" && foodNameTextField.text != nil  {
            self.addButtonActivate(activate: true)
        }else {
            self.addButtonActivate(activate: false)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func minusAction(_ sender: Any) {
        foodCount = Int(foodCountTextField.text ?? "0") ?? 0
        if foodCount == 0 {
            return
        }else {
            if foodCount == 1 {
                addButtonActivate(activate: false)
            }
            foodCount -= 1
            foodCountTextField.text = String(foodCount)
            
            if foodNameTextField.text != nil && foodCount != 0 {
                addButtonActivate(activate: true)
            }
        }
    }
    @IBAction func plusAction(_ sender: Any) {
        foodCount = Int(foodCountTextField.text ?? "0") ?? 0
        foodCount += 1
        foodCountTextField.text = String(foodCount)
        if foodNameTextField.text != nil && foodNameTextField.text != "" {
            addButtonActivate(activate: true)
        }
    }
    @IBAction func addAction(_ sender: Any) {
        addFood()
    }
    
    @IBAction func alarmCheck(_ sender: Any) {
        print(alarmSwitch.isOn)
        alarmCheck = alarmSwitch.isOn
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
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
        print("날짜선택")
        print(sender.date)
        expirationDate = sender.date
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //냉장고안에 물품 추가
    func addFood() {
        let nowDate = Date()
        let alertDayValue = Int(alarmDayTextField.text ?? "0")
        let fd = Food(foodName: foodNameTextField.text!, count:foodCount, expirationDate: expirationDate ?? nowDate, createDate: nowDate, performAlert: alarmCheck , alertDay: alertDayValue ?? 0)
        foodInfoArray.append(fd)
        fridgesInfoArray[index].food?.removeAll()
        fridgesInfoArray[index].food?.append(contentsOf: self.foodInfoArray)
        
        let frid = Fridges(fridge: self.fridgesInfoArray)
        do {
            try db.collection("fridge").document(Constant.nickName!).setData(from: frid, merge: true)
            self.dataSendClosure?("물품추가")
            dismiss(animated: true)
        } catch {
            print(error)
        }
    }
    
}

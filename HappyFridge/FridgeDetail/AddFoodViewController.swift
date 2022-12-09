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
    
    var dataManager = DataManager()
    
    var foodCount = 0
    var index = 0
    var fridgesInfoArray: [Refrigerator] = []
    var foodInfoArray: [Item] = []
    var expirationDate: Date?
    private var alarmCheck = false
    
    lazy var db = Firestore.firestore()
    
    // 데이터 전달 클로저
    var dataSendClosure: ((_ data: String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodCountTextField.keyboardType = .numberPad
        alarmDayTextField.keyboardType = .numberPad
        datePicker.contentHorizontalAlignment = .left
        
        addButton.layer.cornerRadius = 8
        foodCountTextField.layer.cornerRadius = 4
        alarmDayTextField.layer.cornerRadius = 4
        foodCountTextField.text = String(foodCount)
        
        addButtonActivate(activate: false)
        self.foodNameTextField.addTarget(self, action: #selector(self.foodNameDidChanged(_:)), for: .editingChanged)
        self.foodCountTextField.addTarget(self, action: #selector(self.foodCountDidChanged(_:)), for: .editingChanged)
        
    }
    
    @objc func foodNameDidChanged(_ sender: UITextField) {
        if sender.text != "" && foodCountTextField.text != "" && foodCountTextField.text != nil && foodCountTextField.text != "0" {
            self.addButtonActivate(activate: true)
        }else {
            self.addButtonActivate(activate: false)
        }
        
    }
    
    @objc func foodCountDidChanged(_ sender: UITextField) {
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
        print(sender.date)
        expirationDate = sender.date
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //냉장고안에 물품 추가
    func addFood() {
        let nowDate = Date()
        let alertDayValue = Int(alarmDayTextField.text ?? "0")
        let addFoodInfo = Item(name: foodNameTextField.text!, isBookmarked: false, performAlert: false, expirationDate: expirationDate ?? nowDate, count: foodCount, createDate: nowDate, alertDay: alertDayValue ?? 0)
        foodInfoArray.append(addFoodInfo)
        fridgesInfoArray[index].food?.removeAll()
        
        fridgesInfoArray[index].food?.append(contentsOf: self.foodInfoArray)
        
        let frid = Refrigerators(fridges: self.fridgesInfoArray)
        do {
            try db.collection("fridge").document(Constant.nickName!).setData(from: frid, merge: true)
            self.dataSendClosure?("물품추가")
            
            if alarmSwitch.isOn {
                var alertMessage = "\(fridgesInfoArray[index].fridgeName)에 있는 \(addFoodInfo.name)의 유통기한이 \(alertDayValue ?? 0)일 남았습니다."
                if alertDayValue == 0 {
                    alertMessage = "\(fridgesInfoArray[index].fridgeName)에 있는 \(addFoodInfo.name)의 유통기한이 오늘까지 입니다."
                }
                let alertDate = Calendar.current.date(byAdding: .day, value: -(alertDayValue ?? 0), to: expirationDate ?? nowDate)
                let alert = Alert(alertDate: alertDate!, alertMessage: alertMessage)
                alert.generateAlert()
                dataManager.addAlert(alert: alert)
            }
            
            self.navigationController?.popViewController(animated: true)
        } catch {
            print(error)
        }
    }
    
}

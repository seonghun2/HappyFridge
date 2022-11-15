//
//  PopUpFoodCountUpdate.swift
//  HappyFridge
//
//  Created by LCW on 2022/11/14.
//

import UIKit


class PopUpFoodCountUpdate: UIViewController {
    
    @IBOutlet weak var countTextField: UITextField!
    
    var delegate: PopUpFoodCountDelegate?
    var foodCount: Int?
    var foodIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: false) {
            print("취소버튼 popup")
        }
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        print("저장버튼 popup")
        foodCount = Int((self.countTextField.text)!)
        self.delegate?.confirmButton(foodIndex:foodIndex,count: foodCount)
        
    }
    
    @IBAction func countMinusAction(_ sender: Any) {
        print("-버튼 popup")
        if var fc = foodCount {
            fc -= 1
            foodCount = fc
            self.countTextField.text = String(fc)
            
        }
    }
    
    @IBAction func countPlusAction(_ sender: Any) {
        print("+버튼 popup")
        if var fc = foodCount {
            fc += 1
            foodCount = fc
            self.countTextField.text = String(fc)
        }
    }
}

protocol PopUpFoodCountDelegate {
    func confirmButton(foodIndex: Int?, count:Int?)
}

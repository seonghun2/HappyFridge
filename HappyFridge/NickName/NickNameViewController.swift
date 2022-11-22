//
//  NickNameViewController.swift
//  HappyFridge
//
//  Created by LCW on 2022/10/30.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import Alamofire
import FirebaseFirestoreSwift

class NickNameViewController: UIViewController {
    
    @IBOutlet weak var nickNameCheckLabel: UILabel!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var nickNameCheckButton: UIButton!
    
    var userLoginToken:String = ""
    lazy var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("kakaoid: \(userLoginToken)")
        
        nickNameCheckButton.layer.cornerRadius = 16
        startButton.layer.cornerRadius = 8
        
        self.nickNameTextField.addTarget(self, action: #selector(self.nickNameDidChanged(_:)), for: .editingChanged)
        startButtonActivate(activate: false)
    }
    
    // MARK: 닉네임 중복체크
    func nickNameCheck(nickName: String) {
        self.nickNameCheckLabel.isHidden = false
        let userDB = db.collection("users")
        // 입력한 닉네임 있는지 확인 쿼리
        let query = userDB.whereField("nickName", isEqualTo: nickName)
        query.getDocuments() { (qs, err) in
            
            if qs!.documents.isEmpty {
                print("데이터 중복 안 됨 가입 진행 가능")
                self.nickNameCheckLabel.textColor = .label
                self.nickNameCheckLabel.text = "사용가능한 닉네임 입니다."
                
                self.startButtonActivate(activate: true)
            } else {
                print("데이터 중복 됨 가입 진행 불가")
                self.nickNameCheckLabel.textColor = .red
                self.nickNameCheckLabel.text = "이미 사용중인 닉네임 입니다."
            }
        }
        
    }
    
    // MARK: 닉네임 입력 값 변화감지
    @objc func nickNameDidChanged(_ sender: UITextField) {
        print("text변경 감지")
        startButtonActivate(activate: false)
        
    }
    
    func startButtonActivate(activate:Bool) {
        if activate {
            startButton.isEnabled = true
            startButton.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5882352941, blue: 0.1254901961, alpha: 1)
            
        } else {
            startButton.isEnabled = false
            startButton.backgroundColor = .gray
        }
    }
    
    // MARK: FireStore유저정보 저장
    func insertUserInfo() {
        let registerDate = Date()
        print(registerDate)
        
        db.collection("users").document(nickNameTextField.text!).setData(["nickName" : nickNameTextField.text!,"token":userLoginToken,"registerDate":registerDate])
        
        //로그인 했다는 이력 저장
        UserDefaults.standard.set(true, forKey: "Login")
        UserDefaults.standard.set(nickNameTextField.text!, forKey: "nickName")
        
        
        //나의 냉장고 화면으로 이동
        let vc = MainViewController(nibName:"MainViewController", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func nickNameCheckAction(_ sender: Any) {
        view.endEditing(true)
        nickNameCheck(nickName: nickNameTextField.text ?? "")
    }
    @IBAction func startAction(_ sender: Any) {
        insertUserInfo()
    }
    
}


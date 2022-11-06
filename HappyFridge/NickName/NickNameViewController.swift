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
    
    var kakaoUserId:String = ""
    lazy var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("kakaoid: \(kakaoUserId)")
        
        self.nickNameTextField.addTarget(self, action: #selector(self.nickNameDidChanged(_:)), for: .editingChanged)
        startButtonActivate(activate: false)
        
        //getTest()
        getInfoTest()
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
                self.nickNameCheckLabel.text = "중복된 닉네임 입니다."
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
            self.startButton.isEnabled = true
            self.startButton.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            
        } else {
            self.startButton.isEnabled = false
            self.startButton.backgroundColor = .gray
        }
    }
    
    // MARK: FireStore유저정보 저장
    func insertUserInfo() {
        let registerDate = Date()
        print(registerDate)
        
        db.collection("users").document(nickNameTextField.text!).setData(["nickName" : nickNameTextField.text!,"token":kakaoUserId,"registerDate":registerDate])
        
        //로그인 했다는 이력 저장
        UserDefaults.standard.set(true, forKey: "Login")
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {         self.view.endEditing(true)
    }
    
    
    
    @IBAction func nickNameCheckAction(_ sender: Any) {
        nickNameCheck(nickName: nickNameTextField.text ?? "")
    }
    @IBAction func startAction(_ sender: Any) {
        insertUserInfo()
    }
    
    // 냉장고 정보 가져오기 테스트
    func getInfoTest() {
        let docRef = db.collection("fridge").document("횡성훈")
        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print("Error getting document: \(error.localizedDescription)")
            }else {
                if let document = document {
                    do {
                        print(try document.data(as: Fridges.self).fridge[0].fridgeName)
                        
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    
    // 냉장고 생성 하기 테스트
    func getTest() {
        let date = Date()
        db.collection("fridge").document("횡성훈")
            .setData(["fridge": FieldValue.arrayUnion([["fridgeName" : "냉장고",
                                                        "owner": "횡성훈",
                                                        "createDate": date]])],merge: true)
        
    }
    
}


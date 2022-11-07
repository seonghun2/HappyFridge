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
   
    var kakaoUserId:String = ""
    lazy var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("kakaoid: \(kakaoUserId)")
    
        nickNameCheckButton.layer.cornerRadius = 16
        startButton.layer.cornerRadius = 8
        
        self.nickNameTextField.addTarget(self, action: #selector(self.nickNameDidChanged(_:)), for: .editingChanged)
        startButtonActivate(activate: false)
        
        //getTest()
        getInfoTest()
        //getFood()
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
            self.startButton.isEnabled = true
            self.startButton.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5882352941, blue: 0.1254901961, alpha: 1)
            
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
    
    // 냉장고 정보 가져오기 테스트
    func getInfoTest() {
        //let docRef = db.collection("fridge").document(Constant.nickName!)
        let docRef = db.collection("fridge").document("횡성훈")
        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print("Error getting document: \(error.localizedDescription)")
            }else {
                if let document = document {
                    do {
                        print("do")
                        
                        if document.data()?.count == nil {
                            print("냉장고없음")
                            
                            
                        }else {
                            print("냉장고있음")
                            print(try document.data(as: Fridges.self).fridge)
                        }
                        
                        
                    }
                    catch {
                        print("catch")
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
    
    //기본 물품 조회 테스트
//    func getFood() {
//        db.collection("defaultFood").document("SgahXQM6joSLFc0sxgDM").getDocument { (snapshot, error) in
//                    if error == nil && snapshot != nil && snapshot!.data() != nil {
//                        print(snapshot!.data())
//                    }
//                }
//    }
}


//
//  SettingView.swift
//  HappyFridge
//
//  Created by user on 2022/11/21.
//

import UIKit
import FirebaseFirestore

class SettingViewController: UIViewController {

    var db = Firestore.firestore()
    
    @IBOutlet weak var settingList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupList()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupList() {
        settingList.register(UINib(nibName: "SettingListCell", bundle: nil), forCellReuseIdentifier: "SettingListCell")
        settingList.delegate = self
        settingList.dataSource = self
        settingList.rowHeight = 54
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingListCell", for: indexPath) as! SettingListCell
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "메인화면 냉장고 크게 보기"
            cell.toggleSwitch.isHidden = false
        case 1:
            cell.titleLabel.text = "공지사항"
        case 2:
            cell.titleLabel.text = "오픈소스 라이선스"
        case 3:
            cell.titleLabel.text = "로그아웃"
        case 4:
            cell.titleLabel.text = "탈퇴하기"
        default:
            cell.titleLabel.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == 1 {
            self.navigationController?.pushViewController(NoticeViewController(), animated: true)
        }
        
        if indexPath.row == 2 {
            self.navigationController?.pushViewController(LicenseViewController(), animated: true)
        }
        
        if indexPath.row == 3 {
            let logoutAlert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
            
            let action1 = UIAlertAction(title: "로그아웃", style: .destructive) {_ in
                UserDefaults.standard.set(false, forKey: "Login")
                UserDefaults.standard.removeObject(forKey: "nickName")
                let vc = LoginViewController(nibName:"LoginViewController", bundle: nil)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
            let action2 = UIAlertAction(title: "취소", style: .cancel)
            
            logoutAlert.addAction(action1)
            logoutAlert.addAction(action2)
            
            present(logoutAlert, animated: true)
        }
        
        if indexPath.row == 4 {
            
            let exitAlert = UIAlertController(title: "탈퇴", message: "탈퇴시 모든 데이터가 삭제됩니다. 정말 탈퇴 하시겠습니까?", preferredStyle: .alert)
            
            let exitAction = UIAlertAction(title: "탈퇴", style: .destructive) {_ in
                
                let exitSheet = UIAlertController(title: "탈퇴", message: "정말 탈퇴 하시겠습니까?", preferredStyle: .actionSheet)
                
                let exitAction = UIAlertAction(title: "탈퇴", style: .destructive) {_ in
                    // 닉네임유저디폴트 삭제
                    // db삭제
                    // 로그인유저디폴트 false
                    
                    // 로그인뷰컨트롤러로 이동
                    UserDefaults.standard.set(false, forKey: "Login")
                    self.db.collection("fridge").document(Constant.nickName!).delete()
                    self.db.collection("users").document(Constant.nickName!).delete()
                    UserDefaults.standard.removeObject(forKey: "nickName")
                    
                    let vc = LoginViewController(nibName:"LoginViewController", bundle: nil)
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                
                exitSheet.addAction(exitAction)
                exitSheet.addAction(cancelAction)
                
                self.present(exitSheet, animated: true)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            
            exitAlert.addAction(exitAction)
            exitAlert.addAction(cancelAction)
            
            present(exitAlert, animated: true)
            
        }
            
    }
}

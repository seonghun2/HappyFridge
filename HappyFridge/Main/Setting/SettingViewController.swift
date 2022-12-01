//
//  SettingView.swift
//  HappyFridge
//
//  Created by user on 2022/11/21.
//

import UIKit

class SettingViewController: UIViewController {

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
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingListCell", for: indexPath) as! SettingListCell
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "메인화면 냉장고 크게 보기"
            cell.toggleSwitch.isHidden = false
        case 1:
            cell.titleLabel.text = "닉네임 변경하기"
        case 2:
            cell.titleLabel.text = "공지사항"
        case 3:
            cell.titleLabel.text = "오픈소스 라이선스"
        case 4:
            cell.titleLabel.text = "로그아웃"
        case 5:
            cell.titleLabel.text = "탈퇴하기"
        default:
            cell.titleLabel.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            self.navigationController?.pushViewController(NickNameViewController(), animated: true)
        }
        
        if indexPath.row == 2 {
            self.navigationController?.pushViewController(NickNameViewController(), animated: true)
        }
        
        if indexPath.row == 3 {
            self.navigationController?.pushViewController(LicenseViewController(), animated: true)
        }
        
        if indexPath.row == 4 {
            self.navigationController?.pushViewController(LoginViewController(), animated: true)
        }
        
        if indexPath.row == 5 {
            self.navigationController?.pushViewController(LoginViewController(), animated: true)
        }
            
    }
}

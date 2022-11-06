//
//  LoginViewController.swift
//  HappyFridge
//
//  Created by LCW on 2022/10/30.
//

import UIKit
import KakaoSDKUser


class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
    }
    
    
    func kakaoLogin() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                UserApi.shared.me() {(user, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("사용자 정보 가져오기 성공")
                        if let userid = user?.id {
                            let vc = NickNameViewController(nibName:"NickNameViewController", bundle: nil)
                            vc.kakaoUserId = String(userid)
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func kakaoLoginAction(_ sender: UIButton) {
        kakaoLogin()
    }
    
}

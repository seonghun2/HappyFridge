//
//  LoginViewController.swift
//  HappyFridge
//
//  Created by LCW on 2022/10/30.
//

import UIKit
import KakaoSDKUser
import AuthenticationServices
import FirebaseFirestore


class LoginViewController: UIViewController {
    
    lazy var db = Firestore.firestore()
    
    @IBOutlet weak var appleLoginButton: ASAuthorizationAppleIDButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        appleLoginButton.addTarget(self, action: #selector(LoginViewController.appleLoginButtonTapped), for: .touchDown)
    }
    
    @objc func appleLoginButtonTapped() {
        let authorizationProvider = ASAuthorizationAppleIDProvider()
        let request = authorizationProvider.createRequest()
        request.requestedScopes = [.email,.fullName]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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
                            let kakaoToken = String(userid)
                            self.moveNextView(token: kakaoToken)
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func kakaoLoginAction(_ sender: UIButton) {
        kakaoLogin()
    }
    
    func moveNextView(token:String) {
        let query = db.collection("users").whereField("token", isEqualTo: token+"a")
                query.getDocuments { (snapshot, error) in
                    let docs = snapshot!.documents
                    for doc in docs {
                        print("디비조회!")
                        print(doc.documentID)
                    }
                }
        let vc = NickNameViewController(nibName:"NickNameViewController", bundle: nil)
        vc.userLoginToken = token
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}

@available(iOS 13.0,*)

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        
        print("AppleID suceess user: \(appleIDCredential.user)")
        let appleToken = String(appleIDCredential.user)
        moveNextView(token: appleToken)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("AppleID error: \(error.localizedDescription)")
    }
}

@available(iOS 13.0,*)
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
}

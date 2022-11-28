//
//  CopyLaunchViewController.swift
//  HappyFridge
//
//  Created by LCW on 2022/11/04.
//

import UIKit

class CopyLaunchViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewEye: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
            self.imageViewEye.isHidden = true
            self.imageView.image = UIImage(named: "Vector")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                
                self.nextViewSetting()
            }
        }
    }
    
    func nextViewSetting() {
        
        let loginValue = UserDefaults.standard.bool(forKey: "Login")
        let nickNameValue = UserDefaults.standard.string(forKey: "nickName")
    
        if loginValue {
            //로그인 이력 있음
            //나의 냉장고 화면으로 이!동
            let vc = MainViewController(nibName:"MainViewController", bundle: nil)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
        } else {
            //로그인 이력 없음
            //권한안내 화면으로 이동
            let vc = PermissionViewController(nibName:"PermissionViewController", bundle: nil)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    
    
}

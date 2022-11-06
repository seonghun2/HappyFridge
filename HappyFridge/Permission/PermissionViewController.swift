//
//  PermissionViewController.swift
//  HappyFridge
//
//  Created by LCW on 2022/11/04.
//

import UIKit

class PermissionViewController: UIViewController {

    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmButton.layer.cornerRadius = 8
        
    }

    @IBAction func nextAction(_ sender: Any) {
        let vc = LoginViewController(nibName:"LoginViewController", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}

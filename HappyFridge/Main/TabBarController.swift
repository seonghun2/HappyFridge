//
//  TabBarController.swift
//  HappyFridge
//
//  Created by user on 2022/11/08.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view1 = MainViewController()
        //let view2 = SharedFridgeViewController()
        let view3 = AlertViewController()
        let view4 = UINavigationController(rootViewController: SettingViewController())
        
        
        setViewControllers([view1, view3, view4], animated: true)
        
        view1.tabBarItem = UITabBarItem(title: "나의냉장고", image: UIImage(named: "myfridge"), tag: 0)
        
        //view2.tabBarItem = UITabBarItem(title: "공유냉장고", image: UIImage(named: "sharedfridge"), tag: 1)
        view3.tabBarItem = UITabBarItem(title: "알림", image: UIImage(named: "alert"), tag: 2)
        view4.tabBarItem = UITabBarItem(title: "설정", image: UIImage(named: "setting"), tag: 3)
        
        tabBar.tintColor = UIColor(red: 0.039, green: 0.587, blue: 0.127, alpha: 1)
        tabBar.unselectedItemTintColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

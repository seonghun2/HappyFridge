//
//  AlertViewController.swift
//  HappyFridge
//
//  Created by user on 2022/11/08.
//

import UIKit
import UserNotifications

class AlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization { granted, error in
            if !granted {
                print("permission Denied")
            }
        }
        
        // create Notification content
        let content = UNMutableNotificationContent()
        content.title = "Noti title"
        content.body = "Noti body"
        
        // create notification trigger
        let date = Date().addingTimeInterval(5)
        
        let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false )
        
        //create request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        //register the request
        center.add(request) { error in
            
        }
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

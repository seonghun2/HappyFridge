//
//  Alert.swift
//  HappyFridge
//
//  Created by user on 2022/11/22.
//

import Foundation
import UserNotifications

struct Alerts: Codable {
    var alerts: [Alert]
}

struct Alert: Codable {
    var alertDate: Date
    var alertMessage: String
    
    func generateAlert() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization { granted, error in
            if !granted {
                print("permission Denied")
            }
        }
        
        // create Notification content
        let content = UNMutableNotificationContent()
        content.title = "유통기한 알림"
        content.body = alertMessage
        
        // create notification trigger
        //let date = Date().addingTimeInterval(TimeInterval(alertTime))
        
        //let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: alertDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false )
        
        //create request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        //register the request
        center.add(request) { error in
            
        }
        //alert뷰컨의 alert리스트에 append해줘야함
    }
}


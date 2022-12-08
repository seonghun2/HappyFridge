//
//  DataManager.swift
//  HappyFridge
//
//  Created by user on 2022/11/13.
//

import Foundation
import FirebaseFirestore

// 구조체에서 탈출클로저에 self사용 못해서 클래스로 사용
class DataManager {
    var db = Firestore.firestore()
    lazy var docRef = db.collection("fridge").document(Constant.nickName!)
    
    func getFridgeData(completion : @escaping ([Refrigerator]) -> Void) {
        //var fridgeArray: [Refrigerator] = []

        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print("Error getting document: \(error.localizedDescription)")
            } else {
                if let document = document {
                    do {
                        print("do")
                        
                        let fridges = try document.data(as: Refrigerators.self).fridges
                        completion(fridges)
                    }
                    catch {
                        print("catch")
                        print(error)
                    }
                }
            }
        }
    }
    
    
    func getFoodData(completion: @escaping ([Item]) -> Void)  {
        
        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print("Error getting document: \(error.localizedDescription)")
            } else {
                if let document = document {
                    do {
                        print("do")
                        
                        let foods = try document.data(as: Items.self).foods
                        completion(foods)
                    }
                    catch {
                        print("catch")
                        print(error)
                    }
                }
            }
        }
    }
    
    func getAlertData(completion: @escaping ([Alert]) -> Void) {
        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print("Error getting document: \(error.localizedDescription)")
            } else {
                if let document = document {
                    do {
                        let alerts = try document.data(as: Alerts.self).alerts
                        completion(alerts)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    func addFridge(fridgeName: String) {
        db.collection("fridge").document(Constant.nickName!)
            .setData(["fridges": FieldValue.arrayUnion([["fridgeName": fridgeName,
                                                        "owner": Constant.nickName!,
                                                        "createDate": Date(),
                                                        "isShared": false,
                                                        "notice": nil,
                                                        "food":[]]])],merge: true)
    }
    
    func addFood(foodName: String) {
        self.db.collection("fridge").document(Constant.nickName!)
            .setData(["foods": FieldValue.arrayUnion([["name": foodName,
                                                       "createDate": Date(),
                                                       "isBookmarked": false]])],merge: true)
    }
    
    func addAlert(alert: Alert) {
        self.db.collection("fridge").document(Constant.nickName!)
            .setData(["alerts": FieldValue.arrayUnion([["alertDate": alert.alertDate,
                                                        "alertMessage": alert.alertMessage]])],merge: true)
    }    
}

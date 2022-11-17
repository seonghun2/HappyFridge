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
    lazy var docRef = db.collection("fridge").document("횡성훈2")
    lazy var fridges: [Refrigerator] = []
    lazy var foods: [Item] = []
    
//    func getFridgeData() {
//
//        docRef.getDocument { document, error in
//            if let error = error as NSError? {
//                print("Error getting document: \(error.localizedDescription)")
//            } else {
//                if let document = document {
//                    do {
//                        print("do")
//                        print("냉장고있음",document.data(),document.data()?.count)
//                        let fridges = try document.data(as: Refrigerators.self).fridges
//                        self.fridges = fridges
//                    }
//                    catch {
//                        print("catch")
//                        print(error)
//                    }
//                }
//            }
//        }
//    }
    
    func getFridgeData(completion : @escaping ([Refrigerator]) -> ()) {
        //var fridgeArray: [Refrigerator] = []

        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print("Error getting document: \(error.localizedDescription)")
            } else {
                if let document = document {
                    do {
                        print("do")
                        print("냉장고있음",document.data(),document.data()?.count)
                        let fridges = try document.data(as: Refrigerators.self).fridges
                        // self.fridges = fridges
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
                        print("냉장고있음",document.data(),document.data()?.count)
                        let foods = try document.data(as: Items.self).foods
                        self.foods = foods
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
    
    func addFridge(fridgeName: String) {
        db.collection("fridge").document("횡성훈2")
            .setData(["fridges": FieldValue.arrayUnion([["fridgeName": fridgeName,
                                                        "owner": "횡성훈2",
                                                        "createDate": Date(),
                                                        "isShared": false,
                                                        "notice": nil,
                                                        "food":[]]])],merge: true)
    }
    
    func addFood(foodName: String) {
        self.db.collection("fridge").document("횡성훈2")
            .setData(["foods": FieldValue.arrayUnion([["name": foodName,
                                                       "createDate": Date(),
                                                       "isBookmarked": false]])],merge: true)
    }
    
    func removeFridge() {

    }
    
    func removeFood() {
        
    }
    
    func changeFridgeName() {
        
    }
    
    //냉장고안에 음식 넣을때
    func dropFoodInFridge(food: Item, to: Refrigerator) {
        
    }
    //        test[0].fridgeName = "changeTest"
    //        test[1].food?.append(foods[0])
    //        test.remove(at: test.count-1)
    //        let frid = Refrigerators(fridges: test)
    //        do {
    //            try db.collection("fridge").document("횡성훈2").setData(from: frid, merge: true)
    //        } catch {
    //            print(error)
    //        }
}
// 파이어스토어에서 불러와서 메인뷰컨 배열에 넣어서 가공후 다시 파이어스토어로 넣어주기

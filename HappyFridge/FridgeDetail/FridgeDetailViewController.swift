//
//  FridgeDetailViewController.swift
//  HappyFridge
//
//  Created by LCW on 2022/11/07.
//

import UIKit
import FirebaseFirestore

class FridgeDetailViewController: UIViewController, UIActionSheetDelegate {
     
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var fridgesInfoArray: [Fridges] = []
    
    lazy var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        getInfoTest()
    }

    @IBAction func filterAction(_ sender: Any) {}
    
    
    // 냉장고 정보 가져오기 테스트
    func getInfoTest() {
        let docRef = db.collection("fridge").document("횡성훈")
        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print("Error getting document: \(error.localizedDescription)")
            }else {
                if let document = document {
                    do {
                        print("do")
                        
                        if document.data()?.count == nil {
                            print("냉장고없음")
                            
                            
                        }else {
                            print("냉장고있음")
                            let dic = try document.data(as: Fridges.self)
                            
                            self.fridgesInfoArray.append(dic)
                            print(try document.data(as: Fridges.self).fridge)
                            
                            print("냉장고")
                            print(self.fridgesInfoArray[0].fridge[0].food)
                            
                        }
                        
                        
                    }
                    catch {
                        print("catch")
                        print(error)
                    }
                }
            }
        }
    }
    
}

extension FridgeDetailViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fridgesInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FridgeDetailCellTableViewCell", for: indexPath) as? FridgeDetailCellTableViewCell {
            
            cell.foodName.text = fridgesInfoArray[indexPath.row].fridge[0].food[0].foodName
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
   
    
}

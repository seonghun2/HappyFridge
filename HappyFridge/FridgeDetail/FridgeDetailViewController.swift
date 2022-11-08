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
    @IBOutlet weak var noticeContentLabel: UILabel!
    
    var fridgesInfoArray: [Fridges] = []
    var foodInfoArray: [Food] = []
    
    lazy var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getInfoTest()
        
        let nibName = UINib(nibName: "FridgeDetailCellTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "FridgeDetailCellTableViewCell")
        
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
                            print(dic)
                            
                            self.fridgesInfoArray.append(dic)
                            self.foodInfoArray.append(contentsOf: self.fridgesInfoArray[0].fridge[0].food)
                            self.tableView.reloadData()
                            
                            self.noticeContentLabel.text = self.fridgesInfoArray[0].fridge[0].notice
                            
                            print("냉장고")
                            print(self.fridgesInfoArray[0].fridge[0].food[0].foodName)
                            
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
        print("array count : \(fridgesInfoArray.count)")
        
        //return fridgesInfoArray.count
        return foodInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FridgeDetailCellTableViewCell", for: indexPath) as? FridgeDetailCellTableViewCell {
            
            cell.foodName.text = foodInfoArray[indexPath.row].foodName
            cell.foodCountLabel.text = String(foodInfoArray[indexPath.row].count)
            print(foodInfoArray[indexPath.row].expirationDate)
            
            let date = foodInfoArray[indexPath.row].expirationDate
            let formatter = DateFormatter()
            formatter.dateFormat = "yy.MM.dd"
            let stringDate = formatter.string(from: date)
            print(stringDate)
            cell.expirationDateLabel.text = "\(stringDate)까지"
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 72 }
    
}

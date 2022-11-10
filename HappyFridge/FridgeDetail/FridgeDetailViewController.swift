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
        
        return foodInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FridgeDetailCellTableViewCell", for: indexPath) as? FridgeDetailCellTableViewCell {
            
            
            
            let foods = foodInfoArray[indexPath.row]
            cell.setFoodInfo(food: foods)
            cell.index = indexPath.row
            cell.food = foodInfoArray[indexPath.row]
            
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 72 }
    
}

extension FridgeDetailViewController: TableViewCellDelegate {
    func deleteButton(index: Int?,food: Food?) {
        print("x버튼 클릭 vc ")
        print(index)
        guard (index != nil) else {
            return
        }
        
        let sheet = UIAlertController(title: "물품삭제", message: "\(foodInfoArray[index!].foodName)를(을)\n삭제하시겠습니까?", preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            print("삭제 클릭")
        }))
       
        sheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in print("취소 클릭") }))
        present(sheet, animated: true)
        
        tableView.reloadData()
        
    }
    
    func aa() {
      //  db.collection("fridge").document("횡성훈").updateData(["fridge" :])

    }
    
}

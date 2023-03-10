//
//  SearchViewController.swift
//  HappyFridge
//
//  Created by LCW on 2022/11/21.
//

import UIKit
import FirebaseFirestore

class SearchViewController: UIViewController {
    
    lazy var db = Firestore.firestore()
    
    var searchFridgesInfoArray: [Refrigerator] = []
    var searchFoodInfoArray: [Item] = []
    var searchFoodInfoArray2: [Item] = []
    var searchIndex = 0
    var fridgeIndex = 0
    
    // 데이터 전달 클로저
    var searchClosure: ((_ data: String) -> Void)?
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var emptyFridgeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.allowsSelection = false
        
        let nibName = UINib(nibName: "FridgeDetailCellTableViewCell", bundle: nil)
        searchTableView.register(nibName, forCellReuseIdentifier: "FridgeDetailCellTableViewCell")
    }
    
    
    @IBAction func searchAction(_ sender: Any) {
        if let keyWord = searchTextField.text {
            
            searchFoodInfoArray2 = searchFoodInfoArray.filter {
                $0.name == keyWord
            }
            
            if searchFoodInfoArray2.count == 0 {
                searchTableView.isHidden = true
                emptyFridgeImageView.isHidden = false
                
            }else {
                emptyFridgeImageView.isHidden = true
                searchTableView.isHidden = false
            }
            
            searchIndex = searchFoodInfoArray.firstIndex {
                $0.name == keyWord
            } ?? 0
            
            searchTableView.reloadData()
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        //dismiss(animated: true)
        searchClosure?("검색뷰에서뒤로가기")
    }
    
    
    //MARK: 냉장고 물품 삭제
    func deleteFood(foodIndex:Int) {
        searchFoodInfoArray2.remove(at: foodIndex)
        searchFoodInfoArray.remove(at: searchIndex)
        searchFridgesInfoArray[fridgeIndex].food?.removeAll()
        searchFridgesInfoArray[fridgeIndex].food?.append(contentsOf: searchFoodInfoArray)
        
        let frid = Refrigerators(fridges: searchFridgesInfoArray)
        do {
            try db.collection("fridge").document(Constant.nickName!).setData(from: frid, merge: true)
            searchTableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    //MARK: 냉장고안에 물품 수량 조절
    func updateFood(foodIndex: Int,foodCount: Int) {
        searchFoodInfoArray2[foodIndex].count = foodCount
        searchFoodInfoArray[searchIndex].count = foodCount
        searchFridgesInfoArray[fridgeIndex].food?.removeAll()
        searchFridgesInfoArray[fridgeIndex].food?.append(contentsOf: self.searchFoodInfoArray)
        
        let frid = Refrigerators(fridges: self.searchFridgesInfoArray)
        do {
            try db.collection("fridge").document(Constant.nickName!).setData(from: frid, merge: true)
            searchTableView.reloadData()
        } catch {
            print(error)
        }
    }
    
}




extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchFoodInfoArray2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FridgeDetailCellTableViewCell", for: indexPath) as? FridgeDetailCellTableViewCell {
            
            let foods = searchFoodInfoArray2[indexPath.row]
            cell.setFoodInfo(food: foods)
            cell.index = indexPath.row
            cell.food = searchFoodInfoArray2[indexPath.row]
            cell.count = foods.count
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 72 }
    
    
}

extension SearchViewController: TableViewCellDelegate {
    
    func deleteButton(index: Int?,food: Item?) {
        guard (index != nil) else {
            return
        }
        
        let sheet = UIAlertController(title: "물품삭제", message: "\(searchFoodInfoArray2[index!].name)를(을)\n삭제하시겠습니까?", preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.deleteFood(foodIndex: index!)
        }))
        
        sheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in print("취소 클릭") }))
        present(sheet, animated: true)
        
    }
    
    func showFoodCountPopUp(index: Int?, count: Int?) {
        guard (count != nil) else {
            return
        }
        
        let popup = PopUpFoodCountUpdate(nibName: "PopUpFoodCountUpdate", bundle: nil)
        popup.modalPresentationStyle = .overCurrentContext
        popup.delegate = self
        popup.foodCount = count
        popup.foodIndex = index
        self.present(popup, animated: false)
        if let ccount = count {
            popup.countTextField.text = String(ccount)
        }
    }
    
    
}

extension SearchViewController: PopUpFoodCountDelegate {
    func confirmButton(foodIndex:Int?, count: Int?) {
        dismiss(animated: false) {
            if let foodCount = count {
                if let index = foodIndex {
                    self.updateFood(foodIndex:index,foodCount: foodCount)
                    self.searchTableView.reloadData()
                }
                
            }
            
        }
    }
}

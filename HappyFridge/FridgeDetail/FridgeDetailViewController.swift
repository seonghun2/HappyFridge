//
//  FridgeDetailViewController.swift
//  HappyFridge
//
//  Created by LCW on 2022/11/07.
//

import UIKit
import FirebaseFirestore

class FridgeDetailViewController: UIViewController, UIActionSheetDelegate {
    @IBOutlet weak var noticeTitleLabel: NSLayoutConstraint!
    
    @IBOutlet weak var noticeContentLabel: NSLayoutConstraint!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var emptyImageView: UIImageView!
    
    @IBOutlet weak var addFoodButton: UIButton!
    var fridgesIndex = 0
    var fridgesInfoArray: [Refrigerator] = []
    var foodInfoArray: [Item] = []
    var fridgeName: String?
    
    
    lazy var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
        setAddFoodButton()
        
        getFridgeInfo()
        
        let nibName = UINib(nibName: "FridgeDetailCellTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "FridgeDetailCellTableViewCell")
        
        print("fridgesIndex")
        print(fridgesIndex)
        print("Constant.nickName!")
        print(Constant.nickName!)
        if let name = fridgeName {
            navigationBar.title = name
        }
        
        noticeTitleLabel.constant = 0
        noticeContentLabel.constant = 0
        
    }
    
    func setAddFoodButton() {
        addFoodButton.layer.cornerRadius = 25
        addFoodButton.layer.shadowColor = UIColor.gray.cgColor
        addFoodButton.layer.shadowOffset = .zero
        addFoodButton.layer.shadowOpacity = 1.0
        addFoodButton.layer.shadowRadius = 3
        addFoodButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: 검색버튼 클릭
    @IBAction func searchAction(_ sender: Any) {
        let vc = SearchViewController(nibName:"SearchViewController", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        vc.searchFoodInfoArray = foodInfoArray
        vc.searchFridgesInfoArray = fridgesInfoArray
        vc.fridgeIndex = fridgesIndex
        vc.searchClosure = { [weak self] data  in
            print("클로저")
            print(data)
            self?.getFridgeInfo()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: 냉장고물품 정렬
    func filter() {
        let bottomSheet = UIAlertController(title: "정렬", message: nil, preferredStyle: .actionSheet)
        
        let expirationDate = UIAlertAction(title:"유통기한순", style: .default) {data in
            self.filterButton.setTitle(data.title, for: .normal)
            self.foodInfoArray.sort(by: { $0.expirationDate! < $1.expirationDate!})
            self.tableView.reloadData()
        }
        let foodCount = UIAlertAction(title:"남은수량순", style: .default) {data in
            self.filterButton.setTitle(data.title, for: .normal)
            self.foodInfoArray.sort(by: { $0.count! < $1.count!})
            self.tableView.reloadData()
        }
        let addDate = UIAlertAction(title:"최근추가순", style: .default) {data in
            self.filterButton.setTitle(data.title, for: .normal)
            self.foodInfoArray.sort(by: { $0.createDate! > $1.createDate!})
            self.tableView.reloadData()
        }
        
        bottomSheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        bottomSheet.addAction(expirationDate)
        bottomSheet.addAction(foodCount)
        bottomSheet.addAction(addDate)
        self.present(bottomSheet,animated: true)
    }
    
    // 정렬 버튼
    @IBAction func filterAction(_ sender: Any) {
        filter()
    }
    
    //MARK: 물품추가 버튼 (화면이동)
    @IBAction func addFoodAction(_ sender: Any) {
        let vc = AddFoodViewController(nibName:"AddFoodViewController", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        vc.index = fridgesIndex
        vc.fridgesInfoArray = fridgesInfoArray
        print("물품추가 : \(fridgesInfoArray)")
        vc.foodInfoArray = foodInfoArray
        vc.dataSendClosure = { [weak self] data  in
            print("클로저")
            print(data)
            self?.getFridgeInfo()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: 뒤로가기 버튼 (메인화면으로 이동)
    @IBAction func exitButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: 냉장고 물품 삭제
    func deleteFood(foodIndex:Int) {
        self.foodInfoArray.remove(at: foodIndex)
        print("foodInfoArray")
        print(foodInfoArray)
        self.fridgesInfoArray[fridgesIndex].food?.removeAll()
        self.fridgesInfoArray[fridgesIndex].food?.append(contentsOf: self.foodInfoArray)
        
        let frid = Refrigerators(fridges: self.fridgesInfoArray)
        do {
            try db.collection("fridge").document(Constant.nickName!).setData(from: frid, merge: true)
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    //MARK: 냉장고안에 물품 수량 조절
    func updateFood(foodIndex: Int,foodCount: Int) {
        print("foodInfoArray")
        print(foodInfoArray)
        self.foodInfoArray[foodIndex].count = foodCount
        self.fridgesInfoArray[fridgesIndex].food?.removeAll()
        self.fridgesInfoArray[fridgesIndex].food?.append(contentsOf: self.foodInfoArray)
        
        let frid = Refrigerators(fridges: self.fridgesInfoArray)
        do {
            try db.collection("fridge").document(Constant.nickName!).setData(from: frid, merge: true)
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    //MARK: 냉장고 정보 가져오기
    func getFridgeInfo() {
        let docRef = db.collection("fridge").document(Constant.nickName!)
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
                            let dic = try document.data(as: Refrigerators.self)
                            print(dic)
                            self.fridgesInfoArray.removeAll()
                            self.foodInfoArray.removeAll()
                            self.fridgesInfoArray.append(contentsOf: dic.fridges)
                            //print(self.fridgesInfoArray[self.fridgesIndex])
                            
                            if let aa = self.fridgesInfoArray[self.fridgesIndex].food {
                                self.foodInfoArray.append(contentsOf: aa)
                                self.emptyImageView.isHidden = true
                            }
                           
                            if self.fridgesInfoArray[self.fridgesIndex].food == nil {
                                self.tableView.isHidden = true
                            }
//                            self.noticeContentLabel.text = self.fridgesInfoArray[self.fridgesIndex].notice
                            self.tableView.reloadData()
            
                            
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
            cell.count = foods.count
            cell.delegate = self
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 72 }
    
}

extension FridgeDetailViewController: TableViewCellDelegate {
    
    func deleteButton(index: Int?,food: Item?) {
        print("x버튼 클릭 vc ")
        guard (index != nil) else {
            return
        }
        
        let sheet = UIAlertController(title: "물품삭제", message: "\(foodInfoArray[index!].name)를(을)\n삭제하시겠습니까?", preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            print("삭제 클릭")
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

extension FridgeDetailViewController: PopUpFoodCountDelegate {
    func confirmButton(foodIndex:Int?, count: Int?) {
        print("저장클릭 뷰컨")
        dismiss(animated: false) {
            if let foodCount = count {
                if let index = foodIndex {
                    self.updateFood(foodIndex:index,foodCount: foodCount)
                    self.tableView.reloadData()
                }
                
            }
            
        }
    }
}




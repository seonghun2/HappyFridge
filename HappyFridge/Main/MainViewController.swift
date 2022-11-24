//
//  ViewController.swift
//  HappyRefrige
//
//  Created by user on 2022/10/29.
//

import UIKit
import SnapKit
import FirebaseFirestore
import Toast
class MainViewController: UIViewController {
    var db = Firestore.firestore()
    var dataManager = DataManager()
    
    @IBOutlet weak var refrigeCollectionView: UICollectionView!
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    @IBOutlet weak var bookMarkButton: UIButton!
    
    @IBOutlet weak var itemSortButton: UIButton!
    
    @IBOutlet weak var previousButton: UIButton!
    
    var itemSearhBar = ItemSearchTextField()
    
    var bookmarkedFoods: [Item] = []
    var searchedFoods: [Item]?
    var showSearchItem: Bool = false
    var showBookmark: Bool = false
    
    // 냉장고 크게/작게보기 결정할 변수
    var showSmall: Bool = true
    
    var refrigerators: [Refrigerator] = []
    var foods: [Item] = []
    
    // 드래그한 셀을 저장할 변수, 냉장고 셀에 드랍할때 사용
    var draggingFood: Item?
    
    override func viewDidLoad() {

        super.viewDidLoad()
        dataManager.getFridgeData { fridges in
            self.refrigerators = fridges
            self.refrigeCollectionView.reloadData()
        }
        
        dataManager.getFoodData { foods in
            self.foods = foods
            self.itemCollectionView.reloadData()
        }
        
        setRefrigeCollectionView()
        setItemCollectionView()
        
        itemSearhBar.delegate = self
    }
    
    func setRefrigeCollectionView() {
        refrigeCollectionView.register(UINib(nibName: "RefrigeSmallCell", bundle: nil), forCellWithReuseIdentifier: "RefrigeSmallCell")
        
        refrigeCollectionView.delegate = self
        refrigeCollectionView.dataSource = self
        refrigeCollectionView.dropDelegate = self
        refrigeCollectionView.allowsSelection = false
        
        let flowLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            if showSmall {
                layout.sectionInset = UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 20)
                layout.minimumLineSpacing = 16
                layout.itemSize = CGSize(width: 180, height: 180)
                return layout
            } else {
                layout.sectionInset = UIEdgeInsets(top: 70, left: 40, bottom: 40, right: 20)
                layout.minimumLineSpacing = 40.0
                layout.itemSize = CGSize(width: 300, height: 300)
                return layout
            }
        }()
        
        refrigeCollectionView.collectionViewLayout = flowLayout
        refrigeCollectionView.showsHorizontalScrollIndicator = false
        refrigeCollectionView.isPagingEnabled = true
        
        // 냉장고가 없을때 이미지 표시
        refrigeCollectionView.backgroundView = UIImageView(image: UIImage(systemName: "sunrise"))
        refrigeCollectionView.backgroundView?.isHidden = true
        
//        if test.isEmpty {
//            refrigeCollectionView.backgroundView?.isHidden = false
//        }
    }
    
    func setItemCollectionView() {
        itemCollectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        itemCollectionView.dragDelegate = self
        
        itemCollectionView.layer.cornerRadius = 16
        itemCollectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let flowLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 64, left: 15, bottom: 20, right: 15)
            layout.minimumLineSpacing = 12
            
            layout.itemSize = CGSize(width: 95, height: 80)
            
            return layout
        }()
        
        itemCollectionView.collectionViewLayout = flowLayout
        itemCollectionView.showsHorizontalScrollIndicator = false
        itemCollectionView.backgroundColor = .systemGray5
        itemCollectionView.isPagingEnabled = true
        
        itemCollectionView.addSubview(itemSearhBar)
        itemSearhBar.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.left.equalTo(15)
            make.width.equalTo(248)
            make.height.equalTo(32)
        }
        previousButton.isHidden = true
    }
    
    @IBAction func refrigeSortButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "정렬방식 선택", message: nil, preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "이름순", style: .default) {_ in
            self.refrigerators.sort { $0.fridgeName < $1.fridgeName }
            do {
                try self.db.collection("fridge").document("횡성훈2").setData(from:Refrigerators(fridges: self.refrigerators), merge: true)
            } catch {
                print(error)
            }
            self.refrigeCollectionView.reloadData()
        }
        alert.addAction(action)
        
        let action2 = UIAlertAction(title: "추가순", style: .default) {_ in
            self.refrigerators.sort { $0.createDate < $1.createDate }
            do {
                try self.db.collection("fridge").document("횡성훈2").setData(from:Refrigerators(fridges: self.refrigerators), merge: true)
            } catch {
                print(error)
            }
            self.refrigeCollectionView.reloadData()
        }
        alert.addAction(action2)
        
        let action3 = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(action3)
        
        present(alert, animated: true)
    }
    
    @IBAction func refrigeAddButtonTapped(_ sender: Any) {
        print(#function)
//        updateData()
//        return
        
        let alert = UIAlertController(title: "장소 추가", message: nil, preferredStyle: .alert)
        
        alert.addTextField()
        alert.textFields?[0].placeholder = "장소명을 입력해주세요."
        let action = UIAlertAction(title: "저장", style: .default) {_ in
            if let name = alert.textFields?[0].text {
                if name == "" {
                    self.present(alert, animated: true)
                    self.view.makeToast("이름을 입력해주세요.")
                } else {
                    if !self.refrigerators.map{ $0.fridgeName }.contains(name) {
                        self.refrigeCollectionView.backgroundView?.isHidden = true
                        
                        self.dataManager.addFridge(fridgeName: name)
                        self.dataManager.getFridgeData { fridges in
                            self.refrigerators = fridges
                            self.refrigeCollectionView.reloadData()
                        }
                        
                        self.refrigeCollectionView.reloadData()
                        self.view.makeToast("\(name)이(가) 추가 되었습니다")
                        // 셀 추가시 컬렉션 뷰 맨오른쪽으로 스크롤
                        let item = self.refrigeCollectionView.numberOfItems(inSection: 0) - 1
                        if item >= 0 {
                            let lastIndex = IndexPath(item: item, section: 0)
                            
                            self.refrigeCollectionView.scrollToItem(at: lastIndex, at: .right, animated: true)
                            print(lastIndex)
                        }
                    } else {
                        self.present(alert,animated: true)
                        self.view.makeToast("같은이름의 냉장고가 존재합니다.")
                    }
                }
            }
        }
        alert.addAction(action)
        
        let action2 = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(action2)
        
        present(alert,animated: true)
    }
    
    @IBAction func bookMarkButtonTapped(_ sender: UIButton) {
        print(#function, showBookmark)
        if showBookmark {
            showBookmark = false
            bookMarkButton.setImage(UIImage(named: "star_empty"), for: .normal)
        } else {
            bookmarkedFoods = foods.filter { $0.isBookmarked == true }
            showBookmark = true
            bookMarkButton.setImage(UIImage(named: "star_fill"), for: .normal)
        }
        print(bookmarkedFoods)
        itemCollectionView.reloadData()
    }
    
    @IBAction func foodSortButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "정렬방식 선택", message: nil, preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "이름순", style: .default) {_ in
            self.foods.sort { $0.name < $1.name }
            do {
                try self.db.collection("fridge").document("횡성훈2").setData(from: Items(foods: self.foods), merge: true)
            } catch {
                print(error)
            }
            self.itemCollectionView.reloadData()
        }
        alert.addAction(action)
        
        let action2 = UIAlertAction(title: "추가순", style: .default) {_ in
            self.foods.sort { $0.createDate! < $1.createDate! }
            do {
                try self.db.collection("fridge").document("횡성훈2").setData(from: Items(foods: self.foods), merge: true)
            } catch {
                print(error)
            }
            self.itemCollectionView.reloadData()
        }
        alert.addAction(action2)
        
        let action3 = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(action3)
        
        present(alert, animated: true)
    }
    
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        showSearchItem = false
        previousButton.isHidden = true
        bookMarkButton.isHidden = false
        itemSortButton.isHidden = false
        
        itemSearhBar.resignFirstResponder()
        itemSearhBar.text = ""
        itemCollectionView.reloadData()
        itemSearhBar.snp.updateConstraints { update in
            update.width.equalTo(248)
            update.left.equalTo(itemCollectionView.snp.left).inset(15)
        }
        itemCollectionView.snp.updateConstraints { make in
            make.top.equalTo(refrigeCollectionView.snp.bottom)
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == refrigeCollectionView{
            return refrigerators.count
        } else {
            if showBookmark {
                return bookmarkedFoods.count
            } else {
                if showSearchItem {
                    return searchedFoods!.count
                } else {
                    return foods.count + 1
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 냉장고 목록
        if collectionView == refrigeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RefrigeSmallCell", for: indexPath) as! RefrigeSmallCell
            
            cell.refrigeNameLabel.text = refrigerators[indexPath.row].fridgeName
            cell.itemList = refrigerators[indexPath.row].food ?? []
            
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 20
            //****
            cell.itemListTableView.reloadData()
            if refrigerators[indexPath.row].isShared {
                cell.layer.borderColor = UIColor(hexString: "#DFF4C5").cgColor
                cell.layer.borderWidth = 2
            } else{
                cell.layer.borderColor = UIColor.systemGray5.cgColor
                cell.layer.borderWidth = 2
            }
            
            //냉장고셀 터치시 상세화면 띄움
            cell.tapEventClosure = {
                let VC = FridgeDetailViewController()
                print(indexPath.row)
                //VC.foodInfoArray = foods[indexPath.row]
                //VC.fridgesInfoArray = test[indexPath.row]
                self.present(VC, animated: true)
            }
            
            //냉장고이름 변경
            cell.eventClosure = {
                let bottomSheet = UIAlertController(title: "편집", message: nil, preferredStyle: .actionSheet)
                
                let changeFridgeName = UIAlertAction(title:"이름변경", style: .default) {_ in
                    let alert = UIAlertController(title: "이름변경", message: nil, preferredStyle: .alert)
                    alert.addTextField()
                    alert.textFields![0].placeholder = self.refrigerators[indexPath.row].fridgeName
                    let action = UIAlertAction(title: "변경", style: .default) {_ in
                        if let name = alert.textFields?[0].text {
                            self.refrigerators[indexPath.row].fridgeName = name
                            do {
                                try self.db.collection("fridge").document("횡성훈2").setData(from:Refrigerators(fridges: self.refrigerators), merge: true)
                            } catch {
                                print(error)
                            }
                            self.refrigeCollectionView.reloadData()
                        }
                    }
                    alert.addAction(action)
                    
                    let action2 = UIAlertAction(title: "취소", style: .cancel)
                    alert.addAction(action2)
                    
                    self.present(alert, animated: true)
                }
                let deleteFridge = UIAlertAction(title: "장소삭제", style: .destructive) {_ in
                    let alert = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)
                    let action = UIAlertAction(title: "삭제", style: .default) {_ in
                        self.refrigerators.remove(at: indexPath.row)
                        do {
                            try self.db.collection("fridge").document("횡성훈2").setData(from:Refrigerators(fridges: self.refrigerators), merge: true)
                        } catch {
                            print(error)
                        }
                        self.refrigeCollectionView.reloadData()
                    }
                    alert.addAction(action)
                    
                    let action2 = UIAlertAction(title: "취소", style: .cancel)
                    alert.addAction(action2)
                    
                    self.present(alert, animated: true)
                }
                bottomSheet.addAction(changeFridgeName)
                bottomSheet.addAction(deleteFridge)
                
                bottomSheet.addAction(UIAlertAction(title: "취소", style: .cancel))
                self.present(bottomSheet,animated: true)
            }
            
            return cell
            //하단품목
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 4
            cell.index = indexPath.row
            // 즐겨찾기품목
            if showBookmark {
                cell.plusImage.isHidden = true
                cell.itemNameLabel.isHidden = false
                cell.bookmarkButton.isHidden = false
                cell.deleteButton.isHidden = false
                cell.itemNameLabel.text = bookmarkedFoods[indexPath.row].name
                cell.isBookmarked = bookmarkedFoods[indexPath.row].isBookmarked!
                cell.setBookmarkButton()
                cell.deleteEventClosure = {
                    for i in 0...self.foods.count - 1 {
                        if self.foods[i].name == self.bookmarkedFoods[indexPath.row].name {
                            self.foods.remove(at: i)
                            self.bookmarkedFoods.remove(at: indexPath.row)
                            break
                        }
                    }
                    do {
                        try self.db.collection("fridge").document("횡성훈2").setData(from:Items(foods: self.foods), merge: true)
                    } catch {
                        print(error)
                    }
                    self.itemCollectionView.reloadData()
                }
                cell.eventClosure = { toggle in
                    for i in 0...self.foods.count - 1 {
                        if self.foods[i].name == self.bookmarkedFoods[indexPath.row].name {
                            self.foods[i].isBookmarked = toggle
                        }
                    }
                    do {
                        try self.db.collection("fridge").document("횡성훈2").setData(from:Items(foods: self.foods), merge: true)
                    } catch {
                        print(error)
                    }
                    //self.foods.map { $0.isBookmarked ? : }
                    //                    self.foods.map {
                    //                        if $0.name == self.bookmarkItemArray[indexPath.row].name {
                    //                            $0.isBookmarked = toggle
                    //                        }
                    //                    }
                }
                return cell
                // 모든품목
            } else {
                if showSearchItem {
                    cell.plusImage.isHidden = true
                    cell.itemNameLabel.isHidden = false
                    cell.bookmarkButton.isHidden = false
                    cell.deleteButton.isHidden = false
                    cell.itemNameLabel.text = searchedFoods![indexPath.row].name
                    cell.isBookmarked = searchedFoods![indexPath.row].isBookmarked!
                    cell.deleteEventClosure = {
                        for i in 0...self.foods.count - 1 {
                            if self.foods[i].name == self.searchedFoods?[indexPath.row].name {
                                self.searchedFoods?.remove(at: indexPath.row)
                                self.foods.remove(at: i)
                                break
                            }
                        }
                        do {
                            try self.db.collection("fridge").document("횡성훈2").setData(from:Items(foods: self.foods), merge: true)
                        } catch {
                            print(error)
                        }
                        self.itemCollectionView.reloadData()
                    }
                    cell.eventClosure = { toggle in
                        for i in 0...self.foods.count - 1 {
                            if self.foods[i].name == self.searchedFoods![indexPath.row].name {
                                self.foods[i].isBookmarked = toggle
                            }
                        }
                        do {
                            try self.db.collection("fridge").document("횡성훈2").setData(from:Items(foods: self.foods), merge: true)
                        } catch {
                            print(error)
                        }
                    }
                    return cell
                } else {
                    // +셀
                    if indexPath.row == 0 {
                        cell.plusImage.isHidden = false
                        cell.itemNameLabel.isHidden = true
                        cell.bookmarkButton.isHidden = true
                        cell.deleteButton.isHidden = true
                        return cell
                        // 나머지셀
                    } else {
                        cell.isBookmarked = foods[indexPath.row - 1].isBookmarked ?? false
                        cell.setBookmarkButton()
                        cell.plusImage.isHidden = true
                        cell.itemNameLabel.isHidden = false
                        cell.bookmarkButton.isHidden = false
                        cell.deleteButton.isHidden = false
                        
                        cell.itemNameLabel.text = foods[indexPath.row - 1].name
                        cell.deleteEventClosure = {
                            self.foods.remove(at: indexPath.row - 1)
                            
                            do {
                                try self.db.collection("fridge").document("횡성훈2").setData(from:Items(foods: self.foods), merge: true)
                            } catch {
                                print(error)
                            }
                            self.itemCollectionView.reloadData()
                        }
                        cell.eventClosure = { toggle in
                            self.foods[indexPath.row - 1].isBookmarked = toggle
                            
                            do {
                                try self.db.collection("fridge").document("횡성훈2").setData(from:Items(foods: self.foods), merge: true)
                            } catch {
                                print(error)
                            }
                            
                            print(toggle)
                            
                            print(self.foods)
                        }
                        //                        if showSearchItem {
                        //                            cell.eventClosure = { index, toggle in
                        //                                self.foods[index].isBookmarked = toggle
                        //                            }
                        //                        } else {
                        //                            cell.eventClosure = { index, toggle in
                        //                                self.foods[index - 1].isBookmarked = toggle
                        //                                print(index - 1, toggle)
                        //                                print(self.foods[index - 1])
                        //                                print(self.foods)
                        //                            }
                        //                        }
                        
                    }
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == itemCollectionView && indexPath.row == 0 {
            if !showSearchItem && !showBookmark {
                let itemAddAlert = UIAlertController(title: "품목추가", message: nil, preferredStyle: .alert)
                itemAddAlert.addTextField()
                let addAction = UIAlertAction(title: "추가", style: .default) { _ in
                    if let name = itemAddAlert.textFields?[0].text {
                        if name == "" {
                            self.present(itemAddAlert, animated: true)
                            self.view.makeToast("이름을 입력해주세요.")
                        } else {
                            if !self.foods.map{ $0.name }.contains(name) {
                                
                                self.dataManager.addFood(foodName: name)
                                self.dataManager.getFoodData { foods in
                                    self.foods = foods
                                    self.itemCollectionView.reloadData()
                                }
                                self.itemCollectionView.reloadData()
                                self.view.makeToast("\(name)이(가) 추가 되었습니다.")
                            } else {
                                self.present(itemAddAlert, animated: true)
                                self.view.makeToast("같은이름의 식품이 존재합니다.")
                            }
                        }
                    }
                }
                itemAddAlert.addAction(addAction)
                itemAddAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
                present(itemAddAlert, animated: true)
                
            } else {
                print(indexPath.row)
            }
        }
    }
}
    

extension MainViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    //드랍할때 호출. 전역변수에 저장되어있는 item을 드랍하는 냉장고의 items배열에 append해줌
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        if draggingFood == nil { return }
        print(#function,coordinator.destinationIndexPath)
        
        guard let destinationIndexPath = coordinator.destinationIndexPath?[1] else {return}
        
        if collectionView == refrigeCollectionView {
            
            if coordinator.proposal.operation == .copy {
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .date
                datePicker.preferredDatePickerStyle = .compact
                datePicker.locale = NSLocale(localeIdentifier: "ko_KR") as Locale
                
                let dateChooserAlert = UIAlertController(title: "유통기한 입력", message: nil, preferredStyle: .alert)
                dateChooserAlert.view.addSubview(datePicker)
                datePicker.snp.makeConstraints { make in
                    make.top.equalTo(50)
                    make.left.equalTo(20)
                }
                
                dateChooserAlert.addAction(UIAlertAction(title: "선택완료", style: .default) { _ in
                    print(datePicker.date)
                    self.draggingFood?.expirationDate = datePicker.date
                    
                    self.draggingFood?.count = 2
                    self.draggingFood?.performAlert = true
                    self.draggingFood?.alertDay = 3
                    //self.refrigeArray[destinationIndexPath].items.append(self.draggingItem!)
                    
                    self.refrigerators[destinationIndexPath].food?.append(self.draggingFood!)

                    let frid = Refrigerators(fridges: self.refrigerators)
                    do {
                        try self.db.collection("fridge").document("횡성훈2").setData(from: frid, merge: true)
                    } catch {
                        print(error)
                    }
                    
                    
                    self.draggingFood = nil
                    print(destinationIndexPath)
                    
                    //전체컬렉션뷰 리로드
                    //self.refrigeCollectionView.reloadData()
                    
                    //셀 하나만 리로드
                    let indexPath = IndexPath(item: destinationIndexPath, section: 0)
                    self.refrigeCollectionView.reloadItems(at: [indexPath])
                })
                
                let height: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
                
                dateChooserAlert.view.addConstraint(height)
                
                //present(dateChooserAlert, animated: true)
                
                let VC = InsertFoodViewController()
                //VC.foodnameLabel.text = draggingItem?.name
                //VC.foodnameLabel.text = "\(draggingFood?.name) -> \(refrigerators[destinationIndexPath].fridgeName)"
                //VC.foodnameLabel.text = "123"
                VC.destinationFridge = refrigerators[destinationIndexPath]
                VC.addEventClosure = { foodCount, expirationDate ,isAlert, alertDay in
                    self.draggingFood?.count = foodCount
                    self.draggingFood?.expirationDate = expirationDate
                    self.draggingFood?.performAlert = isAlert
                    self.draggingFood?.alertDay = alertDay
                    self.refrigerators[destinationIndexPath].food?.append(self.draggingFood!)

                    let frid = Refrigerators(fridges: self.refrigerators)
                    do {
                        try self.db.collection("fridge").document("횡성훈2").setData(from: frid, merge: true)
                    } catch {
                        print(error)
                    }
                    print(self.draggingFood?.expirationDate)
                    print(Calendar.current.date(byAdding: .day, value: -alertDay, to: (self.draggingFood?.expirationDate)!))
                    
                    self.draggingFood = nil
                    
                    let alert = Alert(alertTitle: "testTitle", alertMessage: "testMessage", alertTime: alertDay)
                    alert.generateAlert()
                    
                    let indexPath = IndexPath(item: destinationIndexPath, section: 0)
                    self.refrigeCollectionView.reloadItems(at: [indexPath])
                    
                }
                present(VC, animated: true)
                
            }
        }
    }
    
    //드래그 시작될때 호출. 드래그하는 item을 전역변수에 저장시킴
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let item: String?
        if showSearchItem {
            item = searchedFoods![indexPath.row].name
        } else {
            if showBookmark {
                item = bookmarkedFoods[indexPath.row].name
            } else {
                if indexPath.row == 0 {
                    item = ""
                } else {
                    item = foods[indexPath.row - 1].name
                }
            }
        }
        
        let itemProvider = NSItemProvider(object: item! as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
        print(#function, itemProvider, dragItem)
        if showSearchItem {
            draggingFood = searchedFoods![indexPath.row]
        }
        else {
            if showBookmark {
                draggingFood = bookmarkedFoods[indexPath.row]
            } else {
                if indexPath.row == 0 {
                    draggingFood = nil
                } else {
                    draggingFood = foods[indexPath.row - 1]
                }
            }
        }
        print(draggingFood?.name)
        return [dragItem]
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#function)
        showSearchItem = true
        searchedFoods = foods.filter{ $0.name == textField.text }
        itemCollectionView.reloadData()
        bookMarkButton.isHidden = true
        itemSortButton.isHidden = true
//        itemCollectionView.snp.updateConstraints { make in
//            make.top.equalTo(refrigeCollectionView.snp.bottom)
//        }
//        itemSearhBar.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(#function)
        previousButton.isHidden = false
        bookMarkButton.isHidden = true
        itemSortButton.isHidden = true
        itemSearhBar.snp.updateConstraints { update in
            update.left.equalTo(40)
            update.width.equalTo(340)
        }
        itemCollectionView.snp.updateConstraints { make in
            make.top.equalTo(refrigeCollectionView.snp.bottom).inset(120)
            
        }
    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print(#function)
//        bookMarkButton.isHidden = false
//        itemSortButton.isHidden = false
//    }
    
}

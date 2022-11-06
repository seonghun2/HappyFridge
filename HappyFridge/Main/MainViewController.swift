//
//  ViewController.swift
//  HappyRefrige
//
//  Created by user on 2022/10/29.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var refrigeCollectionView: UICollectionView!
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    @IBOutlet weak var bookMarkButton: UIButton!
    
    var itemSearhBar = ItemSearchTextField()
    // 냉장고 크게/작게보기 결정할 변수
    var showSmall: Bool = true
    
    var refrigeArray: [Refrigerator] = [r1,r2,r3,r4,r5,r6,r7,r8,r9]
    
    var itemArray: [Item] = [i1,i2,i3,i4,i5,i6,i7,i8,i9,i10]
    var bookmarkItemArray: [Item] = []
    
    var showOnlyBookmark: Bool = false
    
    // 드래그한 셀을 저장할 변수, 냉장고 셀에 드랍할때 사용
    var draggingItem: Item?
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        
        setRefrigeCollectionView()
        setItemCollectionView()
    }
    
    func setRefrigeCollectionView() {
        refrigeCollectionView.register(UINib(nibName: "RefrigeSmallCell", bundle: nil), forCellWithReuseIdentifier: "RefrigeSmallCell")
        
        refrigeCollectionView.delegate = self
        refrigeCollectionView.dataSource = self
        refrigeCollectionView.dropDelegate = self
        
        let flowLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            if showSmall {
                layout.sectionInset = UIEdgeInsets(top: 70, left: 40, bottom: 40, right: 20)
                layout.minimumLineSpacing = 40.0
                layout.itemSize = CGSize(width: 160, height: 150)
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
        refrigeCollectionView.backgroundColor = .darkGray
        
        refrigeCollectionView.isPagingEnabled = true
        
        // 냉장고가 없을때 이미지 표시
        refrigeCollectionView.backgroundView = UIImageView(image: UIImage(systemName: "sunrise"))
        refrigeCollectionView.backgroundView?.isHidden = true
        
        if refrigeArray.isEmpty {
            refrigeCollectionView.backgroundView?.isHidden = false
        }
    }
    
    func setItemCollectionView() {
        itemCollectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        itemCollectionView.dragDelegate = self
        
        let flowLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 50, left: 40, bottom: 70, right: 20)
            layout.minimumLineSpacing = 12
            layout.itemSize = CGSize(width: 100, height: 100)
            return layout
        }()
        
        itemCollectionView.collectionViewLayout = flowLayout
        itemCollectionView.showsHorizontalScrollIndicator = false
        itemCollectionView.backgroundColor = .systemGray4
        itemCollectionView.isPagingEnabled = true
        
        itemCollectionView.addSubview(itemSearhBar)
        itemSearhBar.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.left.equalTo(15)
            make.width.equalTo(248)
            make.height.equalTo(32)
        }
    }
    
    @IBAction func refrigeSortButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "정렬방식 선택", message: "message", preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "이름순", style: .default) {_ in
            self.refrigeArray.sort{$0.name < $1.name}
            self.refrigeCollectionView.reloadData()
        }
        alert.addAction(action)
        
        let action2 = UIAlertAction(title: "추가순", style: .default) {_ in
            self.refrigeArray.sort{$0.id < $1.id}
            self.refrigeCollectionView.reloadData()
        }
        alert.addAction(action2)
        
        let action3 = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(action3)
        
        present(alert, animated: true)
        
    }
    
    @IBAction func refrigeAddButtonTapped(_ sender: Any) {
        print(#function)
        
        let alert = UIAlertController(title: "장소 추가", message: nil, preferredStyle: .alert)
        
        alert.addTextField()
        
        let action = UIAlertAction(title: "추가", style: .default) {_ in
            if let name = alert.textFields?[0].text {
                let newRefrige = Refrigerator(name: name, items: [])
                self.refrigeArray.append(newRefrige)
                
                self.refrigeCollectionView.backgroundView?.isHidden = true
                self.refrigeCollectionView.reloadData()
                
                // 셀 추가시 컬렉션 뷰 맨오른쪽으로 스크롤
                let item = self.refrigeCollectionView.numberOfItems(inSection: 0) - 1
                let lastIndex = IndexPath(item: item, section: 0)
                print(lastIndex)
                self.refrigeCollectionView.scrollToItem(at: lastIndex, at: .right, animated: true)
            }
        }
        alert.addAction(action)
        
        let action2 = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(action2)
        
        present(alert,animated: true)
    }
    
    @IBAction func bookMarkButtonTapped(_ sender: UIButton) {
        print(#function, showOnlyBookmark)
        if showOnlyBookmark {
            showOnlyBookmark = false
            bookMarkButton.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            bookmarkItemArray = itemArray.filter { $0.isBookmarked == true }
            showOnlyBookmark = true
            bookMarkButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        print(bookmarkItemArray)
        itemCollectionView.reloadData()
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == refrigeCollectionView{
            return refrigeArray.count
        } else {
            if showOnlyBookmark {
                return bookmarkItemArray.count
            } else {
                return itemArray.count + 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 냉장고 목록
        if collectionView == refrigeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RefrigeSmallCell", for: indexPath) as! RefrigeSmallCell
            
            cell.refrigeNameLabel.text = refrigeArray[indexPath.row].name
            cell.itemList = refrigeArray[indexPath.row].items
//            var itemList = ""
//            for itemName in refrigeArray[indexPath.row].items {
//                itemList.append("\(itemName.name)\n")
//            }
//            cell.itemListLabel.text = itemList
            
//            var ddayList = ""
//            for date in refrigeArray[indexPath.row].items {
//                ddayList.append("\(getDdayString(date: date.expirationDate))\n")
//
//            }
//            cell.itemDdayLabel.text = ddayList
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 20
            //****
            cell.itemListTableView.reloadData()
            if refrigeArray[indexPath.row].isShared {
                cell.layer.borderColor = CGColor(gray: 1, alpha: 0.2)
                cell.layer.borderWidth = 3
            }
            return cell
        //하단품목
        } else {
                
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
            cell.backgroundColor = .green
            cell.layer.cornerRadius = 10
            cell.index = indexPath.row
            // 즐겨찾기품목
            if showOnlyBookmark {
                cell.plusImage.isHidden = true
                cell.itemNameLabel.isHidden = false
                cell.bookmarkButton.isHidden = false
                cell.itemNameLabel.text = bookmarkItemArray[indexPath.row].name
                cell.isBookmarked = bookmarkItemArray[indexPath.row].isBookmarked
                cell.setBookmarkButton()
                return cell
            // 모든품목
            } else {
                // +셀
                if indexPath.row == 0 {
                    cell.plusImage.isHidden = false
                    cell.itemNameLabel.isHidden = true
                    cell.bookmarkButton.isHidden = true
                    return cell
                // 나머지셀
                } else {
                    cell.isBookmarked = itemArray[indexPath.row - 1].isBookmarked
                    cell.setBookmarkButton()
                    cell.plusImage.isHidden = true
                    cell.itemNameLabel.isHidden = false
                    cell.bookmarkButton.isHidden = false
                    
                    cell.itemNameLabel.text = itemArray[indexPath.row - 1].name
                    cell.eventClosure = { index, toggle in
                        self.itemArray[index - 1].isBookmarked = toggle
                        print(index - 1, toggle)
                        print(self.itemArray[index - 1])
                        print(self.itemArray)
                    }
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == itemCollectionView && indexPath.row == 0 {
            print("아이템추가 팝업")
            let itemAddAlert = UIAlertController(title: "품목추가", message: nil, preferredStyle: .alert)
            itemAddAlert.addTextField()
            let addAction = UIAlertAction(title: "추가", style: .default) { _ in
                if let name = itemAddAlert.textFields?[0].text {
                    let newItem = Item(name: name)
                    
                    self.itemArray.append(newItem)
                    self.itemCollectionView.reloadData()
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

extension MainViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    //드랍할때 호출. 전역변수에 저장되어있는 item을 드랍하는 냉장고의 items배열에 append해줌
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
         
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
                    make.left.equalTo(60)
                    
                }
                dateChooserAlert.addAction(UIAlertAction(title: "선택완료", style: .cancel) { _ in
                    print(datePicker.date)
                    self.draggingItem?.expirationDate = datePicker.date
                    
                    self.refrigeArray[destinationIndexPath].items.append(self.draggingItem!)
                    self.draggingItem = nil
                    print(destinationIndexPath)
                    
                    //전체컬렉션뷰 리로드
                    //self.refrigeCollectionView.reloadData()
                    
                    //셀 하나만 리로드
                    let indexPath = IndexPath(item: destinationIndexPath, section: 0)
                    self.refrigeCollectionView.reloadItems(at: [indexPath])
                })
                
                
                   
                let height: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
                
                dateChooserAlert.view.addConstraint(height)
                
                present(dateChooserAlert, animated: true)
            }
        }
    }
    
    //드래그 시작될때 호출. 드래그하는 item을 전역변수에 저장시킴
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        let item = itemArray[indexPath.row].name
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
        print(#function, itemProvider, dragItem)
        
        draggingItem = itemArray[indexPath.row-1]
        return [dragItem]
    }
}

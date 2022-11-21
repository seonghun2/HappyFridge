//
//  SearchViewController.swift
//  HappyFridge
//
//  Created by LCW on 2022/11/21.
//

import UIKit

class SearchViewController: UIViewController {
    var searchFoodInfoArray: [Food] = []
    var searchFoodInfoArray2: [Food] = []

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTableView.dataSource = self
        searchTableView.delegate = self
      
        let nibName = UINib(nibName: "FridgeDetailCellTableViewCell", bundle: nil)
        searchTableView.register(nibName, forCellReuseIdentifier: "FridgeDetailCellTableViewCell")
    }
    
    
    @IBAction func searchAction(_ sender: Any) {
        if let keyWord = searchTextField.text {
            searchFoodInfoArray2 = searchFoodInfoArray.filter {
                $0.foodName == keyWord
            }
            searchTableView.reloadData()
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
            //cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 72 }
    
    
}

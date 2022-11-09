//
//  ItemCell.swift
//  HappyFridge
//
//  Created by user on 2022/10/30.
//

import UIKit
import SnapKit
class ItemCell: UICollectionViewCell {

    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    let plusImage = UIImageView(image: (UIImage(systemName: "plus")))
    var index: Int?
    var isBookmarked: Bool = false
    
    var eventClosure: ((Int, Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bookmarkButton.tintColor = .black
        self.addSubview(plusImage)
        plusImage.tintColor = .black
        plusImage.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.center.equalToSuperview()
        }
        
    }
    func setBookmarkButton() {
        print(#function)
        if isBookmarked {
            bookmarkButton.setImage(UIImage(named: "star_fill"), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(named: "star_empty"), for: .normal)
        }
    }
    

    
    @IBAction func bookmarkButtonTapped(_ sender: UIButton) {
        if isBookmarked {
            bookmarkButton.setImage(UIImage(named: "star_empty"), for: .normal)
            isBookmarked = false
            eventClosure!(index!, isBookmarked)
           
        } else {
            bookmarkButton.setImage(UIImage(named: "star_fill"), for: .normal)
            isBookmarked = true
            eventClosure!(index!, isBookmarked)
        }
    }
}

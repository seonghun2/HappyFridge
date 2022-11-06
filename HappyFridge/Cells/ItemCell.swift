//
//  ItemCell.swift
//  HappyFridge
//
//  Created by user on 2022/10/30.
//

import UIKit
import SnapKit
class ItemCell: UICollectionViewCell {

    let plusImage = UIImageView(image: (UIImage(systemName: "plus")))
    var index: Int?
    var isBookmarked: Bool = false
    
    var eventClosure: ((Int, Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.addSubview(plusImage)
        plusImage.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.center.equalToSuperview()
        }
        
    }
    func setBookmarkButton() {
        print(#function)
        if isBookmarked {
            bookmarkButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBAction func bookmarkButtonTapped(_ sender: UIButton) {
        if isBookmarked {
            bookmarkButton.setImage(UIImage(systemName: "star"), for: .normal)
            isBookmarked = false
            eventClosure!(index!, isBookmarked)
           
        } else {
            bookmarkButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            isBookmarked = true
            eventClosure!(index!, isBookmarked)
        }
    }
}

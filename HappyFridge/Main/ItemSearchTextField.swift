//
//  ItemSearchTextField.swift
//  HappyFridge
//
//  Created by user on 2022/11/06.
//

import UIKit

class ItemSearchTextField: UITextField {
    
    let stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [UIView(), UIImageView(image: UIImage(named: "search"))])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = -12
        stackView.distribution = .fillEqually
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        layer.cornerRadius = 15
        placeholder = "검색어를 입력하세요"
        returnKeyType = .search
        leftView = stackView
        leftViewMode = .always
     
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


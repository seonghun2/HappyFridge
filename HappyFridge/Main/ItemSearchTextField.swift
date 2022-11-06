//
//  ItemSearchTextField.swift
//  HappyFridge
//
//  Created by user on 2022/11/06.
//

import UIKit

class ItemSearchTextField: UITextField {

    var searchButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //border.
        backgroundColor = .lightGray
        layer.borderWidth = 1
        
        placeholder = "검색어를 입력하세요"
        
        searchButton.titleLabel?.text = "Test"
        searchButton.backgroundColor = .red
        self.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(3)
            make.right.equalTo(-5)
            make.width.height.equalTo(20)
        }
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


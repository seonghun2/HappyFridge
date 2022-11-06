//
//  ItemSearchTextField.swift
//  HappyFridge
//
//  Created by user on 2022/11/06.
//

import UIKit

class ItemSearchTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //border.
        backgroundColor = .red
        layer.borderWidth = 1
        
        //placeholder = "검색어를 입력하세요"
        
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
extension ItemSearchTextField: UITextViewDelegate {
    
}

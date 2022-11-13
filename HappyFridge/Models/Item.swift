//
//  Item.swift
//  HappyFridge
//
//  Created by user on 2022/10/30.
//

import Foundation

struct Item: Codable{
    var name: String
    //var isBookmarked: Bool = false
    //var performAlert: Bool = true
    
    var expirationDate: Date?
    
    var count: Int?
    var isBookmarked: Bool?
    //var alertDay: Int = 0
}

//var i0 = Item(name: "")
//var i1 = Item(name: "감자1")
//var i2 = Item(name: "감자2")
//var i3 = Item(name: "감자3")
//var i4 = Item(name: "감자4")
//var i5 = Item(name: "감자5")
//var i6 = Item(name: "감자6")
//var i7 = Item(name: "감자7")
//var i8 = Item(name: "감자8")
//var i9 = Item(name: "감자9")
//var i10 = Item(name: "감자10")


//
//  Refrigerator.swift
//  HappyFridge
//
//  Created by user on 2022/10/30.
//

import Foundation

struct Refrigerator {
    
    var id: Int = 0
    var name: String
    var items: [Item]
    var isShared: Bool = false
    
    init(name: String, items: [Item]) {
        
        self.name = name
        self.items = items
        
    }
}

var r1 = Refrigerator(name: "1", items: [i1,i3,i5])
var r2 = Refrigerator(name: "2", items: [i10,i6,i7])
var r3 = Refrigerator(name: "3", items: [i9,i2,i5])
var r4 = Refrigerator(name: "4", items: [i6,i3,i5])
var r5 = Refrigerator(name: "5", items: [i7,i2,i3])
var r6 = Refrigerator(name: "6", items: [i4,i3,i5])
var r7 = Refrigerator(name: "7", items: [i5,i3,i5])
var r8 = Refrigerator(name: "8", items: [i1,i3,i5])
var r9 = Refrigerator(name: "9", items: [i2,i3,i5])
var r10 = Refrigerator(name: "33", items: [i2])

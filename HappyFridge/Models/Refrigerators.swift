//
//  Refrigerator.swift
//  HappyFridge
//
//  Created by user on 2022/10/30.
//

import Foundation

struct Refrigerators: Codable {
    let fridges: [Refrigerator]
}

struct Refrigerator: Codable {

    var isShared: Bool
    var fridgeName: String
    var owner: String
    var notice: String?
    let createDate: Date
    var food: [Item]?
}

//enum AnyValue: Codable {
//    case string(String)
//    case date(Date)
//    case food([Item])
//    case int(Int)
//    init(from decoder: Decoder) throws {
//        if let string = try? decoder.singleValueContainer().decode(String.self) {
//            self = .string(string)
//            return
//        }
//        if let date = try? decoder.singleValueContainer().decode(Date.self) {
//            self = .date(date)
//            return
//        }
//        if let food = try? decoder.singleValueContainer().decode([Item].self) {
//            self = .food(food)
//            return
//        }
//        if let int = try? decoder.singleValueContainer().decode(Int.self) {
//            self = .int(int)
//            return
//        }
//        throw AnyValueError.typeMisMatch
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        
//        switch self {
//        case .string(let value):
//            try container.encode(value)
//        case .date(let value):
//            try container.encode(value)
//        case .food(let value):
//            try container.encode(value)
//        case .int(let value):
//            try container.encode(value)
//        }
//    }
//    
//    enum AnyValueError:Error {
//        case typeMisMatch
//    }
//}
//    var id: Int = 0
//    var name: String
//    var items: [Item]
//    var isShared: Bool = false
//
//    init(name: String, items: [Item]) {
//
//        self.name = name
//        self.items = items
        
//    }



//var r1 = Refrigerator(name: "1", items: [i1,i3,i5])
//var r2 = Refrigerator(name: "2", items: [i10,i6,i7])
//var r3 = Refrigerator(name: "3", items: [i9,i2,i5])
//var r4 = Refrigerator(name: "4", items: [i6,i3,i5])
//var r5 = Refrigerator(name: "5", items: [i7,i2,i3])
//var r6 = Refrigerator(name: "6", items: [i4,i3,i5])
//var r7 = Refrigerator(name: "7", items: [i5,i3,i5])
//var r8 = Refrigerator(name: "8", items: [i1,i3,i5])
//var r9 = Refrigerator(name: "9", items: [i2,i3,i5])
//var r10 = Refrigerator(name: "33", items: [i2])

//
//  Fridges.swift
//  HappyFridge
//
//  Created by LCW on 2022/11/05.
//

import Foundation

struct Fridges: Codable {
    var fridge: [Fridge]
}

struct Fridge: Codable {
    let createDate: Date
    let fridgeName: String
    let owner: String
    let notice: String
    var food: [Food]
}

struct Food: Codable {
    var foodName: String
    var count: Int
    let expirationDate: Date
    let createDate: Date?
}

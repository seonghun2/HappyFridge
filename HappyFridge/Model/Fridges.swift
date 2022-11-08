//
//  Fridges.swift
//  HappyFridge
//
//  Created by LCW on 2022/11/05.
//

import Foundation

struct Fridges: Codable {
    let fridge: [Fridge]
}

struct Fridge: Codable {
    let createDate: Date
    let fridgeName: String
    let owner: String
    let notice: String
    let food: [Food]
}

struct Food: Codable {
    let foodName: String
    let count: Int
    let expirationDate: Date
}

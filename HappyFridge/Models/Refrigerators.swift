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


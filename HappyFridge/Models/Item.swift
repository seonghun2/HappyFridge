//
//  Item.swift
//  HappyFridge
//
//  Created by user on 2022/10/30.
//

import Foundation

struct Item: Codable{
    var name: String
    var isBookmarked: Bool?
    var performAlert: Bool?
    
    var expirationDate: Date?
    var count: Int?

    var createDate: Date?
    var alertDay: Int?
}

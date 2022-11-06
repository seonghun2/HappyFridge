//
//  Users.swift
//  HappyFridge
//
//  Created by LCW on 2022/11/05.
//

import Foundation

struct Users: Codable {
    let nickName: String
    //let registerDate: String
    let token: String
    let favorite: [String]
    let defalutFood: [String]
}


//
//  Fridges.swift
//  HappyFridge
//
//  Created by LCW on 2022/11/05.
//

import Foundation

struct Fridges: Codable {
    let fridge:[Fridge]
}

struct Fridge: Codable {
    //let createDate:String
    let fridgeName:String
    let owner:String
}

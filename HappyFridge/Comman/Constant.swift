//
//  Constant.swift
//  HappyFridge
//
//  Created by LCW on 2022/11/06.
//

import Foundation

struct Constant {
    static var nickName = UserDefaults.standard.string(forKey: "nickName")
    private init() {}
}

//
//  AppConfigModel.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/22.
//

import Foundation

///app 配置信息
struct AppConfigModel: Codable {
    struct Config: Codable {
//        let accessLogNum: String?
//        let focusLogNum: Int?
//        let guildCode: Int?
        let curCustomerType: String?
    }
    let user: Config?
}

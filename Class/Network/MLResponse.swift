//
//  MLResponse.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/23.
//

import Foundation

struct EmptyModel: Codable {}

struct MLData: Codable {
    let data: String?
}

struct MLResponse<T: Codable>: Codable {
    let code: Int
    let msg: String?
    let data: T?
    
    ///token 错误，一般退出登录或者更新token。
    var isTokenError: Bool {
        code == 2
    }
}

struct MLListResult<T: Codable>: Codable, ListDatasProtocol {
    let result: [T]?
    
    var list: [T]? {
        return result
    }
}

struct MLListMessages<T: Codable>: Codable, ListDatasProtocol {
    let messages: [T]?
    
    var list: [T]? {
        return messages
    }
}

struct MLListUsers: Codable, ListDatasProtocol {
    let users: [UserDetailUserInfo]?
    
    var list: [UserDetailUserInfo]? {
        return users
    }
}

enum MLError: Error {
    case error(Error)
    case service(msg: String?, code: Int)
}

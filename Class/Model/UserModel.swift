//
//  UserModel.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/21.
//

import Foundation

struct UserModel: Codable {
    let thirdId: String? //登录账号
    let domain: String! //oss地址
    let trait: Bool?
    var user: UserInfo!
    var userDetail: UserDetailInfo?
    
    ///头像完整路径
    var avatar: String? {
        if let icon = user.icon {
            return domain.appendingPathComponent(icon)
        }
        return nil
    }
    
    ///是否为主播
    var isHost: Bool {
        user?.isHost ?? false
    }
}

struct UserInfo: Codable {
    let id: Int
    let imUserid: String
    let name: String
    let token: String
    var imToken: String
    let aliPay: Int?
    let wxPay: Int?
    let gender: Gender?
    let idCard: String?
    let host: Int?
    let icon: String?
    let verified: Int?
    
    var isHost: Bool {
        host == 1
    }
    ///头像完整路径
    var avatar: String? {
        if let icon = icon {
            return UserCenter.share.userModel?.domain?.appendingPathComponent(icon)
        }
        return nil
    }
}

struct UserDetailInfo: Codable {
    let pay: UserPayInfo
    let user: UserDetailUserInfo
}

struct UserDetailUserInfo: Codable {
    let userId: Int
    let phone: String?
    let inviteCode: String?
    let name: String?
    let birthday: String?
    let gender: Gender?
    let city: String?
    let province: String?
    let icon: String?
    let privacy: Int?
    let hostAudit: Int?
    let photos: [UserPhotoInfo]?
    let local: Int?
    let uss: String?
    let identity: Int?
    let host: Int?
    let persionSign: String?
    let isHello: Int?
    let dnd: Int?
    let hostAuditRemind: String?
    let height: Int?
    let fansNum: Int?
    let charge: Int?
    let level: Int?
    let em: String?
    let weight: Int?
    let pro: String?
    let wxShow: Int?
    let noGneder: Int?
    let focusNum: Int?
    let earn: Double?
    let activeCoin: Int?
    let age: Int?
    let lables: [UserTagInfo]?
    let backgroundCoverUrl: String?
    
    ///头像完整路径
    var avatar: String? {
        if let icon = icon {
            return UserCenter.share.userModel?.domain?.appendingPathComponent(icon)
        }
        return nil
    }
    
    var backgroundImg: String? {
        if let icon = backgroundCoverUrl {
            return UserCenter.share.userModel?.domain?.appendingPathComponent(icon)
        }
        return nil
    }
}

struct UserPayInfo: Codable {
    let wxpay: Int
    let alipay: Int
}

struct UserPhotoInfo: Codable {
    let icon: String
}

struct UserTagInfo: Codable {
    let name: String
    let id: Int
}

extension UserModel: IMTokenUser {
    var imUsername: String { user?.imUserid ?? "" }
    var imToken: String { user?.imToken ?? "" }
}

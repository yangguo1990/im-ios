//
//  MLAPI.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/23.
//

import Foundation
import Moya
import CryptoSwift

//app api
enum MLApi {
    case areaCode
    case login(phone: String, code: String)
    case sendCode(phone: String, type: String) ///发送验证码
    case regist(info: [String: Any])
    case myselfInfo
    case getRandomName
    case getOssToken(fileName: String)
    case getImToken
    case getRtcToken(cName: String)
    case getRtmToken
    case preCall(userId: Int)
    case stopCall(cName: String)
    case inCall(cName: String, toUserId: Int)
    case systemMsg(info: [String: Any])
    case giftList
    case onlineMatch
    case sendGift(toUser: Int, giftId: Int, type: Int, number: Int, relationId: Int)
    case getHiText
    case sayHiBatch(contentId: Int, toIds: [Int])
    case getConfig
    case getKfUrl
    case getPhoneRecord(page: Int, limit: Int)
}

extension MLApi: TargetType, MLHUDType {
    
    var baseURL: URL {
        return URL(string: Constants.url.base)!
    }
    var method: Moya.Method {
        switch self {
        case .areaCode, .getKfUrl:
            return .get
        default:
            return .post
        }
    }
    var path: String {
        switch self {
        case .areaCode:  return "/base/countryMobilePrefixList"
        case .sendCode:  return "/base/sendCode"
        case .login:     return "/login/login"
        case .regist:    return "/login/register"
        case .myselfInfo: return "/user/getUserInfo"
        case .getRandomName: return "/login/randomName"
        case .getOssToken: return "/base/getUploadToken"
        case .getImToken: return "/im/getImToken"
        case .getRtmToken: return "/im/getRtmToken"
        case .getRtcToken: return "/im/getRtcTokenBycNameAndUid"
        case .preCall:   return "/im/preCall"
        case .stopCall:  return "/im/stopCall"
        case .inCall:    return "/im/inCall"
        case .systemMsg: return "/push/getPushMessage"
        case .giftList:  return "/im/getGifts"
        case .onlineMatch: return "/host/onlineMatchingList"
        case .sendGift:  return "/im/giveGift"
        case .getHiText: return "/host/selectUserCallCentent"
        case .sayHiBatch: return "/host/sayHelloBatch"
        case .getConfig: return "/user/getUserSimpleInfo"
        case .getKfUrl:  return "/base/getCustomUrl"
        case .getPhoneRecord: return "im/videoCallList"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case let .login(phone, code):
            return ["thirdId": phone, "code": code, "type": 0]
        case let .sendCode(phone, type):
            return ["phone": phone, "op": type]
        case let .regist(info):
            return info
        case let .getOssToken(fileName):
            return ["fileName": fileName]
        case let .getRtcToken(cName):
            return ["cName": cName]
        case let .preCall(userId):
            return ["toUserId": userId, "isNotSend": 0]
        case let .stopCall(cName):
            return ["channelId": cName, "channelName": cName]
        case let .inCall(cName, toUserId):
            return ["channelId": cName, "channelName": cName, "toUserId": toUserId, "isNotSend": 0]
        case let .systemMsg(info):
            return info
        case .onlineMatch:
            return ["limit": 10]
        case let .sendGift(toUser, giftId, type, number, relationId):
            return ["toUserId": toUser, "type": type, "giftId": giftId, "relationId": relationId, "num": number, "origin": 0]
        case let .sayHiBatch(contentId, toIds):
            return ["contentId": contentId, "toUserIds": toIds.map({ $0.string }).joined(separator: ",")]
        case let .getPhoneRecord(page, limit):
            return ["contentId":page,"limit":limit]
        default:
            return [:]
        }
    }
    
    var extra: [String: String] {
        var location = ""
        if let longitude = UserDefaults.standard.string(forKey: Constants.userDefualt.longitude),
            let latitude = UserDefaults.standard.string(forKey: Constants.userDefualt.latitude) {
            location = "\(longitude),\(latitude)"
        }
        let dic = [
            "sysType": Constants.device.systemName,
            "sysVersion": Constants.device.systemVersion,
            "appVersion": Constants.app.version,
            "phoneType": Constants.device.model,
            "ip": Constants.device.ipAdrress ?? "",
            "imei": Constants.device.uuid,
            "platform": "iOS",
            "location": location
        ]
        return dic
    }
    
    var commonParameters: [String: Any] {
        let nonce = String(format: "%04d", arc4random_uniform(10000))
        let time = (Date().timeIntervalSince1970 * 1000).int.string
        let signture = (Constants.AES.encryptKey + nonce + time).sha1()
        let userToken = UserCenter.share.userModel?.user?.token ?? UserCenter.tempToken
        let dic = [
            "token": userToken,
            "nonce": nonce,
            "currTime": time,
            "checkSum": signture,
            "extra": extra.jsonString() ?? ""
        ]
        return dic
    }
    
    var task: Task {
        let p = commonParameters.merging(parameters) { $1 }
        return .requestParameters(parameters: p, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        let nonce = String(format: "%04d", arc4random_uniform(10000))
        let time = (Date().timeIntervalSince1970 * 1000).int.string
        let signture = (Constants.AES.encryptKey + nonce + time).sha1()
        let dic = [
            "nonce": nonce,
            "currTime": time,
            "checkSum": signture,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        return dic
    }
    
    var isHUD: Bool {
        switch self {
        case .areaCode, .getOssToken, .inCall, .stopCall, .systemMsg, .getHiText, .onlineMatch, .getConfig:
            return false
        default:
            return true
        }
    }
}

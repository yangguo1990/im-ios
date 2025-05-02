//
//  Models.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/24.
//

import Foundation

///电话区号
struct AreaModel: Codable {
    let country: String
    let mobile_prefix: String
}

///随机昵称
struct RandomNameModel: Codable {
    let name: String
}

///预拨打用户信息
struct PreCallUserInfo: Codable {
    let standard: Int
    let otherInfo: UserDetailUserInfo
}

///通话提醒
struct CallTipInfo: Codable {
    let mind: Int
    let rest: Int
}

///系统通知
struct SystemMessageModel: Codable {
    let createTime: TimeInterval
    let title: String
    let content: String
}

///礼物列表
struct GiftListModel: Codable, Equatable {
    let gifts: [GiftModel]
    let coin: Int
    
    var sortGifts: [GiftModel] {
        let arrays = gifts.split(intoChunksOf: 8)
        var sortArray = [GiftModel]()
        for array in arrays {
            var subArray = [GiftModel]()
            let midIndex = array.count / 2
            for i in 0..<midIndex {
                subArray.append(array[i])
                if i + midIndex < array.count {
                    subArray.append(array[i + midIndex])
                }
            }
            if array.count % 2 == 1 {
                subArray.append(array.last!)
            }
            sortArray.append(contentsOf: subArray)
        }
        return sortArray
    }
}
struct GiftModel: Codable, Equatable {
    let id: Int
    let coin: Int
    let name: String
    let icon: String
    let vfx: String
    
    var fullIcon: String? {
        UserCenter.share.userModel?.domain?.appendingPathComponent(icon)
    }
}

struct GiftSendModel: Codable {
    let cmd: String
    let forward: String ///接受者id
    let fromUserId: String ///发送者id
    let forName: String ///发送者名字
    let number: String ///赠送数量
    let gift: IMGift
}

struct IMGift: Codable {
    let anim_type: String
    let id: String
    let name: String
    let price: String
    let src: String
    let animationSrc: String
}

struct IMHelloTextList: Codable {
    let hostCallContents: [IMHelloText]?
}
struct IMHelloText: Codable {
    let id: Int
    let content: String
}

struct KfUrlModel: Codable {
    let url: String
}

struct recordData:Codable{
    let hosts:[phoneRecordHost]
}

struct phoneRecordHost: Codable{
    let create_time:String
    let gender:Int
    let icon:String
    let id:Int
    let interval:String
    let name:String
    let online:Int
    let secs:Int
    let status:Int
    let type:Int
    let userId:Int
}



//
//  IMConversationModel.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/15.
//

import UIKit
import HyphenateChat

extension EMChatMessage {
    var isSelf: Bool {
        direction == .send
    }
}

extension EMUserInfo {
    var showName: String {
        if userId == Constants.im.messageId {
            return "官方消息"
        }
        if userId == Constants.im.serviceId {
            return "官方客服"
        }
        if let nickname = nickname, !nickname.isEmpty {
            return nickname
        }
        return userId ?? "未知用户"
    }
}

class IMConversationModel {
    let conversation: EMConversation
    var user: EMUserInfo?
    
    ///用于设置头像颜色，因为是随机颜色，所以保存在数据模型中，防止每次reloadData的时候颜色变化
    var avatarColor = UIColor.random.alpha(0.7)
    
    init(conversation: EMConversation, user: EMUserInfo? = nil) {
        self.conversation = conversation
        self.user = user
    }
    
    ///默认情况是true
    var isListenedVoiceMsg: Bool {
        guard let msg = conversation.latestMessage else { return true }
        if msg.isSelf { return true }
        guard let _ = msg.body as? EMVoiceMessageBody else { return true }
        return msg.isListened
    }
}

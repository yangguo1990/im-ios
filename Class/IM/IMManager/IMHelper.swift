//
//  IMHelper.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/14.
//

import Foundation
import HyphenateChat

struct IMHelper {
    /// 获取消息摘要
    static func getAbstructOf(message: EMChatMessage?) -> String {
        guard let message = message else { return "" }

        let type = message.body.type
        switch type {
        case .text:
            return (message.body as? EMTextMessageBody)?.text ?? ""
        case .image:
            return "[图片]"
        case .voice:
            return "[语音]"
        case .video:
            return "[视频]"
        case .custom:
            return getCustomMessage(message)
        default:
            return ""
        }
    }
    static func getAbstructOf(conversation: EMConversation?) -> String {
        guard let conversation = conversation, let message = conversation.latestMessage else { return "" }
        return getAbstructOf(message: message)
    }
    
    private static func getCustomMessage(_ message: EMChatMessage) -> String {
        guard let body = message.body as? EMCustomMessageBody else { return "[自定义消息]" }
        if body.event == Constants.im.callEvent {
            if let data = body.customExt["data"]?.data(using: .utf8),
               let model = try? JSONDecoder().decode(IMCallModel.self, from: data) {
                return "[\(model.imString)]"
            }
        }else if body.event == Constants.im.giftEvent {
            return "[礼物]"
        }
        return "[自定义消息]"
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func imVoicePath() -> URL? {
        let url = getDocumentsDirectory().appendingPathComponent("com_meiliao_data/voice")
        //查找目录，如果没有就创建一个目录
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
            }catch {
                return nil
            }
        }
        return url.appendingPathComponent(genVoiceName())
    }
    
    private static func genVoiceName() -> String {
        let uuid = UUID()
        let value1 = arc4random() % 1000
        let value2 = Int(Date().timeIntervalSince1970)
        return "\(uuid)_\(value1)_voice_\(value2).m4a"
    }
    
    static func getImgSizeOf(origin: CGSize?) -> CGSize {
        ///如果原大小小于等于0，返回默认大小68
        guard let width = origin?.width, let height = origin?.height, width > 0, height > 0 else {
            return .init(width: 68, height: 68)
        }
        
        ///如果宽度大于高度，取最大宽度为200
        if width >= height {
            let w = min(200, width)
            var h = w * (height / width) ///根据宽度计算高度
            if h < 40 { ///高度最低限制
                h = 40
            }
            return .init(width: w, height: h)
        }
        
        ///高度大于宽度，取最大高度300
        var h = min(300, height)
        if h < 40 { ///高度最低限制
            h = 40
        }
        
        var w = h * (width / height) ///根据高度计算宽度
        if w > 220 { ///如果计算的宽度大于220， 则减小高度，设置为220，然后重新计算宽度
            h = 220
            w = h * (width / height)
        }
        return .init(width: w, height: h)
    }
}

//
//  IMChatVM.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/14.
//

import Foundation
import HyphenateChat
import RxSwift
import AVFAudio
import Kingfisher

class IMChatMsgModel {
    var msg: EMChatMessage!
    var isShowTime: Bool = false
    var isSoundPlaying: Bool = false
    
    var isEnabledRTC: Bool {
        if isShowTime { return false }
        if msg.body.type == .text { return true }
        if msg.body.type == .custom, let custom = msg.body as? EMCustomMessageBody {
            if custom.event == Constants.im.giftEvent {
                return true
            }
        }
        return false
    }
}

class IMChatVM: NSObject {
    var userId: Int {
        chatId.removingPrefix("im").int ?? 0
    }
    var isService: Bool {
        chatId == Constants.im.serviceId || chatId == Constants.im.messageId
    }
    let disposeBag = DisposeBag()
    let chatId: String
    let chatType: EMChatType
    init(chatId: String, chatType: EMChatType = .chat, isLoadHistory: Bool = true) {
        self.chatId = chatId
        self.chatType = chatType
        super.init()
        self.requestUserInfo()
        if isLoadHistory {
            self.requestMsg()
        }
        
        IMManager.receivedNewMsgSubject.subscribe(onNext: { [weak self] in
            self?.receivedNewMsgs($0)
        }).disposed(by: disposeBag)
    }
    
    var conversation: EMConversation?
    
    private var audioPlayer: AVAudioPlayer?
    private var playingMsg: IMChatMsgModel?
    
    //user
    private(set) var user: EMUserInfo?
    let userSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    
    ///datas
    private(set) var messages: [IMChatMsgModel] = []
    let messagesFirstLoadSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    let messagesChangeSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    
    ///输入框高度发生变化
    let inputHeightChangeSubject = PublishSubject<Bool>()
    
    ///礼物动画
    let playGiftAnimate = PublishSubject<String>()
    ///显示礼物
    let showGiftSubject = PublishSubject<Bool>()
    ///显示语音
    let showVoiceSubject = PublishSubject<Bool>()
    
    ///浏览图片
    private var imgUrls: [URL]?
}

extension IMChatVM {
    
    ///获取用户信息
    func requestUserInfo() {
        let id = self.chatId
        EMClient.shared().userInfoManager?.fetchUserInfo(byId: [id], completion: { [weak self] result, error in
            if let user = result?[id] {
                self?.user = user
                DispatchQueue.main.async {
                    self?.userSubject.onNext(true)
                }
            }
        })
    }
    
    ///获取历史消息
    private func requestMsg() {
        conversation = EMClient.shared().chatManager?.getConversation(chatId, type: .chat, createIfNotExist: true)
        let messages = conversation?.loadMessagesStart(fromId: nil, count: 400, searchDirection: .up) ?? []
        
        var array = [IMChatMsgModel]()
        for (index, msg) in messages.enumerated() {
            let chatmsg = IMChatMsgModel()
            chatmsg.msg = msg
            
            var isTime = false
            if index == 0 {
                isTime = true
            }else {
                let previous = messages[index - 1]
                if msg.localTime - previous.localTime > 5 * 60 * 1000 {
                    isTime = true
                }
            }
            
            ///插入时间消息
            if isTime {
                let timeMsg = IMChatMsgModel()
                timeMsg.isShowTime = true
                timeMsg.msg = msg
                array.append(timeMsg)
            }
            array.append(chatmsg)
        }
        self.messages = array
        self.messagesFirstLoadSubject.onNext(true)
    }
}

extension IMChatVM {
    func sendGift(_ gift: GiftModel, num: Int) {
        let _ = MLRequest.send(.sendGift(toUser: userId, giftId: gift.id, type: 1, number: num, relationId: 0), type: EmptyModel.self).subscribe(onSuccess: { _ in
            self.sendGiftMsg(gift, num: num)
            self.playGiftAnimate.onNext(gift.vfx)
        })
    }
    private func sendGiftMsg(_ gift: GiftModel, num: Int) {
        let uid = UserCenter.loginUser.user.id
        let name = UserCenter.loginUser.user.name
        let imgift = IMGift(anim_type: "1", id: gift.id.string, name: gift.name, price: gift.coin.string, src: gift.fullIcon ?? "", animationSrc: gift.vfx)
        let sendModel = GiftSendModel(cmd: "gift", forward: userId.string, fromUserId: uid.string, forName: name, number: num.string, gift: imgift)
        guard let data = try? JSONEncoder().encode(sendModel), let json = String(data: data, encoding: .utf8) else { return }
        let body = EMCustomMessageBody(event: Constants.im.giftEvent, customExt: [Constants.im.giftDataKey: json])
        let msg = EMChatMessage.init(conversationID: chatId, body: body, ext: nil)
        sendMessage(msg)
    }
    func sendText(_ text: String) {
        if text.isEmpty { return }
        let body = EMTextMessageBody.init(text: text)
        let msg = EMChatMessage.init(conversationID: chatId, body: body, ext: nil)
        sendMessage(msg)
    }
    
    func sendVoice(_ path: String, duration: Int) {
        let body = EMVoiceMessageBody.init(localPath: path, displayName: path.lastPathComponent)
        body.duration = Int32(duration)
        let msg = EMChatMessage.init(conversationID: chatId, body: body, ext: nil)
        sendMessage(msg)
    }
    
    func sendCallMsg(_ model: IMCallModel) {
        guard let data = try? JSONEncoder().encode(model), let json = String(data: data, encoding: .utf8) else { return }
        let body = EMCustomMessageBody(event: Constants.im.callEvent, customExt: ["data": json])
        let msg = EMChatMessage.init(conversationID: chatId, body: body, ext: nil)
        sendMessage(msg)
    }
    
    func sendImage(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1) else {
            return
        }
        let body = EMImageMessageBody.init(data: data, displayName: nil)
        body.size = image.size
        let msg = EMChatMessage.init(conversationID: chatId, body: body, ext: nil)
        sendMessage(msg)
    }
    
    ///发送消息
    private func sendMessage(_ msg: EMChatMessage) {
        addNewMessage(msg)
        EMClient.shared().chatManager?.send(msg, progress: nil, completion: { [weak self] _, error in
            if let error = error {
                self?.handleSendFail(msg, error: error)
            }
        })
    }
    
    ///发送失败处理
    private func handleSendFail(_ msg: EMChatMessage, error: EMError) {
        if let string = error.errorDescription {
            Toast.show(string)
        }
        
        msg.status = .failed
        messagesChangeSubject.onNext(true)
    }
    
    ///添加消息
    private func addNewMessage(_ msg: EMChatMessage) {
        let model = IMChatMsgModel()
        model.msg = msg
        
        ///大于五分钟显示时间
        if let last = messages.last {
            if msg.localTime - last.msg.localTime > 5 * 60 * 1000 {
                let timeMsg = IMChatMsgModel()
                timeMsg.isShowTime = true
                timeMsg.msg = msg
                messages.append(timeMsg)
            }
        }

        messages.append(model)
        messagesChangeSubject.onNext(true)
        
        playGiftIfNeed(msg)
    }
    
    private func playGiftIfNeed(_ msg: EMChatMessage) {
        guard msg.body.type == .custom, let custom = msg.body as? EMCustomMessageBody else { return }
        if custom.event != Constants.im.giftEvent {
            return
        }
        guard let data = custom.customExt[Constants.im.giftDataKey]?.data(using: .utf8),
              let model = try? JSONDecoder().decode(GiftSendModel.self, from: data) else { return }
        playGiftAnimate.onNext(model.gift.animationSrc)
    }
    
    
    func receivedNewMsgs(_ newMsgs: [EMChatMessage]) {
        for newMsg in newMsgs {
            if newMsg.conversationId != chatId { continue }
            addNewMessage(newMsg)
        }
    }
    
    ///播放音频
    func playSound(_ msg: IMChatMsgModel?) {
        guard let message = msg, let voiceModel = message.msg.body as? EMVoiceMessageBody else { return }
        
        if voiceModel.downloadStatus == .downloading {
            Toast.show("语音下载中...")
            return
        }
        if voiceModel.downloadStatus == .succeed {
            play(message)
            return
        }
        Toast.show("语音下载中...")
        EMClient.shared().chatManager?.downloadMessageAttachment(message.msg, progress: nil, completion: { result, error in
            if let _ = error {
                Toast.show("下载语音失败")
            }
        })
    }
    
    private func play(_ msg: IMChatMsgModel) {
        ///更新为已播放状态
        msg.msg.isListened = true
        EMClient.shared().chatManager?.update(msg.msg)
        
        guard let path = (msg.msg.body as? EMVoiceMessageBody)?.localPath else {
            Toast.show("语音文件失效")
            return
        }

        let url = URL(fileURLWithPath: path)
        ///是否正在播放
        if audioPlayer?.isPlaying ?? false {
            //停止当前正在播放的语音
            stopPlayingCurrentSound()
            ///如果当前正在播放的语音正好是用户点击的语音，则结束函数
            if audioPlayer?.url?.path == path {
                return
            }
        }
        ///播放新的语音
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            ///改变播放状态
            msg.isSoundPlaying = true
            ///记录正在播放的语音model
            playingMsg = msg
            ///消息变化通知
            messagesChangeSubject.onNext(true)
        } catch {
            Toast.show("语音文件失效")
        }
    }
    
    ///停止播放当前正在进行的语音
    func stopPlayingCurrentSound() {
        if playingMsg == nil { return }
        audioPlayer?.stop()
        playingMsg?.isSoundPlaying = false
        playingMsg = nil
        messagesChangeSubject.onNext(true)
    }
}

extension IMChatVM: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopPlayingCurrentSound()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        stopPlayingCurrentSound()
    }
}

extension IMChatVM: AgrumeDataSource {
    
    func imgUrlFor(message: IMChatMsgModel) -> URL? {
        let body = message.msg.body as? EMImageMessageBody
        if let file = body?.localPath {
            return URL(fileURLWithPath: file)
        }
        if let path = body?.remotePath, !path.isEmpty {
            return URL(string: path)
        }
        return nil
    }
    
    func prepareShowAgrume() {
        var urls = [URL]()
        for msg in messages {
            if msg.isShowTime { continue }
            if msg.msg.body.type != .image { continue }
            if let url = imgUrlFor(message: msg) {
                urls.append(url)
            }
        }
        self.imgUrls = urls
    }
    
    func getUrlIndexFor(message: IMChatMsgModel) -> Int {
        let url = imgUrlFor(message: message)
        let index = imgUrls?.firstIndex{ $0.absoluteString == url?.absoluteString }
    
        return index ?? 0
    }
    
    var numberOfImages: Int {
        imgUrls?.count ?? 0
    }
    func image(forIndex index: Int, completion: @escaping (UIImage?) -> Void) {
        guard let url = imgUrls?[index] else { return }
        KingfisherManager.shared.retrieveImage(with: url) { result in
            let image = try? result.get().image
            completion(image)
        }
    }
    
    func showAgrume(message: IMChatMsgModel, from vc: UIViewController) {
        if imgUrlFor(message: message) == nil { return }
        prepareShowAgrume()
        if imgUrls.isNilOrEmpty { return }
        let index = getUrlIndexFor(message: message)
        let agrume = Agrume(dataSource: self, startIndex: index, background: .blurred(.dark))
        agrume.onLongPress = { [weak agrume] (image: UIImage?, vc: UIViewController) in
            agrume?.sheet(Action.done("保存图片", {
                ImageSaver().save(image)
            }), Action.cancel("取消", nil))
        }
        agrume.show(from: vc)
    }
}

//
//  IMManager.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/14.
//

import Foundation
import HyphenateChat
import RxSwift
import AudioToolbox

protocol IMTokenUser {
    var imUsername: String { get }
    var imToken: String { get }
}

///IM 单例。 处理一切IM相关的逻辑
class IMManager: NSObject {
    private var INITIMSDKFLAG = 0
    private override init() { }
    static let share = IMManager()
    
    private var remindTimeStamp: TimeInterval = 0
    
    ///会话
    private(set) var conversations: [IMConversationModel] = []
    let conversationsSubjectWithAnimate = PublishSubject<Bool>()
    
    ///未读数
    let unreadMsgCountSubject = ReplaySubject<Int>.create(bufferSize: 1)
    private var unreadMsgCount: Int = 0 {
        didSet {
            if oldValue != unreadMsgCount {
                unreadMsgCountSubject.onNext(unreadMsgCount)
                updateTabBadge()
            }
        }
    }
    static func updateUnreadCount() {
        var count = 0
        for c in share.conversations {
            count += Int(c.conversation.unreadMessagesCount)
        }
        share.unreadMsgCount = count
    }
    
    private func updateTabBadge() {
        let mainVC = UIApplication.shared.currentWindow?.rootViewController as? UITabBarController
        let navc = mainVC?.viewControllers?[3]
        navc?.tabBarItem.badgeValue = unreadMsgCount.badge
    }
    
    ///收到新的消息
    static let receivedNewMsgSubject = PublishSubject<[EMChatMessage]>()
}

/// 登录
extension IMManager {
    ///token登录IM，登陆前会初始化SDK
    static func loginIMByToken(_ user: IMTokenUser) -> Single<Bool> {
        Single<Bool>.create { single in
            if share.initIMSDK() == false {
                single(.success(false))
                return Disposables.create()
            }
            
            logoutIM()
            
            EMClient.shared().login(withUsername: user.imUsername, token: user.imToken) { _, error in
                DispatchQueue.main.async {
                    if let error = error {
                        handelIMLoginFail(error)
                        single(.success(false))
                    }else {
                        handelIMLoginSuccess()
                        single(.success(true))
                    }
                }
            }

            return Disposables.create()
        }
    }
    
    ///退出登录IM
    static func logoutIM() {
        //清理数据
        share.conversations = []
        share.unreadMsgCount = 0
    
        if EMClient.shared().isLoggedIn == false { return }
        
        ///如果解绑退出失败，则调用非解绑退出
        if let _ = EMClient.shared().logout(true) {
            EMClient.shared().logout(false)
        }
    }
}

///内部方法
extension IMManager {
    
    ///im登录成功
    private static func handelIMLoginSuccess() {
        requestConversations()
    }
    ///处理IM登录失败
    private static func handelIMLoginFail(_ error: EMError) {
        ddPrint("登录IM失败:\(error.code.rawValue)-\(error.errorDescription ?? "")")
        Toast.show("登录IM失败")
    }
    
    ///sdk初始化失败
    private static func handelSDKInitFail(_ error: EMError) {
        ddPrint("初始化IMSDK失败:\(error.errorDescription ?? "")")
        Toast.show("初始化IMSDK失败")
    }
    
    ///初始化SDK，只初始化一次
    private func initIMSDK() -> Bool {
        if INITIMSDKFLAG > 0 { return true}
        INITIMSDKFLAG = 1
        
        let op = EMOptions.init(appkey: Constants.im.appKey)
        // apnsCertName是证书名称，可以先传 nil，等后期配置 APNs 推送时在传入证书名称
        op.apnsCertName = ""
        if let error = EMClient.shared().initializeSDK(with: op) {
            IMManager.handelSDKInitFail(error)
            return false
        }
        
        ///初始化成功后设置回调
        EMClient.shared().chatManager?.add(self, delegateQueue: nil)
        EMClient.shared().add(self, delegateQueue: .main)
        return true
    }
}

extension IMManager: EMClientDelegate {
    func userAccountDidLogin(fromOtherDevice aDeviceName: String?) {
        UserCenter.logout()
    }
    
    func userAccountDidForced(toLogout aError: EMError?) {
        UserCenter.logout()
    }
    
    func tokenWillExpire(_ aErrorCode: EMErrorCode) {
        let _ = MLRequest.send(.getImToken, type: String.self).subscribe(onSuccess: {
            if let token = $0 {
                var user = UserCenter.loginUser
                user.user.imToken = token
                UserCenter.updateUser(user)
                EMClient.shared().renewToken(token)
            }
        })
    }
    
    func tokenDidExpire(_ aErrorCode: EMErrorCode) {
        UserCenter.logout()
    }
}

///会话
extension IMManager {
    static func requestConversations(_ animate: Bool = false) {
        let cs = EMClient.shared().chatManager?.getAllConversations(true)
        
        ///遍历垃圾环信的会话列表，如果已经获取了用户信息，则设置进去，否则去请求用户信息
        var arry = [IMConversationModel]()
        for c in cs ?? [] {
            let model = IMConversationModel(conversation: c)
            if let result = share.conversations.first(where: { $0.conversation.conversationId == c.conversationId }) {
                model.user = result.user
                model.avatarColor = result.avatarColor
            }
            let converid = model.conversation.conversationId
            if converid == "im100001"{
                
            }else{
                arry.append(model)
            }
            
        }
        share.conversations = arry
        share.conversationsSubjectWithAnimate.onNext(animate)
        
        ///请求用户信息
        share.getUserInfoIfNeed()
        
        ///更新未读数
        updateUnreadCount()
    }
    
    ///获取用户信息，垃圾环信，会话列表不包含用户信息，需要单独获取
    private func getUserInfoIfNeed() {
        ///过滤已经包含用户信息的数据
        let ids = conversations.filter({ $0.user == nil && $0.conversation.conversationId != nil }).map({ $0.conversation.conversationId! })
        if ids.isEmpty { return }
        EMClient.shared().userInfoManager?.fetchUserInfo(byId: ids, completion: { result, error in
            if let result = result {
                for (key, user) in result {
                    if let model = self.conversations.first(where: { $0.conversation.conversationId == key }) {
                        model.user = user
                    }
                }
                //获取用户信息结束之后发送通知
                DispatchQueue.main.async {
                    self.conversationsSubjectWithAnimate.onNext(false)
                }
            }
        })
    }
    
    ///置顶/取消置顶
    static func pin(conversation: EMConversation, onSuccess: @escaping VoidBlock) {
        guard let id = conversation.conversationId else { return }
        let isPinned = !conversation.isPinned
        EMClient.shared().chatManager?.pinConversation(id, isPinned: isPinned, completionBlock: { error in
            DispatchQueue.main.async {
                if let error = error {
                    Toast.show(error.errorDescription ?? "fail")
                }else {
                    IMManager.requestConversations(true)
                    onSuccess()
                }
            }
        })
    }
    
    ///删除所有会话
    static func deleteAllConversations() {
        let cs = share.conversations.map({ $0.conversation })
        if cs.isEmpty { return }
        EMClient.shared().chatManager?.delete(cs, isDeleteMessages: true, completion: nil)
        share.conversationsSubjectWithAnimate.onNext(true)
        updateUnreadCount()
    }
    
    ///删除会话
    static func delete(conversation: EMConversation, onSuccess: @escaping VoidBlock) {
        guard let id = conversation.conversationId else { return }
        EMClient.shared().chatManager?.deleteConversation(id, isDeleteMessages: true, completion: { _, error in
            DispatchQueue.main.async {
                if let error = error {
                    Toast.show(error.errorDescription ?? "fail")
                }else {
                    IMManager.requestConversations(true)
                    onSuccess()
                }
            }
        })
    }
    
    ///全部已读
    static func markReadedAll() {
        share.conversations.forEach({
            $0.conversation.markAllMessages(asRead: nil)
        })
        updateUnreadCount()
    }
    
    ///单条会话已读
    static func markReaded(conversation: EMConversation?) {
        guard let conversation = conversation else {
            return
        }
        conversation.markAllMessages(asRead: nil)
        updateUnreadCount()
    }
}

extension IMManager: EMChatManagerDelegate {
    func conversationListDidUpdate(_ aConversationList: [EMConversation]) {
        IMManager.requestConversations()
    }
    
    func messagesDidReceive(_ aMessages: [EMChatMessage]) {
        
        if aMessages.isEmpty { return }
        
        IMManager.requestConversations()
        IMManager.receivedNewMsgSubject.onNext(aMessages)
        
        if let last = aMessages.last {
            ringAndPop(message: last)
        }
    }
    
    ///播放声音和弹窗
    private func ringAndPop(message: EMChatMessage) {
        ///正在通话中，则不弹窗
        if RTCManager.share.isCalling {
            return
        }
        
        let mainVC = UIApplication.shared.currentWindow?.rootViewController as? UITabBarController
        let topVC = (mainVC?.selectedViewController as? UINavigationController)?.topViewController
        let chatVC = topVC as? IMChatVC
        let currentChatId = chatVC?.viewModel.chatId
        ///如果是当前聊天页面，则不弹窗
        if message.conversationId == currentChatId {
            return
        }
        
        if message.from == "im\(UserCenter.loginUser.user.id)"{
            return
        }
        
        // 响铃间隔3秒钟
        if Date().timeIntervalSince1970 - remindTimeStamp >= 3 {
            // 新消息铃声
            var theSoundID : SystemSoundID = 0
            let url = URL(fileURLWithPath: "/System/Library/Audio/UISounds/nano/sms-received1.caf")
            let urlRef = url as CFURL
            let err = AudioServicesCreateSystemSoundID(urlRef, &theSoundID)
            
            if err == kAudioServicesNoError {
                AudioServicesPlaySystemSoundWithCompletion(theSoundID, {
                    AudioServicesDisposeSystemSoundID(theSoundID)
                })
            }
            remindTimeStamp = NSDate().timeIntervalSince1970
        }
        
        // 弹窗
        guard let view = topVC?.view else { return }
        let old = view.viewWithTag(Constants.tag.imPop) as? IMPopView
        old?.hideAnimate()
        
        let pop = IMPopView(message: message)
        pop.tag = Constants.tag.imPop
        pop.showAnimate(inView: view)
    }
}

extension IMManager {
    static func sendGift(_ gift: GiftModel, number: Int, to userId: Int) {
        let _ = MLRequest.send(.sendGift(toUser: userId, giftId: gift.id, type: 3, number: number, relationId: 0), type: EmptyModel.self).subscribe(onSuccess: { _ in
            self.sendGiftMsg(gift, num: number, to: userId)
            self.playGift(gift)
        })
    }
    
    private static func sendGiftMsg(_ gift: GiftModel, num: Int, to userId: Int) {
        let uid = UserCenter.loginUser.user.id
        let name = UserCenter.loginUser.user.name
        let imgift = IMGift(anim_type: "1", id: gift.id.string, name: gift.name, price: gift.coin.string, src: gift.fullIcon ?? "", animationSrc: gift.vfx)
        let sendModel = GiftSendModel(cmd: "gift", forward: userId.string, fromUserId: uid.string, forName: name, number: num.string, gift: imgift)
        guard let data = try? JSONEncoder().encode(sendModel), let json = String(data: data, encoding: .utf8) else { return }
        let body = EMCustomMessageBody(event: Constants.im.giftEvent, customExt: [Constants.im.giftDataKey: json])
        let msg = EMChatMessage.init(conversationID: "im\(userId)", body: body, ext: nil)
        EMClient.shared().chatManager?.send(msg, progress: nil, completion: nil)
    }
    
    private static func playGift(_ gift:  GiftModel) {
        let mainVC = UIApplication.shared.currentWindow?.rootViewController as? UITabBarController
        let navc = mainVC?.selectedViewController as? UINavigationController
        guard let topVC = navc?.topViewController else { return }
        GiftAnimatePlayer.play(path: gift.vfx, inView: topVC.view)
    }
}

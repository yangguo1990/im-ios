//
//  RTCManager.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/31.
//

import UIKit
import CallAPI
import AgoraRtcKit
import AgoraRtmKit
import RxSwift
import HyphenateChat
//import FURenderKit

enum IMCallState: Int, Codable {
    case hangup = 0
    case timeout = 1
    case cancel = 2
    case reject = 3
}

struct IMCallModel: Codable {
    let time: Int
    let state: IMCallState
    
    var imString: String {
        if state == .hangup {
            let ntime = time/1000
            let m = ntime / 60
            let s = ntime % 60
            if m > 0 {
                return "视频聊天 \(m)分\(s)秒"
            }else {
                return "视频聊天 \(s)秒"
            }
        }else if state == .cancel {
            return "视频聊天 取消"
        }else if state == .reject {
            return "视频聊天 拒绝"
        }else if state == .timeout {
            return "视频聊天 未应答"
        }else {
            return "视频聊天"
        }
    }
}

class RTCManager: NSObject {
    private var uid: Int!
    private var api: CallApiImpl!
    private override init() { }
    static let share = RTCManager()
    var startTime :Int!
    var endTime:Int!
    var fromUserId:UInt!
    var toUserId:UInt!
    var isCalling: Bool = false
    ///连接成功，通话中
    static let connectedSubject = PublishSubject<Bool>()
    ///结束呼叫
    static let endCallSubject = PublishSubject<Bool>()
    
    private var rtcToken: String = ""
    private var rtmToken: String = ""
    private(set) var remoteUser: PreCallUserInfo!
    private(set) var chatViewModel: IMChatVM!
    private(set) var currentRoomId: String = Constants.rtc.defaultRoomId {
        didSet {
            rtcEngineKit.removeDelegateEx(self, connection: .init(channelId: oldValue, localUid: uid))
            rtcEngineKit.addDelegateEx(self, connection: .init(channelId: currentRoomId, localUid: uid))
        }
    }
    ///是否为主叫
    private(set) var isMainCall: Bool!
    
    private let userKey = "user"
    
    private(set) var isOpenMic = true
    static let micSubject = PublishSubject<Bool>()
    private(set) var isOpenCamera = true
    static let cameraSubject = PublishSubject<Bool>()
    private(set) var isFrontCamera = true
    
    lazy var rtcEngineKit: AgoraRtcEngineKit = {
        let config = AgoraRtcEngineConfig()
        config.appId = Constants.rtc.appId
        config.channelProfile = .communication
        config.audioScenario = .gameStreaming
        config.areaCode = .global
        let engine = AgoraRtcEngineKit.sharedEngine(with: config, delegate: nil)
        engine.setClientRole(.broadcaster)
        engine.setVideoFrameDelegate(self)
        return engine
    }()
    
    static let localViewW: CGFloat = 108
    static let localViewH: CGFloat = 160
    lazy var localView: UIView = {
        let view = UIView(frame: .init(x: 0, y: 0, width: RTCManager.localViewW, height: RTCManager.localViewH))
        return view
    }()
    
    lazy var remoteView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        return view
    }()
}

extension RTCManager {
    private func resetRtc(roomId: String) {
        if isOpenMic == false {
            isOpenMic = true
            rtcEngineKit.muteLocalAudioStreamEx(false, connection: .init(channelId: roomId, localUid: uid))
        }
        if isOpenCamera == false {
            isOpenCamera = true
            rtcEngineKit.muteLocalVideoStreamEx(false, connection: .init(channelId: roomId, localUid: uid))
        }
        localView.isHidden = false
        remoteView.isHidden = false
    }
    ///初始化
    static func initRTC(user: UserModel) -> Single<Bool> {
        share.uid = user.user.id
        let config = CallConfig()
        config.appId = Constants.rtc.appId
        config.userId = UInt(user.user.id)
        config.rtcEngine = share.rtcEngineKit
        config.rtmClient = nil
        let api = CallApiImpl()
        api.initialize(config: config)
        api.addListener(listener: share)
        
        share.api = api
        
        return Single<Bool>.create { single in
            RTCManager.requestCallToken(success: {
                RTCManager.prepare(roomId: Constants.rtc.defaultRoomId) {
                    if let error = $0 {
                        ddPrint("RTC prepare 失败:\(error.localizedDescription)")
                        Toast.show("登录RTC失败")
                        single(.success(false))
                    }else {
                        single(.success(true))
                    }
                }
            }, failure: {
                Toast.show("登录RTC失败")
                single(.success(false))
            })

            return Disposables.create()
        }
    }
    
    private static func prepare(roomId: String, completion: ((NSError?) -> ())?) {
        let prepareConfig = PrepareConfig()
        prepareConfig.rtcToken = share.rtcToken
        prepareConfig.rtmToken = share.rtmToken
        prepareConfig.roomId = roomId
        prepareConfig.localView = share.localView
        prepareConfig.remoteView = share.remoteView
        prepareConfig.autoJoinRTC = false
        if let user = UserCenter.share.userModel?.userDetail {
            let preUser = PreCallUserInfo(standard: 0, otherInfo: user.user)
            if let data = try? JSONEncoder().encode(preUser), let json = String(data: data, encoding: .utf8) {
                prepareConfig.userExtension = [RTCManager.share.userKey: json]
            }
        }
        share.api.prepareForCall(prepareConfig: prepareConfig, completion: completion)
    }
    
    static func deinitRTC() {
        share.chatViewModel = nil
        share.remoteUser = nil
        share.api.deinitialize(completion: {})
    }
    
    ///发起呼叫
    @objc static func call(_ userId: Int) {
        /// 呼叫需要把自身数据传递给对方,如果数据为空,则去刷新用户详情,并且函数直接返回
        if UserCenter.share.userModel?.userDetail == nil {
            UserCenter.updateUserInfo()
            return
        }
        let _ = MLRequest.send(.preCall(userId: userId), type: PreCallUserInfo.self, showErrorToast: false).subscribe(onSuccess: {
            if let user = $0 {
                RTCManager.share.remoteUser = user
                RTCManager.startCall(user)
            }else {
                Toast.show("获取用户信息失败")
            }
        }, onFailure: {
            if case let MLError.service(msg, code) = $0 {
                if code == 106 {
                    ///余额不足，请充值
                    RTCManager.share.showTopupAlert()
                }else {
                    Toast.show(msg ?? "呼叫失败")
                }
            }else {
                Toast.show("呼叫失败")
            }
        })
        
    }
    private static func startCall(_ user: PreCallUserInfo) {
        let roomId = "\(share.uid ?? 0)\(Date().timeIntervalSince1970.int)".md5()
        RTCManager.prepare(roomId: roomId) {
            if let error = $0 {
                Toast.show(error.localizedDescription)
                let _ = RTCManager.initRTC(user: UserCenter.loginUser).subscribe(onSuccess: { _ in})
            }else {
                RTCManager.share.api.call(remoteUserId: UInt(user.otherInfo.userId)) { error in
                    if let _ = error {
                        RTCManager.cancelCall()
                    }else {

                    }
                }
            }
        }
    }
    
    ///取消呼叫
    static func cancelCall() {
        share.api.cancelCall(completion: nil)
    }
    
    ///拒绝呼叫
    static func rejectCall(_ userId: Int) {
        share.api.reject(remoteUserId: UInt(userId), reason: nil, completion: nil)
    }
    
    ///接受呼叫
    static func acceptCall(_ userId: Int) {
        share.api.accept(remoteUserId: UInt(userId), completion: nil)
    }
    
    ///挂断通话
    static func hangupCall(_ userId: Int) {
        share.api.hangup(remoteUserId: UInt(userId), reason: nil, completion: nil)
    }
    
    ///更新token
    static func updateCallToken() {
        requestCallToken(success: {
            RTCManager.share.api.renewToken(with: RTCManager.share.rtcToken, rtmToken: RTCManager.share.rtmToken)
        })
    }
    
    private static func requestCallToken(success: @escaping VoidBlock, failure: VoidBlock? = nil) {
        let _ = Observable.zip(
            MLRequest.send(.getRtcToken(cName: Constants.rtc.defaultRoomId), type: String.self).asObservable(),
            MLRequest.send(.getRtmToken, type: String.self).asObservable()
        ).subscribe(onNext: { result in
            if let rtc = result.0, let rtm = result.1 {
                RTCManager.share.rtcToken = rtc
                RTCManager.share.rtmToken = rtm
                success()
            }else {
                ddPrint("获取rtc token失败")
                failure?()
            }
            
        }, onError: { _ in
            failure?()
        })
    }
}

extension RTCManager: CallApiListenerProtocol {
    func dictoJsonStr(dictionary:[String:Any]) -> String?{
            do {
                    let jsonData = try JSONSerialization.data(withJSONObject: dictionary)
                    let jsonstr = String(data: jsonData, encoding: .utf8)
                return jsonstr
                }catch let error{
                    print("error converting to json:\(error)")
                    return nil
                }
        
    }
    
    func sendCustomMsgtoIM(jsonDictionary:[String:Any]){
        var json:String? = dictoJsonStr(dictionary: jsonDictionary)
        print("上报内容是:\(jsonDictionary)")
        let body = EMCustomMessageBody(event: "RTC_STATE", customExt: ["userCall":json!])
        let msg = EMChatMessage.init(conversationID:"im100001",body: body, ext: nil)
        EMClient.shared().chatManager?.send(msg, progress: nil, completion:{ [weak self] _, error in
            if let error = error {
                print(error.description)
            }
        })
    }
    
    func onCallEventChanged(with event: CallEvent, eventReason: String?) {
        let state:UInt = event.rawValue
        if (state == 109)||(state==3)||(state==100)||(state==117){
            var jsonDic:[String:Any] = ["state":state,"userId":String(RTCManager.share.fromUserId),"remoteId":RTCManager.share.toUserId ?? 0,"roomId":currentRoomId,"startTime":0,"endTime": 0,"videoTime":0]
            sendCustomMsgtoIM(jsonDictionary: jsonDic)
        }
    }
    
    
    
    func onCallStateChanged(with state: CallStateType, stateReason: CallStateReason, eventReason: String, eventInfo: [String : Any]) {
        ddPrint("CallAPI状态改变：\(state.desc)")
        
        let fromId = (eventInfo[kFromUserId] as? UInt) ?? 0
        let toId = (eventInfo[kRemoteUserId] as? UInt) ?? 0
        if state == .calling {
            RTCManager.share.fromUserId = fromId
            RTCManager.share.toUserId = toId
            let roomId = eventInfo[kFromRoomId] as! String
            resetRtc(roomId: roomId)
            isCalling = true
            let isMyself = fromId == uid
            if isMyself  {
                ///发起呼叫
                isMainCall = true
                showRTCCall(Int(toId), type: .send)
            }else {
                ///收到呼叫
                let dic = eventInfo[kFromUserExtension] as? [String: Any]
                let userJson = dic?[userKey] as? String
                if let data = userJson?.data(using: .utf8) {
                    if let user = try? JSONDecoder().decode(PreCallUserInfo.self, from: data) {
                        remoteUser = user
                        isMainCall = false
                        showRTCCall(Int(fromId), type: .receive)
                    }
                }
            }
        }else if state == .prepared {
            isCalling = false
            ///发送通话记录 im消息
            if stateReason == .callingTimeout {
                let msg = IMCallModel(time: 0, state: .timeout)
                chatViewModel.sendCallMsg(msg)
            }else if stateReason == .remoteRejected {
                let msg = IMCallModel(time: 0, state: .reject)
                chatViewModel.sendCallMsg(msg)
            }else if stateReason == .localCancel {
                let msg = IMCallModel(time: 0, state: .cancel)
                chatViewModel.sendCallMsg(msg)
            }
            ///展示理由
            if stateReason != .none {
                Toast.show(stateReason.desc)
            }
            ///结束通话信号
            DispatchQueue.main.async {
                RTCManager.endCallSubject.onNext(true)
            }
        }else if state == .failed {
            isCalling = false
            ///错误
            if let user = UserCenter.share.userModel {
                let _ = RTCManager.initRTC(user: user).subscribe(onSuccess: { _ in})
            }
        }else if state == .connected{
            var jsonDic:[String:Any] = ["state":4,"userId":String(RTCManager.share.fromUserId),"remoteId":RTCManager.share.toUserId ?? 0,"roomId":currentRoomId,"startTime":RTCManager.share.startTime ?? 0,"endTime": 0,"videoTime":0]
            sendCustomMsgtoIM(jsonDictionary: jsonDic)
           
        }else{
            isCalling = false
        }
    }
    
    func onCallError(with errorEvent: CallErrorEvent, errorType: CallErrorCodeType, errorCode: Int, message: String?) {
        ddPrint("CallAPI错误信息: \(message ?? "")")
        if errorCode == -11033 {
            Toast.show("用户暂不在线")
        }else if errorCode == -11026 {
            Toast.show("消息发布超时，用户暂不在线")
        }else {
            if let message = message {
                Toast.show(message)
            }
        }
    }
    
    func tokenPrivilegeWillExpire() {
        RTCManager.updateCallToken()
    }
    
    func onCallConnected(roomId: String, callUserId: UInt, currentUserId: UInt, timestamp: UInt64) {
        currentRoomId = roomId
        ///通话中
        RTCManager.share.startTime = Int(Date().timeIntervalSince1970)*1000
        RTCManager.connectedSubject.onNext(true)
        
    }
    
    func onCallDisconnected(roomId: String, hangupUserId: UInt, currentUserId: UInt, timestamp: UInt64, duration: UInt64) {
        if isMainCall {
//            let time = duration / 1000
            let msg = IMCallModel(time: Int(duration), state: .hangup)
            chatViewModel.sendCallMsg(msg)
        }
        MLRequest.send(.stopCall(cName: roomId))
        RTCManager.share.endTime = Int(Date().timeIntervalSince1970)*1000
        var jsonDic:[String:Any] = ["state":177,"userId":String(RTCManager.share.fromUserId),"remoteId":RTCManager.share.toUserId ?? 0,"roomId":currentRoomId,"startTime":RTCManager.share.startTime ?? 0,"endTime":RTCManager.share.endTime ?? 0,"videoTime":duration/1000]
        sendCustomMsgtoIM(jsonDictionary: jsonDic)
        
    }
}

extension RTCManager {
    static func switchMic() {
        let con = AgoraRtcConnection.init(channelId: share.currentRoomId, localUid: share.uid)
        share.rtcEngineKit.muteLocalAudioStreamEx(share.isOpenMic, connection: con)
    }
    
    static func switchCamera() {
        let con = AgoraRtcConnection.init(channelId: share.currentRoomId, localUid: share.uid)
        share.rtcEngineKit.muteLocalVideoStreamEx(share.isOpenCamera, connection: con)
    }
    
    static func changeCameraFront() {
        share.isFrontCamera = !share.isFrontCamera
        share.rtcEngineKit.switchCamera()
    }
}

extension RTCManager {
    private func currentNavc() -> UINavigationController? {
        let mainVC = UIApplication.shared.currentWindow?.rootViewController as? UITabBarController
        let navc = mainVC?.selectedViewController as? UINavigationController
        return navc
    }
    private func showRTCCall(_ userId: Int, type: RTCOperateType) {
        guard let navc = currentNavc() else { return }
        
        navc.view.endEditing(true)
        
        let chatId = "im\(userId)"
        var vm = IMChatVM(chatId: chatId, isLoadHistory: false)
        
        let chatVc = navc.viewControllers.first(where: { $0.isKind(of: IMChatVC.self) }) as? IMChatVC
        if let chatVM = chatVc?.viewModel, chatVM.chatId == chatId {
            vm = chatVM
        }
        chatViewModel = vm
        let vc = RTCCallController(userId: userId, type: type)
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            navc.present(vc, animated: true)
        }
    }
    
    private func showTopupAlert() {
        guard let navc = currentNavc() else { return }
        navc.alert(title: "充值", message: "金币不足，前往充值", .cancel("取消", nil), .done("确认", { [weak self] in
            self?.pushToTopup()
        }))
    }
    private func pushToTopup() {
        currentNavc()?.modalToTopupController()
    }
}

extension RTCManager: AgoraRtcEngineDelegate {
    ///本地麦克风状态变化
    func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioPublishStateChange channelId: String, oldState: AgoraStreamPublishState, newState: AgoraStreamPublishState, elapseSinceLastState: Int32) {
        if newState == .publishing || newState == .published {
            isOpenMic = true
        }else {
            isOpenMic = false
        }
        RTCManager.micSubject.onNext(true)
    }
    
    ///本地摄像头状态变化
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoPublishStateChange channelId: String, sourceType: AgoraVideoSourceType, oldState: AgoraStreamPublishState, newState: AgoraStreamPublishState, elapseSinceLastState: Int32) {
        if newState == .publishing || newState == .published {
            isOpenCamera = true
        }else {
            isOpenCamera = false
        }
        RTCManager.cameraSubject.onNext(true)
    }
    
    ///远端摄像头状态变化
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStateChangedOfUid uid: UInt, state: AgoraVideoRemoteState, reason: AgoraVideoRemoteReason, elapsed: Int) {
        if state == .stopped {
            remoteView.isHidden = true
            Toast.show("对方关闭摄像头")
        }else {
            remoteView.isHidden = false
            Toast.show("对方开启摄像头")
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteAudioStateChangedOfUid uid: UInt, state: AgoraAudioRemoteState, reason: AgoraAudioRemoteReason, elapsed: Int) {
        if state == .stopped {
            remoteView.isHidden = true
            Toast.show("对方关闭麦克风")
        }else {
            remoteView.isHidden = false
            Toast.show("对方开启麦克风")
        }
    }
    
   

}


extension RTCManager: AgoraVideoFrameDelegate {
    func onCapture(_ videoFrame: AgoraOutputVideoFrame, sourceType: AgoraVideoSourceType) -> Bool {
//        let input = FURenderInput()
//        input.pixelBuffer = videoFrame.pixelBuffer
//        input.renderConfig.isFromFrontCamera = isFrontCamera ? true : false
//        input.renderConfig.isFromMirroredCamera = isFrontCamera ? true : false
//        let output = FURenderKit.share().render(with: input)
//        videoFrame.pixelBuffer = output.pixelBuffer
        fuSetDefaultRotationMode(3)
        let fu = FUManager.share()
        fu?.renderItems(to: videoFrame.pixelBuffer)
        return true
    }
}


extension CallStateType {
    var desc: String {
        switch self {
        case .idle:
            return "未知"
        case .prepared:
            return "空闲"
        case .calling:
            return "呼叫中"
        case .connecting:
            return "连接中"
        case .connected:
            return "通话中"
        case .failed:
            return "出现错误"
        }
    }
}
extension CallStateReason {
    var desc: String {
        switch self {
        case .none:
            return ""
        case .joinRTCFailed:
            return "加入RTC失败"
        case .rtmSetupFailed:
            return "设置RTM失败"
        case .rtmSetupSuccessed:
            return "设置RTM成功"
        case .messageFailed:
            return "消息发送失败"
        case .localRejected:
            return "拒绝呼叫"
        case .remoteRejected:
            return "对方已拒绝"
        case .remoteAccepted:
            return "对方已接听"
        case .localAccepted:
            return "接听呼叫"
        case .localHangup:
            return "挂断通话"
        case .remoteHangup:
            return "对方已挂断"
        case .localCancel:
            return "取消呼叫"
        case .remoteCancel:
            return "对方已取消"
        case .recvRemoteFirstFrame:
            return "收到远端首帧"
        case .callingTimeout:
            return "呼叫超时"
        case .cancelByCallerRecall:
            return "同样的主叫呼叫不同频道导致取消"
        case .rtmLost:
            return "rtm超时断连"
        case .remoteCallBusy:
            return "用户忙"
        }
    }
}


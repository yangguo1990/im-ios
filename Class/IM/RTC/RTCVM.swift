//
//  RTCVM.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/31.
//

import Foundation
import RxSwift

enum RTCOperateType {
    case send //发起呼叫
    case receive //收到呼叫
}

class RTCVM: BaseVM {
    let userId: Int
    let operateType: RTCOperateType
    private(set) var isInCall = false
    private(set) var duration: Int = 0
    
    let callStateChanged = PublishSubject<Bool>()
    let durationChanged = PublishSubject<Bool>()
    
    let topupAlert = PublishSubject<String>()
    
    init(userId: Int, type: RTCOperateType) {
        self.userId = userId
        self.operateType = type
    }
    deinit {
        stopTimer()
    }
    
    ///通话中
    func callConnected() {
        isInCall = true
        callStateChanged.onNext(true)
        startTimer()
    }
    
    
    private var timer: Timer?
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            self?.timerAction()
        })
    }
    
    private func timerAction() {
        durationChanged.onNext(true)
        ///每分钟调用一次
        if duration % 60 == 0 {
            let _ = MLRequest.send(.inCall(cName: RTCManager.share.currentRoomId, toUserId: userId), type: CallTipInfo.self).subscribe(onSuccess: {
                self.topupAlert($0)
            })
        }
        duration += 1
    }
    private func topupAlert(_ tip: CallTipInfo?) {
        guard let tip = tip, tip.mind != 0 else {
            return
        }
        
        let mainVC = UIApplication.shared.currentWindow?.rootViewController as? UITabBarController
        let navc = mainVC?.selectedViewController as? UINavigationController
        
        let alertcontroller = UIAlertController(title: "余额不足",message: "预计当前金额可通话剩余不足\(tip.rest)分钟，是否去充值",preferredStyle: .alert)
        let action = UIAlertAction(title: "取消", style: .cancel)
        
        let sureAction = UIAlertAction(title: "充值", style: .default) { _ in
            
            let chong = ML_ChongVC()
            navc?.present(chong, animated: true)
        }
        alertcontroller.addAction(action)
        alertcontroller.addAction(sureAction)
        
        navc?.present(alertcontroller, animated: true)

//        topupAlert.onNext("预计当前金额可通话剩余不足\(tip.rest)分钟，是否去充值？")
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

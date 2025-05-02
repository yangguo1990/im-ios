//
//  Toast.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/22.
//

import UIKit
import Toast_Swift
import RxSwift

class Toast {
    private static var didSetting = false
    private static func customSetting() {
        if didSetting { return }
        didSetting = true
        ToastManager.shared.position = .center
    }
    
    static var window: UIWindow? {
        UIApplication.shared.currentWindow
    }
    
    static func show(_ message: String) {
        customSetting()
        window?.makeToast(message)
    }
    
    static let delayInSeconds: Double = 20.0

    static var workItem: DispatchWorkItem?
    
    private static func performDelayedWork() {
        workItem?.cancel()
        workItem = DispatchWorkItem {
            self.clearHUD()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds, execute: workItem!)
    }
    
    private static var hudCount = 0
    static func showHUD() {
        customSetting()
        if hudCount == 0 {
            window?.makeToastActivity(.center)
            performDelayedWork()
        }
        hudCount += 1
    }
    
    static func hideHUD() {
        hudCount -= 1
        if hudCount == 0 {
            window?.hideToastActivity()
        }
    }
    
    private static func clearHUD() {
        hudCount = 0
        window?.hideToastActivity()
    }
}

//
//  GlobalSignal.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/15.
//

import UIKit
import RxSwift

struct GlobalSignal {
    ///推送通知权限发生变化
    static let noticePermissionChanged = PublishSubject<Bool>()
}

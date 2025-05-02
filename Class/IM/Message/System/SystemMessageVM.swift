//
//  SystemMessageVM.swift
//  MeiLiao
//
//  Created by Kun Xun on 2024/2/29.
//

import Foundation
import RxSwift

class SystemMessageVM: BaseListVM<MLListMessages<SystemMessageModel>> {
    override var emptyTopOffset: CGFloat { -50 }
    override var api: Single<MLListMessages<SystemMessageModel>?> {
        let p = ["page": page, "limit": size]
        return MLRequest.send(.systemMsg(info: p), type: MLListMessages<SystemMessageModel>.self)
    }
}

//
//  MLPlugin.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/23.
//

import Foundation
import Moya

struct MLRequestPlugin: PluginType {
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var mRequest = request
        mRequest.timeoutInterval = 15
        return mRequest
    }
    
    func willSend(_ request: RequestType, target: TargetType) {
        if let api = target as? MLHUDType {
            if api.isHUD {
                DispatchQueue.main.async {
                    Toast.showHUD()
                }
            }
        }
    }
        
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        if let api = target as? MLHUDType {
            if api.isHUD {
                DispatchQueue.main.async {
                    Toast.hideHUD()
                }
            }
        }
    }
}

protocol MLHUDType {
    var isHUD: Bool { get }
}

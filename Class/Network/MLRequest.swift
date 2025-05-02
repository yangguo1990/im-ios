//
//  MLRequest.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/23.
//

import UIKit
import Moya
import RxSwift
import CryptoKit

final class MLRequest {
    private init() {
        let requestPlugin = MLRequestPlugin.init()
        let logPlugin = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        let plugins: [PluginType] = [requestPlugin, logPlugin]
        provider = .init(plugins: plugins)
    }
    
    static let share = MLRequest()
    var provider: MoyaProvider<MLApi>
    
    ///不关心请求结果，可以调用这个简易方法
    static func send(_ target: MLApi) {
        let _ = send(target, type: EmptyModel.self).subscribe(onSuccess: { _ in})
    }
    ///网络请求
    ///target：Api
    ///type：接收数据的model
    ///showErrorToast：是否toast错误信息，默认yes
    ///disableView：网络请求过程中禁用的view，请求结束会自动恢复
    static func send<T: Codable>(_ target: MLApi, type: T.Type, showErrorToast: Bool = true, disableView: UIView? = nil) -> Single<T?> {
        Single.create { [weak disableView] single in
            disableView?.startRequest()
            let cancellable = share.provider.request(target) { result in
                switch result {
                case let .success(response):
                    if response.statusCode != 200 {
                        disableView?.stopRequest()
                        return single(.failure(MLError.service(msg: nil, code: -1)))
                    }
                    do {
                        let decoder = JSONDecoder()
                        let responseData = try decoder.decode(MLData.self, from: response.data)
                        let dataString = responseData.data?.aesDecrypt()
                        ddPrint("接口响应数据：\(dataString ?? "")")
                        guard let data = dataString?.data(using: .utf8) else {
                            disableView?.stopRequest()
                            return single(.failure(MLError.service(msg: nil, code: -1)))
                        }
                        
                        /***********/
//                       
//                        if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                                    print(jsonDict)  // 输出转换后的字典
//                        } else {
//                                    print("数据无法转换为字典")
//                        }
//                          

                        
                        
                        /**********/
                        
                        let responseModel = try decoder.decode(MLResponse<T>.self, from: data)
                        if responseModel.code == 0 {
                            disableView?.stopRequest()
                            return single(.success(responseModel.data))
                        }else {
                            if responseModel.isTokenError {
                                UserCenter.logout()
                                return
                            }
                            
                            if showErrorToast, let errorMsg = responseModel.msg  {
                                Toast.show(errorMsg)
                            }
                            disableView?.stopRequest()
                            single(.failure(MLError.service(msg: responseModel.msg, code: responseModel.code)))
                        }
                    } catch {
                        ddPrint(error)
                        if showErrorToast {
                            Toast.show(error.localizedDescription)
                        }
                        disableView?.stopRequest()
                        single(.failure(MLError.error(error)))
                    }
                case let .failure(error):
                    ddPrint(error)
                    if showErrorToast {
                        Toast.show(error.localizedDescription)
                    }
                    disableView?.stopRequest()
                    single(.failure(MLError.error(error)))
                }
            }
            
            return Disposables.create {
                cancellable.cancel()
            }
        }
    }
}

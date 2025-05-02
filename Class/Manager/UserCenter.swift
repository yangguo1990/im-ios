//
//  UserCenter.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/21.
//

import UIKit
import RxSwift
import RxCocoa
import SwifterSwift

@objcMembers
public class UserCenter: NSObject {
     public static let share = UserCenter()
    
    ///临时token, 用于在已经调用登录接口但是未完成登录状态(因为只有在RTC和IM都登录完成之后才完成登录状态)
    static var tempToken = ""

    ///只能在登录状态访问这个属性，因为使用了强制解包
    static var loginUser: UserModel {
        UserCenter.share.userModel!
    }
    
    ///用户信息变化信号，需要的地方可订阅
    static let userSubject = ReplaySubject<UserModel>.create(bufferSize: 1)
    //用户属性发生变化，更新归档，只读属性，需要更新用户信息，调用updateUser方法
    private(set) var userModel: UserModel? {
        didSet {
            archiveUser()
        }
    }
    //是否登录
    static var isLogin: Bool {
        share.userModel != nil
    }
    ///解挡
    private override init() {
        userModel = UserDefaults.standard.object(UserModel.self, with: Constants.userDefualt.user)
    }
    ///归档
    private func archiveUser() {
        UserDefaults.standard.set(object: userModel, forKey: Constants.userDefualt.user)
    }
    
    static func updateUser(_ user: UserModel) {
        share.userModel = user
        userSubject.onNext(user)
    }
    
    ///私有方法
    private static func loginSuccess(_ user: UserModel) {
        let center = UserCenter.share
        center.userModel = user
        loginRequirement()
        
        NotificationCenter.default.post(name: Constants.notify.login, object: nil)
    }
    
    ///登录
     static func login(_ user: UserModel, completion: @escaping BoolBlock) {
        ///记录临时token
        tempToken = user.user.token
        ///RTC和IM登录
        let _ = Observable.zip(
            IMManager.loginIMByToken(user).asObservable(),
            RTCManager.initRTC(user: user).asObservable()
        ).subscribe(onNext: { result in
            if result.0 == true && result.1 == true {
                UserCenter.loginSuccess(user)
                
                completion(true)
            }else {
                completion(false)
            }
        }, onError: { _ in
            completion(false)
        })
    }
    
    ///这个方法是给oc特别定制的，data传接口返回的data字段
 public  static func loginByOC(_ dataString: String, completion: @escaping (Bool) -> Void) {
        guard let data = dataString.data(using: .utf8) else {
            completion(false)
            return
        }
        let user = try? JSONDecoder().decode(UserModel.self, from: data)
        guard let user = user else {
            completion(false)
            return
        }
        login(user, completion: completion)
    }
    public static func loginAlready(completion: @escaping (Bool) -> Void){
        guard let user = share.userModel else {
            completion(false)
            return
        }
        login(user, completion: completion)
    }
    ///退出登录
    public static func logout() {
        let center = UserCenter.share
        center.userModel = nil
        IMManager.logoutIM()
        RTCManager.deinitRTC()
        NotificationCenter.default.post(name: Constants.notify.logout, object: nil)
        ///todo... 调用OC那边的退出登录
        AppDelegate.share().doLogout()
    }
    
    /// 更新用户详情
  public  static func updateUserInfo() {
        if !isLogin { return }
        let _ = MLRequest.send(.myselfInfo, type: UserDetailInfo.self).subscribe(onSuccess: {
            if let userDetail = $0 {
                UserCenter.share.userModel?.userDetail = userDetail
                UserCenter.userSubject.onNext(UserCenter.loginUser)
            }
        })
    }
    
    var giftInfo: GiftListModel?
    static let giftInfoSubject = PublishSubject<Bool>()
    static func getGifts() {
        if !isLogin { return }
        let _ = MLRequest.send(.giftList, type: GiftListModel.self).subscribe(onSuccess: { model in
            if UserCenter.share.giftInfo != model {
                UserCenter.share.giftInfo = model
                UserCenter.giftInfoSubject.onNext(true)
            }
        })
    }
    private var _config: AppConfigModel?
    static var config: AppConfigModel? {
        if share._config == nil {
            getConfig()
            return nil
        }
        return share._config
    }
    static func getConfig() {
        if !isLogin { return }
        let _ = MLRequest.send(.getConfig, type: AppConfigModel.self).subscribe(onSuccess: { model in
            UserCenter.share._config = model
        })
    }
    
    ///app 启动调用
    ///如果未登录状态，直接返回启动成功
    ///如果是已登录状态，会进行RTC和IM的登录操作： 只有RTC和IM都成功，才返回启动成功，否则返回启动失败
    static func appDidLuanch(success: VoidBlock? = nil, fail: VoidBlock? = nil) {
        guard let user = share.userModel else {
            success?()
            return
        }
        login(user) {
            if $0 {
                success?()
            }else {
                fail?()
            }
        }
    }
    
    ///登录必要操作
    private static func loginRequirement() {
        if !isLogin { return }
        updateUserInfo() //更新用户信息
        getGifts() //获取礼物列表,因为礼物列表是固定的,所以在这里获取一次,后面直接用
        getConfig() //获取配置
        BeautyManager.initialize() ///初始化美颜
    }
}


//
//  LoginVM.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/25.
//

import Foundation
import RxSwift
import RxCocoa

var kAreaModels: [AreaModel]?
class LoginVM: BaseVM {
    let disposeBag = DisposeBag()
    ///长度限制
    let phoneMaxLengthSubject = PublishSubject<String>()
    ///是否有效手机号
    let phoneValidSubject = BehaviorSubject(value: false)
    ///手机号输入框变化
    private let phoneSubject = BehaviorSubject<String>(value: "")
    private(set) var phone: String = ""
    var fullPhone: String {
        "+" + country.mobile_prefix + " " + phone
    }
    
    deinit {
        currentCountdown?.dispose()
    }
    init(phoneObservable: Observable<String>) {
        super.init()
        phoneObservable.bind(to: phoneSubject).disposed(by: disposeBag)
        
        phoneSubject.subscribe(onNext: { [weak self] text in
            self?.phoneTextChanged(text)
        }).disposed(by: disposeBag)
    }
    
    private func phoneTextChanged(_ text: String) {
        var phone = text
        ///限制11位数
        if phone.count > 11 {
            phone = text[safe: 0...10] ?? ""
            phoneMaxLengthSubject.onNext(phone)
        }
        
        ///是否是有效手机号
        if phone.count == 11 {
            phoneValidSubject.onNext(true)
        }else {
            phoneValidSubject.onNext(false)
        }
    
        self.phone = phone
    }
    
    
    ///倒计信号，验证码页面会用到
    let countdownSubject = PublishSubject<Int>()
    ///倒计时时间
    var countdown: Int = 0
    ///当前正在倒计时对应的手机号，防止用户重复请求，手机号与当前倒计时手机号不一致则可以请求
    var countdownPhone: String?
    ///是否正在倒计时
    var isCountdowning: Bool {
        if countdown <= 0 {
            return false
        }
        if phone != countdownPhone {
            return false
        }
        return true
    }
    
    ///正在进行中的倒计时
    private var currentCountdown: Disposable?
    func startCountdown() {
        countdownPhone = phone
        countdown = 60
        ///取消正在执行的倒计时
        currentCountdown?.dispose()
        ///开始新的倒计时
        currentCountdown = Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
            .take(until: { [weak self] _ in (self?.countdown ?? 0) <= 0 }, behavior: .inclusive)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.countdown > 0 {
                    self.countdown -= 1
                    self.countdownSubject.onNext(self.countdown)
                }
            })
    }
    
    
    let countrySubject = BehaviorSubject(value: true)
    var country: AreaModel = .init(country: "", mobile_prefix: "86") {
        didSet {
            countrySubject.onNext(true)
        }
    }
    
    func requestArea() {
        if !kAreaModels.isNilOrEmpty { return }
        let _ = MLRequest.send(.areaCode, type: MLListResult<AreaModel>.self).subscribe(onSuccess: {
            kAreaModels = $0?.result
        })
    }
    
    let registSubject = PublishSubject<String>()
    ///onFail是为了在Controller那里重新弹出键盘，因为用户输入4位验证码会自动调用接口，然后隐藏键盘。失败需要重新弹出键盘
    func login(code: String, onFail: @escaping VoidBlock) {
        ///登录
        let _ = MLRequest.send(.login(phone: fullPhone, code: code), type: UserModel.self).subscribe(onSuccess: { user in
            if let user = user {
                if user.user == nil { //user数据为空，去注册
                    self.registSubject.onNext(user.thirdId!)
                }else {
                    self.loginCenter(user, onFail: onFail)
                }
            }else {
                onFail()
            }
        }, onFailure: { _ in
            onFail()
        })
    }
    func loginCenter(_ user: UserModel, onFail: @escaping VoidBlock) {
        Toast.showHUD()
        UserCenter.login(user) { result in
            Toast.hideHUD()
            if result == false {
                onFail()
            }
        }
    }
    
    let randomNameSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    private(set) var randomName: String?
    func getRandomName() {
        MLRequest.send(.getRandomName, type: RandomNameModel.self).subscribe(onSuccess: {
            if let name = $0?.name {
                self.randomName = name
                self.randomNameSubject.onNext(true)
            }
        }).disposed(by: disposeBag)
    }
}

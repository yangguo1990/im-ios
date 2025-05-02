//
//  PhoneCodeVC.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/24.
//

import UIKit
import RxSwift
import BonMot

class PhoneCodeVC: BaseVC {
    let disposeBag = DisposeBag()
    let viewModel: LoginVM
    init(viewModel: LoginVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var sendBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(onSend), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    
    lazy var codeView: CountInputView = {
        let view = CountInputView(count: 4)
        view.borderColor = .background.border
        view.highlightBorderColor = .black
        view.textBackgroundColor = .clear
        view.inputChanged = { [weak self] in
            self?.codeInputChanged($0)
        }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codeView.textField.becomeFirstResponder()
    }
    
    func codeInputChanged(_ text: String) {
        if text.count == 4 {
            view.endEditing(false)
            viewModel.login(code: text, onFail: { [weak self] in
                self?.codeView.textField.becomeFirstResponder()
            })
        }
    }
    
    @objc func onSend() {
        MLRequest.send(.sendCode(phone: viewModel.fullPhone, type: "login"), type: EmptyModel.self).subscribe(onSuccess: { [weak self] _ in
            self?.viewModel.startCountdown()
        }).disposed(by: disposeBag)
    }
}

extension PhoneCodeVC {
    override func setupVM() {
        super.setupVM()
        
        viewModel.countdownSubject.subscribe(onNext: { [weak self] value in
            if value > 0 {
                self?.sendBtn.setTitle("重新发送（\(value)s）", for: .normal)
                self?.sendBtn.setTitleColor(.text.describe, for: .normal)
                self?.sendBtn.isEnabled = false
            }else {
                self?.sendBtn.setTitle("重新发送", for: .normal)
                self?.sendBtn.setTitleColor(.text.body, for: .normal)
                self?.sendBtn.isEnabled = true
            }
        }).disposed(by: disposeBag)
    }
    
    override func setupView() {
        super.setupView()
        
        let hello = UILabel()
        hello.numberOfLines = 0
        hello.textColor = .text.body
        hello.font = .systemFont(ofSize: 28, weight: .medium)
        hello.attributedText = .composed(of: [
            "请输入验证码".styled(with: .font(.systemFont(ofSize: 28, weight: .medium)), .color(.text.body)),
            Special.nextLine,
            "验证码已发送至\(viewModel.fullPhone)".styled(with: .font(.systemFont(ofSize: 14)), .color(.text.describe))
        ], baseStyle: StringStyle(.lineSpacing(10)))
        view.addSubview(hello)
        hello.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
        }
        
        view.addSubview(codeView)
        codeView.snp.makeConstraints { make in
            make.top.equalTo(hello.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(60)
            make.width.equalTo(270)
        }
        
        view.addSubview(sendBtn)
        sendBtn.snp.makeConstraints { make in
            make.top.equalTo(codeView.snp.bottom).offset(16)
            make.height.equalTo(40)
            make.leading.equalTo(hello)
        }
    }
}

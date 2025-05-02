//
//  PhoneLoginVC.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/22.
//

import UIKit
import BonMot
import RxSwift
import AMPopTip

class PhoneLoginVC: BaseVC {
    var viewModel: LoginVM!
    let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel = .init(phoneObservable: phoneTf.rx.text.orEmpty.asObservable())
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var areaBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.text.secondary, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.setImage(.init(named: "arrow_down1"), for: .normal)
        btn.semanticContentAttribute = .forceRightToLeft
        btn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        btn.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        btn.addTarget(self, action: #selector(onArea), for: .touchUpInside)
        return btn
    }()
    
    lazy var phoneTf: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .phonePad
        tf.textColor = .text.body
        tf.placeholder = "请输入手机号"
        return tf
    }()
    lazy var phoneView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.background.border.cgColor
        
        view.addSubview(areaBtn)
        areaBtn.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
    
        view.addSubview(phoneTf)
        phoneTf.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(areaBtn.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
        }
        return view
    }()
    
    lazy var nextBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("获取验证码", for: .normal)
        btn.titleLabel?.font = .medium16
        btn.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        return btn
    }()
    
    lazy var areaView: AreaListView = {
        let h = view.height - phoneView.frame.maxY - 50
        let view = AreaListView(frame: .init(x: 0, y: 0, width: phoneView.width, height: h))
        view.selectedBlock = { [weak self] in
            self?.viewModel.country = $0
        }
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDimssKeyboardTapGesture()
        
        viewModel.requestArea()
    }
    
    func updateCountry() {
        areaBtn.setTitle("+" + viewModel.country.mobile_prefix + "  ", for: .normal)
    }
    
    func updateNextBtn(_ isEnabled: Bool) {
        nextBtn.isEnabled = isEnabled
        if isEnabled {
            nextBtn.setTitleColor(.white, for: .normal)
            nextBtn.backgroundColor = .black
        }else {
            nextBtn.setTitleColor(.text.secondary, for: .normal)
            nextBtn.backgroundColor = .background.disableButton
        }
    }
    
    @objc func onArea() {
        view.endEditing(true)
        if kAreaModels.isNilOrEmpty {
            viewModel.requestArea()
        }else {
            let pop = PopTip()
            pop.shouldDismissOnTap = false
            pop.shouldShowMask = true
            pop.bubbleColor = UIColor.background.main
            pop.arrowOffset = phoneView.width / 2 - areaBtn.width
            pop.show(customView: areaView, direction: .down, in: view, from: phoneView.frame)
        }
    }
    
    @objc func onNext() {
        if viewModel.isCountdowning {
            push()
            return
        }
        MLRequest.send(.sendCode(phone: viewModel.fullPhone, type: "login"), type: EmptyModel.self, disableView: nextBtn).subscribe(onSuccess: { [weak self] _ in
            self?.viewModel.startCountdown()
            self?.push()
        }).disposed(by: disposeBag)
    }
    
    func push() {
        navigationController?.pushViewController(PhoneCodeVC(viewModel: viewModel), animated: true)
    }
    
    func regist(_ thirdId: String) {
        navigationController?.pushViewController(RegistVC(viewModel: viewModel, thirdId: thirdId), animated: true)
    }
}

extension PhoneLoginVC {
    override func setupVM() {
        super.setupVM()
        
        viewModel.phoneMaxLengthSubject.bind(to: phoneTf.rx.text).disposed(by: disposeBag)
        
        viewModel.phoneValidSubject.subscribe(onNext: { [weak self] in
            self?.updateNextBtn($0)
        }).disposed(by: disposeBag)
        
        viewModel.countrySubject.subscribe(onNext: { [weak self] text in
            self?.updateCountry()
        }).disposed(by: disposeBag)
        
        viewModel.registSubject.subscribe(onNext: { [weak self] in
            self?.regist($0)
        }).disposed(by: disposeBag)
    }
    
    override func setupView() {
        super.setupView()
        
        let hello = UILabel()
        hello.numberOfLines = 0
        hello.textColor = .text.body
        hello.font = .systemFont(ofSize: 28, weight: .medium)
        hello.attributedText = "Hello !\n欢迎来到\(Constants.app.name)".styled(with: .lineSpacing(5))
        view.addSubview(hello)
        hello.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
        }
        
        view.addSubview(phoneView)
        phoneView.snp.makeConstraints { make in
            make.top.equalTo(hello.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        phoneView.layerCornerRadius = 25
        
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.top.equalTo(phoneView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        nextBtn.layerCornerRadius = 25
    }
}

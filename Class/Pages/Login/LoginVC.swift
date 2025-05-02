//
//  LoginVC.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/21.
//

import UIKit

class LoginVC: BaseVC {
    lazy var serverBtn: UIButton = {
        let btn = UIButton(frame: .init(x: 0, y: 0, width: 80, height: 30))
        btn.setTitle("联系客服", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(.text.body, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        btn.layerCornerRadius = 8
        btn.addTarget(self, action: #selector(onServer), for: .touchUpInside)
        return btn
    }()
    lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("手机验证码登录", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(.text.body, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        btn.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
        return btn
    }()
    
    lazy var agreeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "icon_select_nor"), for: .normal)
        btn.setImage(.init(named: "icon_select_sel"), for: .selected)
        btn.addTarget(self, action: #selector(onAgree), for: .touchUpInside)
        return btn
    }()
    
    lazy var yhxyRange: NSRange = {
        let range = Constants.string.agreeString.range(of: Constants.string.yhxy)!
        return NSRange(range, in: Constants.string.agreeString)
    }()
    lazy var yszcRange: NSRange = {
        let range = Constants.string.agreeString.range(of: Constants.string.yszc)!
        return NSRange(range, in: Constants.string.agreeString)
    }()
    lazy var agreeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.textColor = .white
        let attributedStr = NSMutableAttributedString.init(string: Constants.string.agreeString, attributes: [.font: UIFont.body12])
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.background.purple]
        attributedStr.addAttributes(attributes, range: yhxyRange)
        attributedStr.addAttributes(attributes, range: yszcRange)
        label.attributedText = attributedStr
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(_:))))
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLightContent = false
        navigationItem.rightBarButtonItem = .init(customView: serverBtn)
    }
}

extension LoginVC {
    @objc func handleTapOnLabel(_ recognizer: UITapGestureRecognizer) {
        if recognizer.didTapAttributedTextInLabel(label: agreeLabel, inRange: yhxyRange) {
            navigationController?.pushViewController(BaseWebVC(Constants.url.yhxy))
        }else if recognizer.didTapAttributedTextInLabel(label: agreeLabel, inRange: yszcRange) {
            navigationController?.pushViewController(BaseWebVC(Constants.url.yszc))
        }
    }
    @objc func onAgree() {
        agreeBtn.isSelected = !agreeBtn.isSelected
    }
    @objc func onServer() {
        alert(title: "客服微信号", message: Constants.serviceWechatId, .cancel("取消", nil), .done("复制", {
            Constants.serviceWechatId.copyToPasteboard()
            Toast.show("复制成功")
        }))
    }
    @objc func onLogin() {
        if !agreeBtn.isSelected {
            showAgreeAlert()
            return
        }
        pushToLogin()
    }
    
    func showAgreeAlert() {
        let vc = LoginAgreeAlert()
        vc.completion = { [weak self] in
            self?.agreeBtn.isSelected = true
            self?.pushToLogin()
        }
        let navc = BaseNavigationVC.init(rootViewController: vc)
        navc.modalPresentationStyle = .overCurrentContext
        navc.modalTransitionStyle = .crossDissolve
        present(navc, animated: true)
    }
    
    func pushToLogin() {
        navigationController?.pushViewController(PhoneLoginVC(), animated: true)
    }
}

extension LoginVC {
    override func setupView() {
        super.setupView()
        
        let bg = UIImageView(image: .init(named: "bg_launch"))
        bg.contentMode = .scaleToFill
        view.addSubview(bg)
        bg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let logo = UIImageView(image: .init(named: "logo_100"))
        view.addSubview(logo)
        logo.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            make.centerX.equalToSuperview()
        }
        
        let appName = UILabel()
        appName.text = Constants.app.name
        appName.textColor = .white
        appName.font = .systemFont(ofSize: 24)
        view.addSubview(appName)
        appName.snp.makeConstraints { make in
            make.top.equalTo(logo.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        loginBtn.layerCornerRadius = 25
        
        view.addSubview(agreeLabel)
        agreeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalToSuperview().offset(48)
        }
        
        view.addSubview(agreeBtn)
        agreeBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.width.height.equalTo(40)
            make.top.equalTo(agreeLabel).offset(-12)
        }
    }
}

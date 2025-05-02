//
//  LoginAgreeAlert.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/22.
//

import UIKit

class LoginAgreeAlert: BaseVC {
    var completion: VoidBlock?
    lazy var contanier: UIView = {
        let contanier = UIView()
        contanier.backgroundColor = .white
        contanier.layerCornerRadius = 12
        return contanier
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "\(Constants.app.name)用户协议和隐私政策提示"
        label.font = .title18
        label.textColor = .black
        return label
    }()
    
    lazy var yhxyRange: NSRange = {
        let range = Constants.string.agreeTip.range(of: Constants.string.yhxy)!
        return NSRange(range, in: Constants.string.agreeTip)
    }()
    lazy var yszcRange: NSRange = {
        let range = Constants.string.agreeTip.range(of: Constants.string.yszc)!
        return NSRange(range, in: Constants.string.agreeTip)
    }()
    lazy var ydrzRange: NSRange = {
        let range = Constants.string.agreeTip.range(of: Constants.string.ydrz)!
        return NSRange(range, in: Constants.string.agreeTip)
    }()
    lazy var msgLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.textColor = .text.body
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 5
        paragraphStyle.alignment = .left
        let attributedStr = NSMutableAttributedString.init(string: Constants.string.agreeTip, attributes: [.paragraphStyle: paragraphStyle, .font: UIFont.body12])
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.background.purple]
        attributedStr.addAttributes(attributes, range: yhxyRange)
        attributedStr.addAttributes(attributes, range: yszcRange)
        attributedStr.addAttributes(attributes, range: ydrzRange)
        label.attributedText = attributedStr
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(_:))))
        return label
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.setTitle("同意并继续", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .medium16
        btn.addTarget(self, action: #selector(onConfirmClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitle("不同意", for: .normal)
        btn.setTitleColor(.text.secondary, for: .normal)
        btn.titleLabel?.font = .body12
        btn.addTarget(self, action: #selector(onCancelClick), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isNavigationBarHidden = true
        navigationController?.view.backgroundColor = .clear
    }
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = UIColor.background.cover
        view.addSubview(contanier)
        contanier.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        contanier.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
        }
        contanier.addSubview(msgLabel)
        msgLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contanier.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(msgLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        confirmBtn.layerCornerRadius = 25
        
        contanier.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(confirmBtn.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}

extension LoginAgreeAlert {
    @objc func onConfirmClick() {
        dismiss(animated: true)
        completion?()
    }
    
    @objc func onCancelClick() {
        dismiss(animated: true)
    }
    
    @objc func handleTapOnLabel(_ recognizer: UITapGestureRecognizer) {
        if recognizer.didTapAttributedTextInLabel(label: msgLabel, inRange: yhxyRange) {
            navigationController?.pushViewController(BaseWebVC(Constants.url.yhxy))
        }else if recognizer.didTapAttributedTextInLabel(label: msgLabel, inRange: yszcRange) {
            navigationController?.pushViewController(BaseWebVC(Constants.url.yszc))
        }else if recognizer.didTapAttributedTextInLabel(label: msgLabel, inRange: ydrzRange) {
            navigationController?.pushViewController(BaseWebVC(Constants.url.ydrz))
        }
    }
}


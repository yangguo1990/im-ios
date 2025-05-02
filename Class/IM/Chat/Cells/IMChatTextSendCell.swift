//
//  IMChatTextCell.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/15.
//

import UIKit
import HyphenateChat

class IMChatTextSendCell: UITableViewCell {
    var message: IMChatMsgModel? {
        didSet {
            updateData()
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    lazy var avatar: AvatarView = {
        let avatar = AvatarView()
        return avatar
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .background.orange
        view.addSubview(msgLabel)
        msgLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.height.greaterThanOrEqualTo(20)
        }
        return view
    }()
    
    lazy var msgLabel: UILabel = {
        let label = UILabel()
        label.addCopyTapGesture()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    lazy var failBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "msg_fail"), for: .normal)
        return btn
    }()
    
    
    private func commonInit() {
        
        backgroundColor = .clear
        
        contentView.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(12)
            make.width.height.equalTo(40)
        }
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(avatar)
            make.trailing.equalTo(avatar.snp.leading).offset(-12)
            make.leading.greaterThanOrEqualToSuperview().offset(68)
            make.bottom.equalToSuperview().inset(12)
        }
        
        contentView.addSubview(failBtn)
        failBtn.snp.makeConstraints { make in
            make.centerY.equalTo(containerView)
            make.trailing.equalTo(containerView.snp.leading)
            make.width.height.equalTo(40)
        }
        failBtn.isHidden = true
    }
    
    func updateData() {
        avatar.set(url: UserCenter.loginUser.avatar, placeholder: .init(named: "msg_user40"))
        
        let textMsg = message?.msg.body as? EMTextMessageBody
        msgLabel.text = textMsg?.text
        
        if message?.msg.status == .failed {
            failBtn.isHidden = false
        }else {
            failBtn.isHidden = true
        }
    }
}

//
//  IMChatTextRecCell.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/16.
//

import UIKit
import HyphenateChat

class IMChatTextRecCell: UITableViewCell {
    var user: EMUserInfo? {
        didSet {
            updateUser()
        }
    }
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
        view.backgroundColor = .background.container
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
        label.textColor = .text.body
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    
    private func commonInit() {
        
        backgroundColor = .clear
        
        contentView.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(12)
            make.width.height.equalTo(40)
        }
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(avatar)
            make.leading.equalTo(avatar.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualToSuperview().offset(-68)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func updateData() {
        let textMsg = message?.msg.body as? EMTextMessageBody
        msgLabel.text = textMsg?.text
    }
    
    func updateUser() {
        avatar.addUser(userId: user?.userId)
        avatar.setIMUser(user, placeholder: .init(named: "msg_user40"))
    }
}

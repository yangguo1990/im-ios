//
//  IMChatVoiceCell.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/15.
//

import UIKit
import HyphenateChat

class IMChatVoiceRecCell: UITableViewCell {
    var viewModel: IMChatVM?
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
        view.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onVoiceTap)))
        return view
    }()
    
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text.body
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    lazy var icon: UIImageView = {
        let icon = UIImageView(image: .init(named: "msg_sound"))
        return icon
    }()
    
    lazy var redDot: UIView = {
        let view = UIView()
        view.backgroundColor = .background.red
        return view
    }()
    
    private func commonInit() {
        
        backgroundColor = .clear
        
        contentView.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(12)
            make.width.height.equalTo(40)
            make.bottom.equalToSuperview().inset(12)
        }
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(avatar)
            make.leading.equalTo(avatar.snp.trailing).offset(12)
            make.height.equalTo(avatar)
            make.width.equalTo(110)
        }
        
        contentView.addSubview(redDot)
        redDot.snp.makeConstraints { make in
            make.centerY.equalTo(containerView)
            make.leading.equalTo(containerView.snp.trailing).offset(8)
            make.width.height.equalTo(6)
        }
        redDot.layer.cornerRadius = 3
    }
    
    func updateData() {
        let voiceMsg = message?.msg.body as? EMVoiceMessageBody
        durationLabel.text = "\(voiceMsg?.duration ?? 0)s"
        redDot.isHidden = message?.msg.isListened ?? true
        
        if message?.isSoundPlaying ?? false {
            icon.startScale(0.5)
        }else {
            icon.stopScale()
        }
    }
    
    func updateUser() {
        avatar.addUser(userId: user?.userId)
        avatar.setIMUser(user, placeholder: .init(named: "msg_user40"))
    }
    
    @objc func onVoiceTap() {
        viewModel?.playSound(message)
    }
}

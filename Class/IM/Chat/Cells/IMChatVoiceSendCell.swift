//
//  IMChatVoiceSendCell.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/31.
//

import UIKit
import HyphenateChat

class IMChatVoiceSendCell: UITableViewCell {
    var viewModel: IMChatVM?
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
        view.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.trailing.equalTo(icon.snp.leading).offset(-8)
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
        icon.transform = .init(rotationAngle: Double.pi)
        return icon
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
            make.bottom.equalToSuperview().inset(12)
        }
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(avatar)
            make.trailing.equalTo(avatar.snp.leading).offset(-12)
            make.height.equalTo(avatar)
            make.width.equalTo(110)
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
        
        let voiceMsg = message?.msg.body as? EMVoiceMessageBody
        durationLabel.text = "\(voiceMsg?.duration ?? 0)s"
        
        if message?.msg.status == .failed {
            failBtn.isHidden = false
        }else {
            failBtn.isHidden = true
        }
        
        if message?.isSoundPlaying ?? false {
            icon.startScale(0.5)
        }else {
            icon.stopScale()
        }
    }
    
    @objc func onVoiceTap() {
        viewModel?.playSound(message)
    }
}

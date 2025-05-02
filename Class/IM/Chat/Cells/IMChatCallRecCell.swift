//
//  IMChatCallRecCell.swift
//  MeiLiao
//
//  Created by Kun Xun on 2024/2/26.
//

import UIKit
import HyphenateChat

class IMChatCallRecCell: UITableViewCell {
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
    
    lazy var containerView: UIButton = {
        let btn = UIButton()
        btn.layerCornerRadius = 12
        btn.backgroundColor = .background.container
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        btn.setTitleColor(.text.body, for: .normal)
        btn.setImage(UIImage(named: "msg_video24"), for: .normal)
        btn.contentEdgeInsets = .init(horizontal: 24, vertical: 0)
        btn.addTarget(self, action: #selector(onCallTap), for: .touchUpInside)
        return btn
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
        }
    }
    
    func updateData() {
        containerView.setTitle(" 视频聊天", for: .normal)
        let body = message?.msg.body as? EMCustomMessageBody
        guard let data = body?.customExt["data"]?.data(using: .utf8),
              let model = try? JSONDecoder().decode(IMCallModel.self, from: data) else { return }
        containerView.setTitle(" \(model.imString)", for: .normal)
    }
    
    func updateUser() {
        avatar.addUser(userId: user?.userId)
        avatar.set(url: user?.avatarUrl, placeholder: .init(named: "msg_user40"))
    }
    
    @objc func onCallTap() {
        if let uid = viewModel?.userId {
            RTCManager.call(uid)
        }
    }
}

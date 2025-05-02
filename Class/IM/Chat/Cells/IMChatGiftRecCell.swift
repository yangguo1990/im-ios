//
//  IMChatGiftRecCell.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/3/2.
//

import UIKit
import HyphenateChat
import BonMot

class IMChatGiftRecCell: UITableViewCell {
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
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .text.body
        label.font = .body14
        return label
    }()
    
    lazy var imgView: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .white
        img.contentMode = .scaleAspectFill
        img.layerCornerRadius = 8
        return img
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .background.container
        view.layerCornerRadius = 8
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        view.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.width.height.equalTo(128)
            make.leading.trailing.bottom.equalToSuperview().inset(8)
        }
        return view
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
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func updateData() {
        let body = message?.msg.body as? EMCustomMessageBody
        guard let data = body?.customExt[Constants.im.giftDataKey]?.data(using: .utf8),
              let model = try? JSONDecoder().decode(GiftSendModel.self, from: data) else { return }
        nameLabel.attributedText = .composed(of: [
            "送你".styled(with: .color(.text.body)),
            model.gift.name.styled(with: .color(.background.red)),
            "x\(model.number)".styled(with: .color(.text.body))
        ])
        imgView.kf.setImage(with: URL(string: model.gift.src))
    }
    
    func updateUser() {
        avatar.addUser(userId: user?.userId)
        avatar.set(url: user?.avatarUrl, placeholder: .init(named: "msg_user40"))
    }
}

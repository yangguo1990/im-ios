//
//  IMChatGiftSendCell.swift
//  MeiLiao
//
//  Created by Kun Xun on 2024/3/2.
//

import UIKit
import HyphenateChat
import BonMot

class IMChatGiftSendCell: UITableViewCell {
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
        view.backgroundColor = .background.orange
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
        if message?.msg.status == .failed {
            failBtn.isHidden = false
        }else {
            failBtn.isHidden = true
        }
        
        let body = message?.msg.body as? EMCustomMessageBody
        guard let data = body?.customExt[Constants.im.giftDataKey]?.data(using: .utf8),
              let model = try? JSONDecoder().decode(GiftSendModel.self, from: data) else { return }
        nameLabel.attributedText = .composed(of: [
            "送出".styled(with: .color(.text.body)),
            model.gift.name.styled(with: .color(.background.red)),
            "x\(model.number)".styled(with: .color(.text.body))
        ])
        imgView.kf.setImage(with: URL(string: model.gift.src))
    }
}

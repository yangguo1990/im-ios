//
//  ConversationCell.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/14.
//

import UIKit
import Kingfisher
import SwifterSwift
import SwiftUI

class ConversationCell: UITableViewCell {
    var model: IMConversationModel? {
        didSet {
            updateData()
        }
    }
    var isLast: Bool = false {
        didSet {
            line.isHidden = isLast
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
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = .background.separator
        return view
    }()
    
    lazy var avatar: AvatarView = {
        let avatar = AvatarView()
        return avatar
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text.body
        label.font = .medium16
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    lazy var msgLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text.secondary
        label.font = .body12
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text.describe
        label.font = .body12
        label.textAlignment = .right
        return label
    }()
    
    lazy var unreadLabel: UnreadLabel = {
        let label = UnreadLabel()
        return label
    }()
    
    private func commonInit() {
        backgroundColor = .clear
        
        contentView.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(48)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(avatar).offset(6)
            make.trailing.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatar.snp.trailing).offset(16)
            make.trailing.equalTo(timeLabel.snp.leading).offset(-16)
            make.centerY.equalTo(timeLabel)
        }
        
        contentView.addSubview(msgLabel)
        msgLabel.snp.makeConstraints { make in
            make.bottom.equalTo(avatar).inset(6)
            make.leading.equalTo(nameLabel)
            make.trailing.equalToSuperview().inset(60)
        }
        
        contentView.addSubview(unreadLabel)
        unreadLabel.snp.makeConstraints { make in
            make.centerY.equalTo(msgLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func updateData() {
        if let msg = model?.conversation.latestMessage {
            timeLabel.text = Utils.msgTime(msg.localTime)
        }else {
            timeLabel.text = ""
        }
        
        nameLabel.text = model?.user?.showName
        msgLabel.text = IMHelper.getAbstructOf(conversation: model?.conversation)
        if model?.isListenedVoiceMsg ?? true {
            msgLabel.textColor = .text.secondary
        }else {
            msgLabel.textColor = .background.red ///未读语音红色显示
        }
        unreadLabel.unreadCount_int32 = model?.conversation.unreadMessagesCount
        
        avatar.avatarColor = model?.avatarColor
        avatar.setIMUser(model?.user, size: 48)
    }
}

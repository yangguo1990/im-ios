//
//  IMChatImgRecCell.swift
//  MeiLiao
//
//  Created by Kun Xun on 2024/2/28.
//

import UIKit
import HyphenateChat
import Kingfisher

class IMChatImgRecCell: UITableViewCell {
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
    
    lazy var img: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var imgContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .background.container
        view.layerCornerRadius = 8
        
        view.addSubview(img)
        img.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPicTap)))
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
        avatar.layerCornerRadius = 20
        
        contentView.addSubview(imgContainer)
        imgContainer.snp.makeConstraints { make in
            make.top.equalTo(avatar)
            make.leading.equalTo(avatar.snp.trailing).offset(12)
            make.bottom.equalToSuperview().inset(12).priority(.high)
            make.height.equalTo(68)
            make.width.equalTo(68)
        }
    }
    
    @objc func onPicTap() {
        if let message = message, let vc = parentViewController {
            viewModel?.showAgrume(message: message, from: vc)
        }
    }
    
    func updateData() {
        
        let body = message?.msg.body as? EMImageMessageBody
        if let filePath = body?.localPath {
            img.kf.setImage(with: URL(fileURLWithPath: filePath))
        }else {
            img.kf.setImage(with: URL(string: body?.remotePath))
        }
        
        let size = IMHelper.getImgSizeOf(origin: body?.size)
        imgContainer.snp.remakeConstraints { make in
            make.top.equalTo(avatar)
            make.leading.equalTo(avatar.snp.trailing).offset(12)
            make.bottom.equalToSuperview().inset(12).priority(.high)
            make.height.equalTo(size.height)
            make.width.equalTo(size.width)
        }
    }
    
    func updateUser() {
        avatar.addUser(userId: user?.userId)
        avatar.setIMUser(user, placeholder: .init(named: "msg_user40"))
    }
}

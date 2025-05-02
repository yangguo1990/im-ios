//
//  IMChatSendImgCell.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/15.
//

import UIKit
import HyphenateChat

class IMChatImgSendCell: UITableViewCell {
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
        avatar.layerCornerRadius = 20
        
        contentView.addSubview(imgContainer)
        imgContainer.snp.makeConstraints { make in
            make.top.equalTo(avatar)
            make.trailing.equalTo(avatar.snp.leading).offset(-12)
            make.bottom.equalToSuperview().inset(12).priority(.high)
            make.height.equalTo(68)
            make.width.equalTo(68)
        }
        
        
        contentView.addSubview(failBtn)
        failBtn.snp.makeConstraints { make in
            make.centerY.equalTo(img)
            make.trailing.equalTo(img.snp.leading)
            make.width.height.equalTo(40)
        }
        failBtn.isHidden = true
    }
    
    
    @objc func onPicTap() {
        if let message = message, let vc = parentViewController {
            viewModel?.showAgrume(message: message, from: vc)
        }
    }
    
    func updateData() {
        avatar.set(url: UserCenter.loginUser.avatar, placeholder: .init(named: "msg_user40"))
        let body = message?.msg.body as? EMImageMessageBody
        if let filePath = body?.localPath {
            img.kf.setImage(with: URL(fileURLWithPath: filePath))
        }else {
            img.kf.setImage(with: URL(string: body?.remotePath))
        }
        let size = IMHelper.getImgSizeOf(origin: body?.size)
        imgContainer.snp.remakeConstraints { make in
            make.top.equalTo(avatar)
            make.trailing.equalTo(avatar.snp.leading).offset(-12)
            make.bottom.equalToSuperview().inset(12).priority(.high)
            make.height.equalTo(size.height)
            make.width.equalTo(size.width)
        }
        
        if message?.msg.status == .failed {
            failBtn.isHidden = false
        }else {
            failBtn.isHidden = true
        }
    }
}

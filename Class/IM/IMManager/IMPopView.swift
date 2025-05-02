//
//  IMPopView.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/3/3.
//

import UIKit
import HyphenateChat

class IMPopView: UIView {
    let message: EMChatMessage
    
    lazy var avatar: AvatarView = {
        let avatar = AvatarView()
        return avatar
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text.body
        label.font = .medium16
        return label
    }()
    lazy var msgLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text.secondary
        label.font = .body14
        return label
    }()
    
    lazy var replyBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("回复", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .medium16
        btn.backgroundColor = UIColor(hex: "#3585ff")
        btn.addTarget(self, action: #selector(onReply), for: .touchUpInside)
        return btn
    }()
    
    init(message: EMChatMessage)  {
        self.message = message
        super.init(frame: .zero)
        setup()
        requestUserInfo()
        autoHide()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func autoHide() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hideAnimate()
        }
    }
    
    private func setup() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        backgroundColor = .background.main
        addShadow(ofColor: .background.shadom, radius: 3, offset: .init(width: 0, height: -3), opacity: 0.7)
        
        addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(48)
        }
        avatar.layerCornerRadius = 24
        
        addSubview(replyBtn)
        replyBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(36)
            make.width.equalTo(80)
        }
        replyBtn.layerCornerRadius = 18
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatar).offset(2)
            make.leading.equalTo(avatar.snp.trailing).offset(8)
            make.trailing.equalTo(replyBtn.snp.leading).offset(-16)
        }
        
        addSubview(msgLabel)
        msgLabel.snp.makeConstraints { make in
            make.bottom.equalTo(avatar).offset(-2)
            make.leading.trailing.equalTo(nameLabel)
        }
        msgLabel.text = IMHelper.getAbstructOf(message: message)
        
        addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(hideAnimate)))
    }
    
    private func requestUserInfo() {
        let id = message.conversationId
        EMClient.shared().userInfoManager?.fetchUserInfo(byId: [id], completion: { [weak self] result, error in
            if let user = result?[id] {
                DispatchQueue.main.async {
                    self?.avatar.setIMUser(user, size: 48)
                    self?.nameLabel.text = user.showName
                }
            }
        })
    }
    
    @objc func onReply() {
        let vc = IMChatVC.init(chatId: message.conversationId)
        if let navc = parentViewController as? UINavigationController {
            navc.pushViewController(vc, animated: true)
        }else {
            parentViewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension IMPopView {
    func showAnimate(inView: UIView) {
        if superview == nil {
            inView.addSubview(self)
        }
        let height: CGFloat = 80
        let y = inView.frame.maxY - inView.safeAreaInsets.bottom
        frame = .init(x: 0, y: y, width: inView.width, height: 0)
        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.frame = .init(x: 0, y: y - height, width: inView.width, height: height)
            self.alpha = 1
        }
        
    }
    @objc func hideAnimate() {
        UIView.animate(withDuration: 0.25) {
            self.transform = .init(scaleX: 0.1, y: 0.1)
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

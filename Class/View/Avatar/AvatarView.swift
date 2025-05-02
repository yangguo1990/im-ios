//
//  AvatarView.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/14.
//

import UIKit
import RxSwift
import HyphenateChat

class AvatarView: UIView {
    
    var avatarColor: UIColor?
    
    private var tapGesuture: UITapGestureRecognizer?
    
    private var userId: String? {
        didSet {
            if userId == Constants.im.serviceId || userId == Constants.im.messageId {
                return
            }
            if tapGesuture == nil && userId != nil {
                tapGesuture = UITapGestureRecognizer.init(target: self, action: #selector(onAvatarTap))
                addGestureRecognizer(tapGesuture!)
            }
        }
    }
    
    lazy var imgView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.borderColor = UIColor(hex: "CCC").cgColor
        img.layer.borderWidth = 0.5
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgView.layer.cornerRadius = frame.size.height / 2
        imgView.layer.masksToBounds = true
    }
    
    @objc func onAvatarTap() {
        guard let userId = self.userId?.removingPrefix("im") else { return }
        if let uid = userId.int {
            parentViewController?.pushToUserDetailController(uid)
        }
    }
}

extension AvatarView {
    func set(url: String?, name: String?, size: Double) {
        let color = avatarColor ?? .random.alpha(0.7)
        let placeholder = UIImage.textToImage(name?.first?.string ?? "", size: .init(width: size, height: size), backgroudColor: color)
        imgView.kf.setImage(with: URL(string: url), placeholder: placeholder)
    }
    
    func set(url: String?, placeholder: UIImage?) {
        imgView.kf.setImage(with: URL(string: url), placeholder: placeholder)
    }
    
    func addUser(userId: String?) {
        self.userId = userId
    }
    
    func setIMUser(_ user: EMUserInfo?, size: Double) {
        if user?.userId == Constants.im.messageId {
            imgView.image = .init(named: "msg_msg")
        }else if user?.userId == Constants.im.serviceId {
            imgView.image = .init(named: "msg_server")
        }else {
            set(url: user?.avatarUrl, name: user?.showName, size: size)
        }
    }
    
    func setIMUser(_ user: EMUserInfo?, placeholder: UIImage?) {
        if user?.userId == Constants.im.messageId {
            imgView.image = .init(named: "msg_msg")
        }else if user?.userId == Constants.im.serviceId {
            imgView.image = .init(named: "msg_server")
        }else {
            set(url: user?.avatarUrl, placeholder: placeholder)
        }
    }
}

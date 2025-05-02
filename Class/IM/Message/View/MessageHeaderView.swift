//
//  MessageHeaderView.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/15.
//

import UIKit
import HyphenateChat

var _kfUrl: String?

class MessageHeaderView: UIView {
    static let height: CGFloat = 180
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        let system = createButton(title: "系统通知", imgName: "msg_system")
        system.addTarget(self, action: #selector(onSystem), for: .touchUpInside)
        
        let scale = UIScreen.main.bounds.size.width/375.0
        addSubview(system)
        system.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.width.equalTo(100*scale)
            make.height.equalTo(90*scale)
            make.left.equalTo(16*scale)
        }
        
        let msg = createButton(title: "官方消息", imgName: "msg_msg")
        msg.addTarget(self, action: #selector(onMessage), for: .touchUpInside)
        
        addSubview(msg)
        msg.snp.makeConstraints { make in
            make.centerY.width.height.equalTo(system)
            make.left.equalTo(138*scale)
        }
        
        let server = createButton(title: "官方客服", imgName: "msg_server")
        server.addTarget(self, action: #selector(onServer), for: .touchUpInside)
        
        addSubview(server)
        server.snp.makeConstraints { make in
            make.centerY.width.height.equalTo(system)
            make.left.equalTo(260*scale)
        }
        
//        let hi = createButton(title: "打招呼", imgName: "msg_hi")
//        hi.addTarget(self, action: #selector(onHi), for: .touchUpInside)
//        
//        addSubview(hi)
//        hi.snp.makeConstraints { make in
//            make.centerX.width.height.equalTo(msg)
//            make.top.equalTo(msg.snp.bottom).offset(10);
//        }
        
//        let label = UILabel()
//        label.text = "消息列表"
//        label.font = .title16
//        label.textColor = .text.body
//        addSubview(label)
//        label.snp.makeConstraints { make in
//            make.top.equalTo(server.snp.bottom).offset(16)
//            make.leading.equalToSuperview().offset(20)
//        }
    }
    
    private func createButton(title: String, imgName: String) -> UIButton {
        let btn = UIButton()
        btn.titleLabel?.font = .medium12
        btn.setTitleColor(.text.body, for: .normal)
        btn.setTitle(title, for: .normal)
        btn.setImage(UIImage(named: imgName), for: .normal)
        btn.centerTextAndImage(imageAboveText: true, spacing: 8)
        return btn
    }
}

extension MessageHeaderView {
    @objc func onSystem() {
//        let vc = IMChatVC.init(chatId: "im5143570")
        let vc = SystemMessageVC()
        parentViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func onMessage() {
        let vc = SystemMessageVC()
        parentViewController?.navigationController?.pushViewController(vc, animated: true)
    } 
    @objc func onServer() {
        if UserCenter.config?.user?.curCustomerType == "0" {
            let vc = IMChatVC.init(chatId: Constants.im.serviceId)
            parentViewController?.navigationController?.pushViewController(vc, animated: true)
        }else {
            if let url = _kfUrl {
                let encodeUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let vc = BaseWebVC.init(encodeUrl!)
                parentViewController?.navigationController?.pushViewController(vc, animated: true)
            }else {
                let _ = MLRequest.send(.getKfUrl, type: KfUrlModel.self).subscribe(onSuccess: {
                    _kfUrl = $0?.url
                    if let url = $0?.url {
                        let encodeUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        let vc = BaseWebVC.init(encodeUrl!)
                        self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
                    }
                })
            }
        }
    }
    @objc func onHi() {
        let vc = HelloAlert()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        parentViewController?.tabBarController?.present(vc, animated: true)
    }
}

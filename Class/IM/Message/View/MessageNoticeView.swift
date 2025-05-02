//
//  MessageNoticeView.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/15.
//

import UIKit
import BonMot

class MessageNoticeView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 12
        
        let bgimage = UIImageView(image: .init(named: "msg_notice_bg"))
        addSubview(bgimage)
        bgimage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        let icon = UIImageView(image: .init(named: "msg_notice"))
        addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
        }
        
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = NSAttributedString.composed(of: [
            "打开通知，接受消息".styled(with: .color(.text.body), .font(.medium12)),
            Special.nextLine,
            "交友成功10倍".styled(with: .color(.text.describe), .font(.body10))
        ], baseStyle: StringStyle(.lineSpacing(4)))
        addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(icon.snp.trailing).offset(16)
        }
        
        
        let btn = UIButton()
        btn.setTitle("去开启", for: .normal)
        btn.setTitleColor(.black, for: .normal)
//        btn.backgroundColor = .background.orange
        btn.setBackgroundImage(UIImage(named: "buttonBG"), for: UIControl.State.normal)
        btn.titleLabel?.font = .medium14
        btn.contentEdgeInsets = .init(horizontal: 24, vertical: 0)
        btn.addTarget(self, action: #selector(onOpen), for: .touchUpInside)
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.centerY.equalToSuperview()
            make.height.equalTo(28)
            make.right.equalToSuperview().offset(-10)
        }
        btn.layer.cornerRadius = 14
    }
    
    @objc func onOpen() {
        let center  = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    GlobalSignal.noticePermissionChanged.onNext(true)
                }
                UIApplication.shared.registerForRemoteNotifications()
            }else {
                DispatchQueue.main.async {
                    self.openSetting()
                }
            }
        }
    }
    
    private func openSetting() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
            UIApplication.shared.open(appSettings)
        }
    }
}

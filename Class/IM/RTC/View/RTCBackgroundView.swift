//
//  RTCBackgroundView.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/2/1.
//

import UIKit

class RTCBackgroundView: UIView {
    let viewModel: RTCVM
    
    init(viewModel: RTCVM) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let user = RTCManager.share.remoteUser.otherInfo
        ///主播视角，展示背景图
        if UserCenter.loginUser.isHost {
            let bg = UIImageView(image: .init(named: "msg_call_bg2"))
            bg.contentMode = .scaleAspectFill
            addSubview(bg)
            bg.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            if let url = user.backgroundImg {
                bg.kf.setImage(with: URL(string: url))
            }
        }else { ///用户视角，展示背景图或者播放主播主页视频
            let bg = UIImageView(image: .init(named: "msg_call_bg"))
            bg.contentMode = .scaleAspectFill
            addSubview(bg)
            bg.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            if let url = user.backgroundImg {
                bg.kf.setImage(with: URL(string: url))
            }
        }
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.alpha = 0.2
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}

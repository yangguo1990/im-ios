//
//  IMChatToolView.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/15.
//

import UIKit
import RxSwift
import SnapKit

///IM聊天工具类型
enum IMChatToolType {
    case c2c //单聊
    case rtc //rtc发消息
    case service //客服聊天
}

class IMChatToolView: UIView {
    let toolType: IMChatToolType
    let viewModel: IMChatVM
    let disposeBag = DisposeBag()
    private var tvHeightConstraint: Constraint?
    
    init(viewModel: IMChatVM, toolType: IMChatToolType = .c2c) {
        self.toolType = toolType
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        setupVM()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var emojiView: IMChatEmojiView = {
        let view = IMChatEmojiView(frame: .init(x: 0, y: 0, width: 0, height: 280))
        view.backgroundColor = .background.main
        view.delegate = self
        return view
    }()
    
    lazy var placeholder: UILabel = {
        let label = UILabel()
        label.text = "请输入..."
        label.textColor = .text.describe
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    lazy var tv: UITextView = {
        let tv = UITextView()
        tv.textColor = .black
        tv.font = .systemFont(ofSize: 16)
        tv.backgroundColor = .background.container
        tv.layerCornerRadius = 12
        tv.textContainerInset = .init(top: 10, left: 8, bottom: 10, right: 8)
        tv.delegate = self
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(onTextViewTap))
        tap.delegate = self
        tv.addGestureRecognizer(tap)
        return tv
    }()
    
    lazy var emojiBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "msg_emoji"), for: .normal)
        btn.addTarget(self, action: #selector(onEmoji), for: .touchUpInside)
        return btn
    }()
    lazy var keyboardBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "msg_keyboard"), for: .normal)
        btn.addTarget(self, action: #selector(onKeyboard), for: .touchUpInside)
        btn.alpha = 0
        return btn
    }()
    lazy var voiceBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "msg_voice"), for: .normal)
        btn.addTarget(self, action: #selector(onVoice), for: .touchUpInside)
        return btn
    }()
    
    lazy var videoBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "msg_video"), for: .normal)
        btn.addTarget(self, action: #selector(onVideo), for: .touchUpInside)
        return btn
    }()
    
    lazy var giftBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "msg_gift2"), for: .normal)
        btn.addTarget(self, action: #selector(onGift), for: .touchUpInside)
        return btn
    }()
    
    lazy var imgBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "msg_image"), for: .normal)
        btn.addTarget(self, action: #selector(onImage), for: .touchUpInside)
        return btn
    }()
    
    lazy var sendBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "sendBt"), for: .normal)
        btn.addTarget(self, action: #selector(onSend), for: .touchUpInside)
        return btn
    }()
    
    @objc func onTextViewTap() {
        onKeyboard()
    }
    
    @objc func onEmoji() {
        tv.inputView = emojiView
        if tv.isFirstResponder {
            UIView.animate(withDuration: 0.25) {
                self.tv.reloadInputViews()
                self.keyboardBtn.alpha = 1
                self.emojiBtn.alpha = 0
            }
        }else {
            tv.reloadInputViews()
            tv.becomeFirstResponder()
            UIView.animate(withDuration: 0.25) {
                self.keyboardBtn.alpha = 1
                self.emojiBtn.alpha = 0
            }
        }
    }
    
    @objc func onKeyboard() {
        tv.inputView = nil
        UIView.animate(withDuration: 0.25) {
            self.tv.reloadInputViews()
            self.keyboardBtn.alpha = 0
            self.emojiBtn.alpha = 1
        }
    }
    
    @objc func onSend() {
        viewModel.sendText(tv.text)
        tv.text = nil
        tv.endEditing(true)
    }
    
    @objc func onVoice() {
        tv.endEditing(true)
        DispatchQueue.main.async {
            self.viewModel.showVoiceSubject.onNext(true)
        }
    }
    
    @objc func onVideo() {
        RTCManager.call(viewModel.userId)
    }
    
    @objc func onGift() {
        tv.endEditing(true)
        DispatchQueue.main.async {
            self.viewModel.showGiftSubject.onNext(true)
        }
    }
    
    @objc func onImage() {
        tv.endEditing(true)
        
        parentViewController?.pickPhoneImage(isEdit: false, completion: { [weak self] result in
            if let img = result.image {
                let vc = IMChatSendImageVC(image: img)
                vc.delegate = self
                let navc = UINavigationController(rootViewController: vc)
                self?.parentViewController?.present(navc, animated: true)
            }
        })
    }
    
    func setupVM() {
        tv.rx.text.subscribe(onNext: { [weak self] _ in
            self?.inputChanged()
        }).disposed(by: disposeBag)
    }
    
    func inputChanged() {
        if let text = tv.text, !text.isEmpty {
            placeholder.isHidden = true
            emojiBtn.snp.remakeConstraints { make in
                make.width.height.equalTo(40)
                make.trailing.equalTo(sendBtn.snp.leading).offset(-4)
                make.bottom.equalToSuperview().inset(8)
            }
            UIView.animate(withDuration: 0.25) {
                self.giftBtn.alpha = 0
                self.videoBtn.alpha = 0
                self.imgBtn.alpha = 0
                self.sendBtn.alpha = 1
            }
        }else {
            placeholder.isHidden = false
            if toolType == .rtc {
                emojiBtn.snp.remakeConstraints { make in
                    make.width.height.equalTo(40)
                    make.trailing.equalToSuperview().inset(8)
                    make.bottom.equalToSuperview().inset(8)
                }
            }else if toolType == .service {
                emojiBtn.snp.remakeConstraints { make in
                    make.width.height.equalTo(40)
                    make.trailing.equalTo(imgBtn.snp.leading)
                    make.bottom.equalToSuperview().inset(8)
                }
            }else {
                emojiBtn.snp.remakeConstraints { make in
                    make.width.height.equalTo(40)
                    make.trailing.equalTo(giftBtn.snp.leading)
                    make.bottom.equalToSuperview().inset(8)
                }
            }
            
            UIView.animate(withDuration: 0.25) {
                self.videoBtn.alpha = 1
                self.giftBtn.alpha = 1
                self.imgBtn.alpha = 1
                self.sendBtn.alpha = 0
            }
        }
        let fixedWidth = tv.frame.size.width
        let newSize = tv.sizeThatFits(.init(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var h = newSize.height
        if h < 40 {
            h = 40
        }
        if h > 180 {
            h = 180
        }
        
        if inputHeightIsChanged(newHeight: h) {
            tvHeightConstraint?.update(offset: h)
            DispatchQueue.main.async {
                self.viewModel.inputHeightChangeSubject.onNext(true)
            }
        }
    }
    
    private func inputHeightIsChanged(newHeight: Double) -> Bool {
        let distance = abs(newHeight - tv.height)
        return distance > 10
    }
}

extension IMChatToolView {
    func setupView() {
        let line = UIView()
        line.backgroundColor = .background.separator
        addSubview(line)
        line.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        if toolType == .rtc {
            addSubview(emojiBtn)
            emojiBtn.snp.makeConstraints { make in
                make.width.height.equalTo(40)
                make.trailing.equalToSuperview().inset(8)
                make.bottom.equalToSuperview().inset(8)
            }
            addSubview(keyboardBtn)
            keyboardBtn.snp.makeConstraints { make in
                make.center.equalTo(emojiBtn)
                make.width.height.equalTo(emojiBtn)
            }
            addSubview(tv)
            tv.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(16).priority(.high)
                make.bottom.equalToSuperview().inset(8).priority(.high)
                self.tvHeightConstraint = make.height.equalTo(40).constraint
                make.trailing.equalTo(emojiBtn.snp.leading).offset(-4).priority(.high)
                make.top.equalToSuperview().offset(8).priority(.high)
            }
            
        }else if toolType == .service {
            addSubview(imgBtn)
            imgBtn.snp.makeConstraints { make in
                make.width.height.equalTo(40)
                make.trailing.equalToSuperview().inset(8)
                make.bottom.equalToSuperview().inset(8)
            }
            
            addSubview(emojiBtn)
            emojiBtn.snp.makeConstraints { make in
                make.centerY.width.height.equalTo(imgBtn)
                make.trailing.equalTo(imgBtn.snp.leading)
            }
            
            addSubview(keyboardBtn)
            keyboardBtn.snp.makeConstraints { make in
                make.center.equalTo(emojiBtn)
                make.width.height.equalTo(emojiBtn)
            }
            
            addSubview(voiceBtn)
            voiceBtn.snp.makeConstraints { make in
                make.centerY.width.height.equalTo(imgBtn)
                make.leading.equalToSuperview().offset(8)
            }
            
            addSubview(tv)
            tv.snp.makeConstraints { make in
                make.leading.equalTo(voiceBtn.snp.trailing).offset(4).priority(.high)
                make.bottom.equalToSuperview().inset(8).priority(.high)
                self.tvHeightConstraint = make.height.equalTo(40).constraint
                make.trailing.equalTo(emojiBtn.snp.leading).offset(-4).priority(.high)
                make.top.equalToSuperview().offset(8).priority(.high)
            }
        } else {
            addSubview(videoBtn)
            videoBtn.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(0)
                make.trailing.equalToSuperview().inset(8)
                make.bottom.equalToSuperview().inset(8)
            }
            addSubview(giftBtn)
            giftBtn.snp.makeConstraints { make in
                make.centerY.height.equalTo(videoBtn)
                make.width.equalTo(40)
                make.trailing.equalTo(videoBtn.snp.leading)
            }
            
            addSubview(emojiBtn)
            emojiBtn.snp.makeConstraints { make in
                make.centerY.height.equalTo(videoBtn)
                make.width.equalTo(40)
                make.trailing.equalTo(giftBtn.snp.leading)
            }
            
            addSubview(keyboardBtn)
            keyboardBtn.snp.makeConstraints { make in
                make.center.equalTo(emojiBtn)
                make.width.height.equalTo(emojiBtn)
            }
            
            addSubview(voiceBtn)
            voiceBtn.snp.makeConstraints { make in
                make.centerY.height.equalTo(videoBtn)
                make.width.equalTo(40);
                make.leading.equalToSuperview().offset(8)
            }
            
            addSubview(tv)
            tv.snp.makeConstraints { make in
                make.leading.equalTo(voiceBtn.snp.trailing).offset(4).priority(.high)
                make.bottom.equalToSuperview().inset(8).priority(.high)
                self.tvHeightConstraint = make.height.equalTo(40).constraint
                make.trailing.equalTo(emojiBtn.snp.leading).offset(-4).priority(.high)
                make.top.equalToSuperview().offset(8).priority(.high)
            }
        }
        
        addSubview(sendBtn)
        sendBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(13)
            make.height.equalTo(30)
        }
        
        addSubview(placeholder)
        placeholder.snp.makeConstraints { make in
            make.leading.equalTo(tv).offset(12)
            make.centerY.equalTo(tv)
        }
    }
}

extension IMChatToolView: UITextViewDelegate {

    func textViewDidEndEditing(_ textView: UITextView) {
        tv.inputView = nil
        UIView.animate(withDuration: 0.25) {
            self.keyboardBtn.alpha = 0
            self.emojiBtn.alpha = 1
        }
    }
}


extension IMChatToolView: IMChatEmojiViewDelegate {
    func chatEmojiViewOnDelete() {
        tv.deleteBackward()
    }
    
    func chatEmojiViewOnEmoji(_ emoji: String) {
        tv.insertText(emoji)
    }
}

extension IMChatToolView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

extension IMChatToolView: IMChatSendImageDelegate {
    func chatSendImgOnSend(_ image: UIImage) {
        viewModel.sendImage(image)
    }
}

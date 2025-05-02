//
//  RTCContentView.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/31.
//

import UIKit
import RxSwift
import Kingfisher
import HyphenateChat
class RTCContentView: UIView {
    let disposeBag = DisposeBag()
    let viewModel: RTCVM
    let chatViewModel: IMChatVM
    let chatHeight: CGFloat = 120
    
    private var messages: [IMChatMsgModel] = []
    
    init(viewModel: RTCVM, chatViewModel: IMChatVM) {
        self.viewModel = viewModel
        self.chatViewModel = chatViewModel
        super.init(frame: .zero)
        setupView()
        setupVM()
    }
    
    deinit {
        IMManager.markReaded(conversation: chatViewModel.conversation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    lazy var acceptBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "msg_call_accept"), for: .normal)
        btn.addTarget(self, action: #selector(onAccept), for: .touchUpInside)
        return btn
    }()
    lazy var hangupBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "msg_call_hangup"), for: .normal)
        btn.addTarget(self, action: #selector(onHangup), for: .touchUpInside)
        return btn
    }()
    lazy var scaleBt: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "msg_call_hangup"), for: .normal)
        btn.addTarget(self, action: #selector(onscale), for: .touchUpInside)
        return btn
    }()
    
    lazy var chargeLabel:UILabel = {
       let label = UILabel()
        if !UserCenter.loginUser.isHost{
            label.text = "主播聊天\(RTCManager.share.remoteUser.otherInfo.charge!)金币/分钟,将在接通后开始收费"
        }else{
            label.text = "主播聊天\(String(describing: UserCenter.loginUser.userDetail?.user.charge!))金币/分钟,将在接通后开始收费"
        }
        
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        return label
    }()
    
    
    lazy var chatBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.setTitle("聊天", for: .normal)
        btn.setImage(.init(named: "msg_call_chat"), for: .normal)
        btn.centerTextAndImage(imageAboveText: true, spacing: 8)
        btn.addTarget(self, action: #selector(onChat), for: .touchUpInside)
        return btn
    }()
    lazy var frontBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.setTitle("旋转", for: .normal)
        btn.setImage(.init(named: "msg_call_front"), for: .normal)
        btn.centerTextAndImage(imageAboveText: true, spacing: 8)
        btn.addTarget(self, action: #selector(onFront), for: .touchUpInside)
        return btn
    }()
    
    lazy var cameraBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.setTitle("摄像头", for: .normal)
        btn.setImage(.init(named: "msg_call_camera_open"), for: .normal)
        btn.setImage(.init(named: "msg_call_camera_off"), for: .selected)
        btn.centerTextAndImage(imageAboveText: true, spacing: 12)
        btn.addTarget(self, action: #selector(onCamera), for: .touchUpInside)
        return btn
    }()
    lazy var micBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.setTitle("麦克风", for: .normal)
        btn.setImage(.init(named: "msg_call_mic_open"), for: .normal)
        btn.setImage(.init(named: "msg_call_mic_off"), for: .selected)
        btn.centerTextAndImage(imageAboveText: true, spacing: 12)
        btn.addTarget(self, action: #selector(onMic), for: .touchUpInside)
        return btn
    }()
    lazy var giftBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.setTitle("礼物", for: .normal)
        btn.setImage(.init(named: "msg_call_gift"), for: .normal)
        btn.centerTextAndImage(imageAboveText: true, spacing: 12)
        btn.addTarget(self, action: #selector(onGift), for: .touchUpInside)
        return btn
    }()
    lazy var avatar: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    lazy var avatarView: UIView = {
        let view = UIView()
        let bg = UIImageView(image: UIImage.init(named: "msg_call_avatar_bg"))
        view.addSubview(bg)
        bg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(138)
        }
        avatar.layerCornerRadius = 69
        return view
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .medium16
        label.textAlignment = .center
        return label
    }()
    lazy var callBackView: UIView = {
        let callback = UIView()
        callback.layer.cornerRadius = 32
        callback.layer.masksToBounds = true
        
        
        let user = RTCManager.share.remoteUser.otherInfo
        ///主播视角，展示背景图
        if UserCenter.loginUser.isHost {
            let bg = UIImageView(image: .init(named: "msg_call_bg2"))
            bg.contentMode = .scaleToFill
            callback.addSubview(bg)
            bg.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            if let url = user.backgroundImg {
                bg.kf.setImage(with: URL(string: url))
            }
        }else { ///用户视角，展示背景图或者播放主播主页视频
            let bg = UIImageView(image: .init(named: "msg_call_bg"))
            bg.contentMode = .scaleToFill
            callback.addSubview(bg)
            bg.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            if let url = user.backgroundImg {
                bg.kf.setImage(with: URL(string: url))
            }
        }
        
        let backIV = UIImageView(image: UIImage(named: "callBackIV"))
        callback.addSubview(backIV)
        backIV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return callback
    }()
    lazy var waitingBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 10, weight: .medium)
        btn.isEnabled = false
        btn.backgroundColor = .black.alpha(0.2)
        btn.contentEdgeInsets = .init(horizontal: 36, vertical: 0)
        return btn
    }()
    lazy var chatTool: IMChatToolView = {
        let tool = IMChatToolView(viewModel: chatViewModel, toolType: .rtc)
        tool.backgroundColor = .white
        tool.alpha = 0
        return tool
    }()
    lazy var list: UITableView = {
        let list = UITableView(frame: .zero, style: .plain)
        list.keyboardDismissMode = .onDrag
        list.delegate = self
        list.dataSource = self
        list.rowHeight = UITableView.automaticDimension
        list.estimatedRowHeight = 80
        list.showsVerticalScrollIndicator = false
        list.register(cellWithClass: IMChatTextRecCell.self)
        list.register(cellWithClass: IMChatTextSendCell.self)
        list.register(cellWithClass: IMChatGiftSendCell.self)
        list.register(cellWithClass: IMChatGiftRecCell.self)
        list.separatorStyle = .none
        list.backgroundColor = .clear
        list.contentInset = .init(top: chatHeight, left: 0, bottom: 0, right: 0)
        return list
    }()
    
    func scrollToBottom(animate: Bool) {
        let count = messages.count
        let row = count - 1
        if row < 0 { return }
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: row, section: 0)
            self.list.scrollToRow(at: indexPath, at: .bottom, animated: animate)
        }
    }
    func reloadMessages(animate: Bool) {
        messages = chatViewModel.messages.filter({ $0.isEnabledRTC })
        list.reloadData()
        scrollToBottom(animate: animate)
    }
    private func setupVM() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        chatViewModel.userSubject.subscribe(onNext: { [weak self] _ in
            self?.list.reloadData()
        }).disposed(by: disposeBag)
        
        chatViewModel.messagesFirstLoadSubject.subscribe(onNext: { [weak self] _ in
            self?.reloadMessages(animate: false)
        }).disposed(by: disposeBag)
        
        chatViewModel.messagesChangeSubject.subscribe(onNext: { [weak self] _ in
            self?.reloadMessages(animate: true)
        }).disposed(by: disposeBag)
        
        viewModel.callStateChanged.subscribe(onNext: { [weak self] _ in
            self?.updateCallUI()
        }).disposed(by: disposeBag)
        
        viewModel.durationChanged.subscribe(onNext: { [weak self] _ in
            self?.updateTimeLabel()
        }).disposed(by: disposeBag)
        
        RTCManager.micSubject.subscribe(onNext: { [weak self] _ in
            self?.updateMicUI()
        }).disposed(by: disposeBag)
        
        RTCManager.cameraSubject.subscribe(onNext: { [weak self] _ in
            self?.updateCameraUI()
        }).disposed(by: disposeBag)
    }
    
    func updateTimeLabel() {
        let m = viewModel.duration / 60
        let s = viewModel.duration % 60
        timeLabel.text = String(format: "%02d:%02d", m, s)
    }
    
    @objc func onTap() {
        chatTool.tv.endEditing(true)
    }
    private func setupView() {
        if viewModel.operateType == .send {
            setup_send()
        }else {
            setup_receive()
        }
        addSubview(chatTool)
        chatTool.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
        }
        
        addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onTap)))
        
        updateMicUI()
        updateCameraUI()
    }
    private func setup_send() {
        addSubview(callBackView)
        callBackView.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(463)
            make.center.equalToSuperview()
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(500)
            make.height.equalTo(24)
            make.left.right.equalTo(0)
        }
        
        addSubview(hangupBtn)
         hangupBtn.snp.makeConstraints { make in
             make.centerX.equalToSuperview()
             make.top.equalTo(nameLabel.snp.bottom).offset(5)
             make.width.equalTo(120)
             make.height.equalTo(60)
         }
         
         addSubview(acceptBtn)
         acceptBtn.snp.makeConstraints { make in
             make.left.equalTo(207)
             make.top.equalTo(nameLabel.snp.bottom).offset(5)
             make.width.equalTo(120)
             make.height.equalTo(60)
         }
        acceptBtn.isHidden = true
        addSubview(chargeLabel)
        chargeLabel.snp.makeConstraints { make in
            make.top.equalTo(hangupBtn.snp.bottom).offset(5);
            make.width.equalTo(343)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
        }

        let user = RTCManager.share.remoteUser
        
        nameLabel.text = "正在邀请\(user?.otherInfo.name ?? "")视频通话..."
//        addSubview(hangupBtn)
//        hangupBtn.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(8)
//        }
//        
//        addSubview(chatBtn)
//        chatBtn.snp.makeConstraints { make in
//            make.centerY.equalTo(hangupBtn)
//            make.trailing.equalTo(hangupBtn.snp.leading).offset(-50)
//        }
//        
//        addSubview(giftBtn)
//        giftBtn.snp.makeConstraints { make in
////            make.centerX.equalTo(frontBtn)
////            make.centerY.equalTo(micBtn)
//            make.centerY.equalTo(hangupBtn)
//            make.left.equalTo(hangupBtn.snp.right).offset(50)
//        }
//        
//        addSubview(micBtn)
//        micBtn.snp.makeConstraints { make in
//            make.centerX.equalTo(giftBtn)
//            make.bottom.equalTo(giftBtn.snp.top).offset(-24)
//            
//        }
//        
//        
//        addSubview(cameraBtn)
//        cameraBtn.snp.makeConstraints { make in
////            make.centerX.equalTo(chatBtn)
////            make.centerY.equalTo(micBtn)
//            make.centerX.equalTo(micBtn)
//            make.bottom.equalTo(micBtn.snp.top).offset(-24)
//        }
//        
//        
//        
//        addSubview(frontBtn)
//        frontBtn.snp.makeConstraints { make in
//            make.centerX.equalTo(cameraBtn)
//            make.bottom.equalTo(cameraBtn.snp.top).offset(-300)
//        }
//        
//        addSubview(list)
//        list.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.bottom.equalTo(micBtn.snp.top)
//            make.height.equalTo(chatHeight)
//        }
//        
//        let container = UIView()
//        container.isUserInteractionEnabled = false
//        addSubview(container)
//        container.snp.makeConstraints { make in
//            make.top.leading.trailing.equalToSuperview()
//            make.bottom.equalTo(micBtn.snp.top)
//        }
//        
//        container.addSubview(avatarView)
//        avatarView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.height.equalTo(200)
//        }
//        
//        container.addSubview(nameLabel)
//        nameLabel.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(16)
//            make.top.equalTo(avatarView.snp.bottom).offset(10)
//        }
//        
//        container.addSubview(waitingBtn)
//        waitingBtn.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(nameLabel.snp.bottom).offset(10)
//            make.height.equalTo(20)
//        }
//        waitingBtn.layerCornerRadius = 10
////        if !UserCenter.loginUser.isHost {
//            container.addSubview(chargeLabel)
//            chargeLabel.snp.makeConstraints { make in
//                make.top.equalTo(waitingBtn.snp_bottomMargin);
//                make.width.equalTo(500)
//                make.height.equalTo(30)
//                make.centerX.equalTo(waitingBtn.snp.centerX)
//            }
////        }
//        let user = RTCManager.share.remoteUser
//        nameLabel.text = user?.otherInfo.name
//        avatar.kf.setImage(with: URL(string: user?.otherInfo.avatar))
//        waitingBtn.setTitle("正在等待对方接听...", for: .normal)
    }
    private func setup_receive() {
        addSubview(callBackView)
        callBackView.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(463)
            make.center.equalToSuperview()
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(500)
            make.height.equalTo(24)
            make.left.right.equalTo(0)
        }
        
        addSubview(hangupBtn)
         hangupBtn.snp.makeConstraints { make in
             make.left.equalTo(48)
             make.top.equalTo(nameLabel.snp.bottom).offset(5)
             make.width.equalTo(120)
             make.height.equalTo(60)
         }
         
         addSubview(acceptBtn)
         acceptBtn.snp.makeConstraints { make in
             make.left.equalTo(207)
             make.top.equalTo(nameLabel.snp.bottom).offset(5)
             make.width.equalTo(120)
             make.height.equalTo(60)
         }
        addSubview(chargeLabel)
        chargeLabel.snp.makeConstraints { make in
            make.top.equalTo(hangupBtn.snp.bottom).offset(5);
            make.width.equalTo(343)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
        }

        let user = RTCManager.share.remoteUser
        
        nameLabel.text = "\(user?.otherInfo.name ?? "")邀请你视频通话..."

    }
    
    private func updateCallUI() {
        avatarView.isHidden = true
        nameLabel.isHidden = true
        waitingBtn.isHidden = true
        acceptBtn.isHidden = true
        callBackView.isHidden = true
        callBackView.removeFromSuperview()
        chargeLabel.isHidden = true;
//        if viewModel.operateType != .receive {
//            return
//        }
        
        hangupBtn.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(8)
        }
        
        addSubview(chatBtn)
        chatBtn.snp.makeConstraints { make in
            make.centerY.equalTo(hangupBtn)
            make.trailing.equalTo(hangupBtn.snp.leading).offset(-50)
        }
        addSubview(giftBtn)
        giftBtn.snp.makeConstraints{ make in
            make.centerY.equalTo(hangupBtn)
            make.left.equalTo(hangupBtn.snp.right).offset(50)
        }
        addSubview(micBtn)
        micBtn.snp.makeConstraints { make in
            make.centerX.equalTo(giftBtn)
            make.bottom.equalTo(giftBtn.snp.top).offset(-24)
            
        }
        addSubview(cameraBtn)
        cameraBtn.snp.makeConstraints { make in
//            make.centerX.equalTo(chatBtn)
//            make.centerY.equalTo(micBtn)
            make.centerX.equalTo(micBtn)
            make.bottom.equalTo(micBtn.snp.top).offset(-24)
        }
        

        addSubview(frontBtn)
        frontBtn.snp.makeConstraints { make in
            make.centerX.equalTo(cameraBtn)
            make.bottom.equalTo(cameraBtn.snp.top).offset(-300)
        }
        
        addSubview(list)
        list.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(micBtn.snp.top)
            make.height.equalTo(chatHeight)
        }
        sendSubviewToBack(list)
        
//        addSubview(scaleBt)
//        scaleBt.snp.remakeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.height.equalTo(100)
//        }
  
    }
    
    private func updateMicUI() {
        micBtn.isSelected = !RTCManager.share.isOpenMic
    }
    private func updateCameraUI() {
        if RTCManager.share.isOpenCamera {
            RTCManager.share.localView.isHidden = false
            cameraBtn.isSelected = false
        }else {
            RTCManager.share.localView.isHidden = true
            cameraBtn.isSelected = true
        }
    }
}

extension RTCContentView {
    @objc func onAccept() {
        RTCManager.acceptCall(viewModel.userId)
    }
    @objc func onHangup() {
        ///通话中, 挂断
        if viewModel.isInCall {
            RTCManager.hangupCall(viewModel.userId)
            return
        }
        ///接听中
        if viewModel.operateType == .send {
            RTCManager.cancelCall() ///如果是发起方,取消
        }else {
            RTCManager.rejectCall(viewModel.userId) ///如果是接受方,拒绝
        }
    }
    @objc func onChat() {
        chatTool.tv.becomeFirstResponder()
    }
    @objc func onFront() {
        RTCManager.changeCameraFront()
    }
    @objc func onCamera() {
        RTCManager.switchCamera()
    }
    @objc func onMic() {
        RTCManager.switchMic()
    }
    @objc func onGift() {
        parentViewController?.presentGiftBy(chat: chatViewModel)
    }
    
    @objc func onscale(){
//        let vc:RTCCallController = parentViewController as! RTCCallController
//        JPSuspensionEntrance.sharedInstance().pop(vc)
    }
}

///键盘处理
extension RTCContentView {
    @objc func keyboardWillShow(notification: NSNotification) {
        if chatTool.tv.isFirstResponder == false { return }
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        UIView.animate(withDuration: 0.25) {
            self.chatTool.alpha = 1
            self.chatTool.transform = .init(translationX: 0, y: -keyboardSize.height)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.25) {
            self.chatTool.alpha = 0
            self.chatTool.transform = .identity
        }
    }
}

extension RTCContentView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.msg.body.type == .custom {
            let body = message.msg.body as! EMCustomMessageBody
            if body.event == Constants.im.giftEvent {
                if message.msg.isSelf {
                    let cell = tableView.dequeueReusableCell(withClass: IMChatGiftSendCell.self)
                    cell.selectionStyle = .none
                    cell.message = message
                    return cell
                }else {
                    let cell = tableView.dequeueReusableCell(withClass: IMChatGiftRecCell.self)
                    cell.selectionStyle = .none
                    cell.message = message
                    cell.user = chatViewModel.user
                    return cell
                }
            }
        }
        if message.msg.isSelf {
            let cell = tableView.dequeueReusableCell(withClass: IMChatTextSendCell.self)
            cell.selectionStyle = .none
            cell.message = message
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withClass: IMChatTextRecCell.self)
            cell.selectionStyle = .none
            cell.message = message
            cell.user = chatViewModel.user
            return cell
        }
    }
}

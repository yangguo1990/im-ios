//
//  IMChatVC.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/14.
//

import UIKit
import HyphenateChat
import RxSwift

class IMChatVC: BaseVC {
    let viewModel: IMChatVM
    let disposeBag = DisposeBag()
    private var voiceIsShowing: Bool = false
    init(chatId: String, chatType: EMChatType = .chat) {
        self.viewModel = .init(chatId: chatId, chatType: chatType)
        super.init(nibName: nil, bundle: nil)
    }
    @objc init(userId: Int) {
        self.viewModel = .init(chatId: "im\(userId)", chatType: .chat)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var list: UITableView = {
        let list = UITableView(frame: .zero, style: .plain)
        list.keyboardDismissMode = .onDrag
        list.delegate = self
        list.dataSource = self
        list.rowHeight = UITableView.automaticDimension
        list.estimatedRowHeight = 68
        list.showsVerticalScrollIndicator = false
        list.register(cellWithClass: IMChatTextRecCell.self)
        list.register(cellWithClass: IMChatTextSendCell.self)
        list.register(cellWithClass: IMChatNoteCell.self)
        list.register(cellWithClass: IMChatTimeCell.self)
        list.register(cellWithClass: IMChatVoiceRecCell.self)
        list.register(cellWithClass: IMChatVoiceSendCell.self)
        list.register(cellWithClass: IMChatCallRecCell.self)
        list.register(cellWithClass: IMChatCallSendCell.self)
        list.register(cellWithClass: IMChatImgSendCell.self)
        list.register(cellWithClass: IMChatImgRecCell.self)
        list.register(cellWithClass: IMChatGiftSendCell.self)
        list.register(cellWithClass: IMChatGiftRecCell.self)
        list.separatorStyle = .none
        return list
    }()
    
    lazy var chatTool: IMChatToolView = {
        let type: IMChatToolType = viewModel.isService ? .service : .c2c
        let tool = IMChatToolView(viewModel: viewModel, toolType: type)
        return tool
    }()
    
    lazy var voiceView: IMVoiceView = {
        let view = IMVoiceView(viewModel: viewModel)
        view.alpha = 0
        return view
    }()
    
    lazy var firstLoadView: UIView = {
        let view = UIView()
        view.backgroundColor = .background.main
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavigationBarHidden = false
        if !viewModel.isService {
            navigationItem.rightBarButtonItem = .init(image: .init(named: "msg_video")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(onMore))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        IMManager.markReaded(conversation: viewModel.conversation)
        viewModel.stopPlayingCurrentSound()
    }
}

extension IMChatVC {
    func updateUser() {
        navigationItem.title = viewModel.user?.showName
    }
    
    func scrollToBottom(animate: Bool) {
        let count = viewModel.messages.count
        let row = count - 1
        if row < 0 { return }
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: row, section: 0)
            self.list.scrollToRow(at: indexPath, at: .bottom, animated: animate)
        }
    }
}

extension IMChatVC {
    @objc func onMore() {
        RTCManager.call(viewModel.userId)
    }
    
    func showGift() {
        presentGiftBy(chat: viewModel)
    }
    
    func hideVoice() {
        if !voiceIsShowing { return }
        voiceIsShowing = false
        voiceView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
        list.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(chatTool.snp.top)
        }
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
            self.voiceView.alpha = 0
        }
    }
    
    func showVoice() {
        if voiceIsShowing { return }
        voiceIsShowing = true
        voiceView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(260 + view.safeAreaInsets.bottom)
        }
        list.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(voiceView.snp.top)
        }
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
            self.voiceView.alpha = 1
        } completion: { _ in
            self.scrollToBottom(animate: true)
        }
    }
}

///键盘处理
extension IMChatVC {
    @objc func keyboardWillShow(notification: NSNotification) {
        if chatTool.tv.isFirstResponder == false { return }

        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        chatTool.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-keyboardSize.height)
        }
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.scrollToBottom(animate: true)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        chatTool.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        } completion: { _ in

        }
    }
}

extension IMChatVC {
    override func setupVM() {
        super.setupVM()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        viewModel.inputHeightChangeSubject.subscribe(onNext: { [weak self] _ in
            self?.scrollToBottom(animate: true)
        }).disposed(by: disposeBag)
        
        viewModel.userSubject.subscribe(onNext: { [weak self] _ in
            self?.updateUser()
            self?.list.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.messagesFirstLoadSubject.subscribe(onNext: { [weak self] _ in
            self?.list.reloadData()
            self?.scrollToBottom(animate: false)
            DispatchQueue.main.async {
                self?.firstLoadView.removeFromSuperview()
            }
        }).disposed(by: disposeBag)
        
        viewModel.messagesChangeSubject.subscribe(onNext: { [weak self] _ in
            self?.list.reloadData()
            self?.scrollToBottom(animate: true)
            if self?.firstLoadView.superview != nil {
                self?.firstLoadView.removeFromSuperview()
            }
        }).disposed(by: disposeBag)
        
        viewModel.showGiftSubject.subscribe(onNext: { [weak self] _ in
            self?.showGift()
        }).disposed(by: disposeBag)
        
        viewModel.showVoiceSubject.subscribe(onNext: { [weak self] _ in
            self?.showVoice()
        }).disposed(by: disposeBag)
        
        viewModel.playGiftAnimate.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            GiftAnimatePlayer.play(path: $0, inView: self.view)
        }).disposed(by: disposeBag)
    }
    
    override func setupView() {
        super.setupView()
        view.addSubview(chatTool)
        chatTool.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        view.addSubview(voiceView)
        voiceView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0)
        }

        view.addSubview(list)
        list.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(chatTool.snp.top)
        }
        view.addSubview(firstLoadView)
        firstLoadView.snp.makeConstraints { make in
            make.edges.equalTo(list)
        }
    }
}

extension IMChatVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = viewModel.messages[indexPath.row]
        if message.isShowTime {
            let cell = tableView.dequeueReusableCell(withClass: IMChatTimeCell.self)
            cell.selectionStyle = .none
            cell.message = message
            return cell
        }
        
        if message.msg.body.type == .text {
            if message.msg.isSelf {
                let cell = tableView.dequeueReusableCell(withClass: IMChatTextSendCell.self)
                cell.selectionStyle = .none
                cell.message = message
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withClass: IMChatTextRecCell.self)
                cell.selectionStyle = .none
                cell.message = message
                cell.user = viewModel.user
                return cell
            }
        }else if message.msg.body.type == .voice {
            if message.msg.isSelf {
                let cell = tableView.dequeueReusableCell(withClass: IMChatVoiceSendCell.self)
                cell.selectionStyle = .none
                cell.message = message
                cell.viewModel = viewModel
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withClass: IMChatVoiceRecCell.self)
                cell.selectionStyle = .none
                cell.message = message
                cell.user = viewModel.user
                cell.viewModel = viewModel
                return cell
            }
        }else if message.msg.body.type == .custom {
            let body = message.msg.body as! EMCustomMessageBody
            if body.event == Constants.im.callEvent {
                if message.msg.isSelf {
                    let cell = tableView.dequeueReusableCell(withClass: IMChatCallSendCell.self)
                    cell.selectionStyle = .none
                    cell.message = message
                    cell.viewModel = viewModel
                    return cell
                }else {
                    let cell = tableView.dequeueReusableCell(withClass: IMChatCallRecCell.self)
                    cell.selectionStyle = .none
                    cell.message = message
                    cell.user = viewModel.user
                    cell.viewModel = viewModel
                    return cell
                }
            }else if body.event == Constants.im.giftEvent {
                if message.msg.isSelf {
                    let cell = tableView.dequeueReusableCell(withClass: IMChatGiftSendCell.self)
                    cell.selectionStyle = .none
                    cell.message = message
                    return cell
                }else {
                    let cell = tableView.dequeueReusableCell(withClass: IMChatGiftRecCell.self)
                    cell.selectionStyle = .none
                    cell.message = message
                    cell.user = viewModel.user
                    return cell
                }
            }
        }else if message.msg.body.type == .image {
            if message.msg.isSelf {
                let cell = tableView.dequeueReusableCell(withClass: IMChatImgSendCell.self)
                cell.selectionStyle = .none
                cell.message = message
                cell.viewModel = viewModel
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withClass: IMChatImgRecCell.self)
                cell.selectionStyle = .none
                cell.message = message
                cell.user = viewModel.user
                cell.viewModel = viewModel
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withClass: IMChatNoteCell.self)
        cell.selectionStyle = .none
        cell.message = message
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hideVoice()
    }
}

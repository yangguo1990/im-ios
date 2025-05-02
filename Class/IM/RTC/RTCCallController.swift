//
//  RTCCallController.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/16.
//

import UIKit
import CallAPI
import RxSwift
import AVFAudio

class RTCCallController: BaseVC {
    let disposeBag = DisposeBag()
    let viewModel: RTCVM
    
    private var isSmallLocal = true
    
    lazy var bgView: RTCBackgroundView = {
        let view = RTCBackgroundView(viewModel: viewModel)
        return view
    }()
    
    lazy var contentView: RTCContentView = {
        let view = RTCContentView(viewModel: viewModel, chatViewModel: RTCManager.share.chatViewModel)
        return view
    }()
    
    lazy var audioPlayer: AVAudioPlayer = {
        let name = viewModel.operateType == .send ? "video_chat_tip_sender" : "video_chat_tip_receiver"
        let url = Bundle.main.url(forResource: name, withExtension: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer.numberOfLoops = -1
        audioPlayer.prepareToPlay()
        return audioPlayer
    }()
    
    init(userId: Int, type: RTCOperateType) {
        viewModel = .init(userId: userId, type: type)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        let fu = FUManager.share()
        fu?.destoryItems()
    }
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        contentView.chatTool.tv.endEditing(true)
        let duration = 0.35
        if gesture.direction == .left {
            if self.contentView.transform == .identity {
                UIView.animate(withDuration: duration) {
                    self.contentView.transform = .init(translationX: -self.view.width, y: 0)
                }
            }else {
                contentView.transform = .init(translationX: view.width, y: 0)
                UIView.animate(withDuration: duration) {
                    self.contentView.transform = .identity
                }
            }
        } else if gesture.direction == .right {
            if self.contentView.transform == .identity {
                UIView.animate(withDuration: duration) {
                    self.contentView.transform = .init(translationX: self.view.width, y: 0)
                }
            }else {
                contentView.transform = .init(translationX: -view.width, y: 0)
                UIView.animate(withDuration: duration) {
                    self.contentView.transform = .identity
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        leftSwipeGesture.direction = .left
        view.addGestureRecognizer(leftSwipeGesture)
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        rightSwipeGesture.direction = .right
        view.addGestureRecognizer(rightSwipeGesture)
        let fu = FUManager.share()
        fu?.loadFilter()
        fu?.setAsyncTrackFaceEnable(false)
        audioPlayer.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 在页面即将显示时禁用屏幕自动锁定
        UIApplication.shared.isIdleTimerDisabled = true
//        JPSuspensionEntrance.sharedInstance().navCtr = self.navigationController
//        JPSuspensionEntrance.sharedInstance().setupSuspensionView(withTargetVC: self, suspensionXY: CGPointMake(100, 100))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 在页面即将消失时重新启用屏幕自动锁定
        UIApplication.shared.isIdleTimerDisabled = false
    }
}

extension RTCCallController {
    override func setupVM() {
        super.setupVM()
        
        RTCManager.endCallSubject.subscribe(onNext: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
//            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        RTCManager.connectedSubject.subscribe(onNext: { [weak self] _ in
            self?.audioPlayer.stop()
            self?.viewModel.callConnected()
        }).disposed(by: disposeBag)
        
        viewModel.topupAlert.subscribe(onNext: { [weak self] in
            self?.topupAlert($0)
        }).disposed(by: disposeBag)
        
        RTCManager.share.chatViewModel.playGiftAnimate.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            GiftAnimatePlayer.play(path: $0, inView: self.view)
        }).disposed(by: disposeBag)
    }
    func topupAlert(_ message: String) {
        alert(title: "充值", message: message, .cancel("取消", nil), .done("确定", { [weak self] in
            self?.gotoTopup()
        }))
    }
    func gotoTopup() {
        modalToTopupController()
    }
    override func setupView() {
        super.setupView()
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let remoteView = RTCManager.share.remoteView
        view.addSubview(remoteView)
        remoteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let localView = RTCManager.share.localView
        localView.layerCornerRadius = 12
        view.addSubview(localView)
        localView.snp.makeConstraints { make in
            make.width.equalTo(RTCManager.localViewW)
            make.height.equalTo(RTCManager.localViewH)
            make.left.equalTo(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let tapBtn = UIButton()
        tapBtn.addTarget(self, action: #selector(onLocalViewTap), for: .touchUpInside)
        view.addSubview(tapBtn)
        tapBtn.snp.makeConstraints { make in
            make.width.equalTo(RTCManager.localViewW)
            make.height.equalTo(RTCManager.localViewH)
            make.left.equalTo(16)
//            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    
    @objc func onLocalViewTap() {
        isSmallLocal = !isSmallLocal
        let remoteView = RTCManager.share.remoteView
        let localView = RTCManager.share.localView
        if isSmallLocal {
            remoteView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
            localView.snp.remakeConstraints { make in
                make.width.equalTo(RTCManager.localViewW)
                make.height.equalTo(RTCManager.localViewH)
                make.left.equalTo(16)
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            }
            localView.layerCornerRadius = 12
            remoteView.layerCornerRadius = 0
        }else {
            localView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
            remoteView.snp.remakeConstraints { make in
                make.width.equalTo(RTCManager.localViewW)
                make.height.equalTo(RTCManager.localViewH)
                make.left.equalTo(16)
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            }
            localView.layerCornerRadius = 0
            remoteView.layerCornerRadius = 12
        }
        view.exchangeSubview(at: 1, withSubviewAt: 2)
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

//extension RTCCallController :JPSuspensionEntranceProtocol{
//    func jp_isHideNavigationBar() -> Bool {
//        return true
//    }
//    
//    
//}


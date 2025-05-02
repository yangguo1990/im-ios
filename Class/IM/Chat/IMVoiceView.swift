//
//  IMVoiceView.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/30.
//

import UIKit
import AVFAudio

enum IMRecordVoiceStatus {
    case begin
    case end
    case cancel
}

class IMVoiceView: UIView {
    let cancelDistance: CGFloat = 30
    ///录音时长定时器
    private var timer: Timer?
    ///最大录音时长
    let maxRecordSeconds: Int = 60
    ///当前录音时长
    private var recordTime: Int = 0
    
    private var audioRecorder: AVAudioRecorder?
    
    let viewModel: IMChatVM
    private var status: IMRecordVoiceStatus = .end {
        didSet {
            updateStatus()
        }
    }
    deinit {
        stopTimer()
    }
    init(viewModel: IMChatVM) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
        updateStatus()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text.body
        label.font = .medium16
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text.secondary
        label.font = .medium16
        label.isHidden = true
        return label
    }()
    
    lazy var trashIcon: UIImageView = {
        let trash = UIImage.init(systemName: "trash.circle.fill")
        let img = UIImageView.init(image: trash)
        img.isHidden = true
        img.tintColor = .background.red
        return img
    }()
    
    private lazy var longGesture: UILongPressGestureRecognizer = {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongGesture))
        longGesture.minimumPressDuration = 0.3
        longGesture.delegate = self
        return longGesture
    }()
    private lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        panGesture.delegate = self
        return panGesture
    }()
    lazy var recordImg: UIImageView = {
        let recordImg = UIImageView(image: .init(named: "msg_record_voice"))
        recordImg.isUserInteractionEnabled = true
        ///添加长按
        recordImg.addGestureRecognizer(longGesture)
        //添加滑动手势
        recordImg.addGestureRecognizer(panGesture)
        return recordImg
    }()
    
    func updateStatus() {
        if status == .begin {
            timeLabel.isHidden = false
            trashIcon.isHidden = true
            tipLabel.text = "手指上滑，取消发送"
            tipLabel.textColor = .text.body
        }else if status == .cancel {
            timeLabel.isHidden = true
            trashIcon.isHidden = false
            tipLabel.text = "松开手指，取消发送"
            tipLabel.textColor = .background.red
        }else {
            timeLabel.isHidden = true
            trashIcon.isHidden = true
            tipLabel.text = "长按录音"
            tipLabel.textColor = .text.body
        }
    }
}

extension IMVoiceView {
    private func setup() {
        backgroundColor = .background.container
        
        addSubview(recordImg)
        recordImg.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(10)
        }
        
        addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(recordImg.snp.top).offset(-40)
        }
        
        addSubview(trashIcon)
        trashIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(tipLabel.snp.top).offset(-12)
        }
        
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(trashIcon)
        }
    }
    
    @objc func onLongGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            startRecord()
        }else if gesture.state == .ended {
            if status == .end { return } ///录制时间过长可能会提前结束，所以判断一下状态
            if status == .cancel {
                cancelRecord()
            }else {
                sendIfNeed()
            }
        }
    }
    
    // 处理滑动手势的逻辑
    @objc func onPan(_ gesture: UIPanGestureRecognizer) {
        if status == .end { return }
        let translation = gesture.translation(in: self)
        if translation.y < -cancelDistance {
            status = .cancel
        }else {
            status = .begin
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            self?.timerAction()
        })
    }
    
    private func timerAction() {
        recordTime += 1
        
        if(recordTime >= maxRecordSeconds) {
            sendIfNeed()
        }else {
            let s = maxRecordSeconds - recordTime
            if s <= 5 {
                timeLabel.text = "将在\(s)秒后结束录制"
            }else {
                timeLabel.text = recordTime.toms
            }
        }
    }
    
    private func startRecord() {
        if status == .begin { return }
        
        UIDevice.vibrate()
        
        ///改变状态
        status = .begin
        ///计时
        recordTime = 0
        timeLabel.text = "00:00"
        startTimer()
        ///录音
        let session = AVAudioSession.sharedInstance()
        let permission = session.recordPermission
        if permission == .denied || permission == .undetermined {
            session.requestRecordPermission { granted in
                if (!granted) {
                    DispatchQueue.main.async {
                        self.parentViewController?.openSetting("录音需要开启麦克风权限")
                    }
                }
            }
            cancelRecord()
            return
        }
        
        guard permission == .granted else {
            cancelRecord()
            parentViewController?.openSetting("录音需要开启麦克风权限")
            return
        }
        do {
            try session.setCategory(.playAndRecord)
            try session.setActive(true)
            let settings = [AVSampleRateKey: 8000,
                                   AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                          AVLinearPCMBitDepthKey: 16,
                           AVNumberOfChannelsKey: 1,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            if let path = IMHelper.imVoicePath() {
                audioRecorder = try AVAudioRecorder(url: path, settings: settings)
                audioRecorder?.prepareToRecord()
                audioRecorder?.record()
            }else {
                cancelRecord()
            }
        }catch {
            cancelRecord()
        }
    }
    
    //结束录音，并返回录音文件地址
    private func stopRecord() -> String? {
        if status == .end { return nil }
        status = .end
        stopTimer()
        if audioRecorder?.isRecording ?? false {
            audioRecorder?.stop()
        }
        let path = audioRecorder?.url.path
        audioRecorder = nil
        return path
    }
    
    private func sendIfNeed() {
        let interval = audioRecorder?.currentTime ?? 0
        if interval <= 1.0 {
            cancelRecord()
            Toast.show("录音时长过短")
        }else {
            if let path = stopRecord() {
                viewModel.sendVoice(path, duration: interval.int)
            }
        }
    }
    
    private func cancelRecord() {
        if status == .end { return }
        status = .end
        stopTimer()
        if audioRecorder?.isRecording ?? false {
            audioRecorder?.stop()
        }
        if let path = audioRecorder?.url.path {
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                }catch {

                }
            }
        }
        audioRecorder = nil
    }
}

extension IMVoiceView: UIGestureRecognizerDelegate {
    // 手势代理方法
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

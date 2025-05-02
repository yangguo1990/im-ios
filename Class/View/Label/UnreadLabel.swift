//
//  UnreadLabel.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/14.
//

import UIKit

class UnreadLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = .systemFont(ofSize: 10, weight: .medium)
        layer.masksToBounds = true
        updateColor()
        updateData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        var h = size.width
        if h > 18 {
            h = 18
        }
        return .init(width: size.width, height: h)
    }
    
    //是否接收消息，默认为true，开启免打扰为false
    var isReceive: Bool = true {
        didSet {
            updateColor()
        }
    }
    
    ///未读数
    var unreadCount: Int? {
        didSet {
            updateData()
        }
    }
    
    var unreadCount_int32: Int32? {
        didSet {
            updateData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.size.height / 2
    }
}

extension UnreadLabel {
    private func updateData() {
        let count = unreadCount ?? Int(unreadCount_int32 ?? 0)
        if count <= 0 {
            text = ""
            invalidateIntrinsicContentSize()
            isHidden = true
            return
        }
        if count < 100 {
            text = "  \(count)  "
        }else {
            text = "  99+  "
        }
        invalidateIntrinsicContentSize()
        isHidden = false
    }
    
    private func updateColor() {
        if isReceive {
            backgroundColor = .background.red
            textColor = .white
        }else {
            backgroundColor = UIColor(hex: "#F4F4F3")
            textColor = UIColor(hex: "#B4B4B4")
        }
    }
}

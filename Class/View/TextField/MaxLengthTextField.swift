//
//  MaxLengthTextField.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/2/4.
//

import UIKit

class MaxLengthTextField: UITextField {

    // 设置最大字符数限制，默认为无限制
    var maxLength: Int = Int.max

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        // 添加通知监听文本变化
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChangeNotification(notification:)), name: UITextField.textDidChangeNotification, object: self)
    }

    @objc private func textFieldDidChange() {
        // 获取当前文本框中的文字
        guard let currentText = text else {
            return
        }

        // 使用NSString的length属性来计算字符数，确保正确处理中文
        let nsString = currentText as NSString
        let currentLength = nsString.length

        // 检查字符数是否超过限制
        if currentLength > maxLength {
            // 如果超过限制，截取前面的字符
            let index = nsString.rangeOfComposedCharacterSequence(at: maxLength).lowerBound
            let trimmedText = nsString.substring(to: index)
            text = trimmedText
        }
    }

    @objc private func handleTextChangeNotification(notification: Notification) {
        if let tf = notification.object as? UITextField, tf != self {
            return
        }
        // 处理文本变化的通知，确保不打断拼音输入
        if let markedTextRange = self.markedTextRange {
            // 如果存在拼音输入，则不进行截断
            let position = self.offset(from: self.beginningOfDocument, to: markedTextRange.start)
            if position < maxLength {
                return
            }
        }

        // 如果没有拼音输入或拼音输入已经到达最大长度，则执行截断操作
        self.textFieldDidChange()
    }

    deinit {
        // 移除通知监听
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: self)
    }
}



//
//  CountInputView.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/25.
//

import UIKit

class NoActionTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

class CountInputView: UIView {
    let count: UInt
    
    var isSecurity: Bool = false
    
    var inputChanged: StringBlock?
    
    var borderColor: UIColor? {
        didSet {
            if let borderColor = borderColor {
                labels.forEach({
                    $0.layer.borderColor = borderColor.cgColor
                    $0.layer.borderWidth = 1
                })
            }
        }
    }
    var highlightBorderColor: UIColor?
    
    var textBackgroundColor: UIColor? {
        didSet {
            if let backgroundColor = textBackgroundColor {
                labels.forEach({ $0.backgroundColor = backgroundColor })
            }
        }
    }
    
    var textColor: UIColor? {
        didSet {
            if let textColor = textColor {
                labels.forEach({ $0.textColor = textColor })
            }
        }
    }
    
    var font: UIFont? {
        didSet {
            if let font = font {
                labels.forEach({ $0.font = font })
            }
        }
    }
    
    private var labels: [UILabel]!
    
    lazy var textField: UITextField = {
        let tf = NoActionTextField()
        tf.tintColor = .clear
        tf.textColor = .clear
        tf.keyboardType = .numberPad
        tf.delegate = self
        tf.addTarget(self, action: #selector(textFieldDidChanged(_:)) , for: .editingChanged)
        return tf
    }()
    
    init(count: UInt) {
        self.count = count
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        var labels = [UILabel]()
        var previous: UILabel!
        for i in 0..<count {
            let label = createLabel(Int(i))
            addSubview(label)
            label.snp.makeConstraints { make in
                make.bottom.top.equalToSuperview()
                if i == 0 {
                    make.leading.equalToSuperview()
                }else {
                    make.leading.equalTo(previous.snp.trailing).offset(10)
                    make.width.equalTo(previous)
                }
                if i == count - 1 {
                    make.trailing.equalToSuperview()
                }
            }
            //进入下次遍历前，记录
            previous = label
            labels.append(label)
        }
        self.labels = labels
    }
    
    @objc func textFieldDidChanged(_ tf: UITextField) -> Void {
        let text = tf.text ?? ""
        let chars = text.charactersArray
        for i in 0..<count {
            let label = labels[Int(i)]
            if i < chars.count {
                if isSecurity {
                    label.text = "•"
                }else {
                    let c = chars[Int(i)]
                    label.text = String(c)
                }
                if let highlightBorderColor = highlightBorderColor {
                    label.layer.borderColor = highlightBorderColor.cgColor
                }
            }else {
                label.text = ""
                if let borderColor = borderColor {
                    label.layer.borderColor = borderColor.cgColor
                }
            }
        }
        inputChanged?(text)
    }
    
    func createLabel(_ index: Int) -> UILabel {
        let label = UILabel()
        label.textColor = .text.body
        label.textAlignment = .center
        label.layerCornerRadius = 6
        label.backgroundColor = UIColor.background.container
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }
}

extension CountInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" && range.length > 0 {
            return true
        }
        if let count = textField.text?.count {
            return count < self.count
        }
        return true
    }
}


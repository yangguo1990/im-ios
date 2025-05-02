//
//  IMChatTimeCell.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/15.
//

import UIKit
//import HyphenateChat

class IMChatTimeCell: UITableViewCell {
    var message: IMChatMsgModel? {
        didSet {
            updateData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    lazy var noteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .text.secondary
        label.textAlignment = .center
        return label
    }()
    
    private func commonInit() {
        backgroundColor = .clear
        contentView.addSubview(noteLabel)
        noteLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    func updateData() {
        noteLabel.text = Utils.msgTime(message?.msg.localTime)
    }
}

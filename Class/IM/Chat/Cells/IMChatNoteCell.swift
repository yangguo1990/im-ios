//
//  IMChatNoteCell.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/15.
//

import UIKit

class IMChatNoteCell: UITableViewCell {
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
    
    lazy var noteLabel: PaddingLabel = {
        let label = PaddingLabel(padding: .init(horizontal: 40, vertical: 8))
        label.label.numberOfLines = 0
        label.label.font = .systemFont(ofSize: 12)
        label.label.textColor = .text.secondary
        label.label.textAlignment = .center
        return label
    }()
    
    private func commonInit() {
        backgroundColor = .clear
        contentView.addSubview(noteLabel)
        noteLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    func updateData() {
        var text = "Unknown message"
//        if message?.msg.contentType == .friendAppApproved {
//            text = .lang.localizable.msgFriendApproved()
//        }
        
        noteLabel.label.text = text
    }
}

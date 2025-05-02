//
//  SystemMsgCell.swift
//  MeiLiao
//
//  Created by Kun Xun on 2024/2/29.
//

import UIKit

class SystemMsgCell: UITableViewCell {
    var model: SystemMessageModel? {
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
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .body12
        label.textColor = .text.secondary
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .medium16
        label.textColor = .text.body
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .body14
        label.textColor = .text.body
        return label
    }()
    
    private func commonInit() {
        backgroundColor = .clear
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        let container = UIView()
        container.backgroundColor = .white
        container.layerCornerRadius = 8
        contentView.addSubview(container)
        container.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(timeLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(8)
        }
        
        container.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        container.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    private func updateData() {
        timeLabel.text = Utils.fmtTime(model?.createTime)
        nameLabel.text = model?.title
        contentLabel.text = model?.content
    }
}

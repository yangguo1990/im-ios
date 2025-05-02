//
//  GiftNumberCell.swift
//  MeiLiao
//
//  Created by Kun Xun on 2024/3/1.
//

import UIKit

class GiftNumberCell: UITableViewCell {
    var model: GiftNumberModel? {
        didSet {
            updateData()
        }
    }
    var isChoose: Bool = false {
        didSet {
            updateBG()
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
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = .medium16
        label.textColor = .text.body
        label.textAlignment = .center
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .body14
        label.textColor = .text.body
        label.textAlignment = .center
        return label
    }()
    
    lazy var gradient: GradientView = {
        let view = GradientView()
        view.colors = [.background.yuanlai.alpha(0.5), .background.yuanlai]
        view.direction = .z
        view.layerCornerRadius = 6
        return view
    }()

    
    private func commonInit() {
        contentView.addSubview(gradient)
        gradient.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(60)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(numberLabel.snp.trailing)
            make.trailing.equalToSuperview()
        }
    }
    
    private func updateData() {
        numberLabel.text = "\(model?.number ?? 0)"
        nameLabel.text = model?.name
    }
    
    private func updateBG() {
        if isChoose {
            gradient.isHidden = false
        }else {
            gradient.isHidden = true
        }
    }
}

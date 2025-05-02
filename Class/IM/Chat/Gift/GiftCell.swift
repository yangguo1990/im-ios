//
//  GiftCell.swift
//  MeiLiao
//
//  Created by Kun Xun on 2024/2/29.
//

import UIKit
import Kingfisher

class GiftCell: UICollectionViewCell {
    var model: GiftModel? {
        didSet {
            updateData()
        }
    }
    var isChoose: Bool = false {
        didSet {
            updateBG()
        }
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .text.secondary
        label.textAlignment = .center
        return label
    }()
    lazy var coin: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .text.describe
        label.textAlignment = .center
        return label
    }()

    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.layerCornerRadius = 8
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(coin)
        coin.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
        }
    
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalTo(coin.snp.top).offset(-3)
        }
        
        //img
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalTo(nameLabel.snp.top).offset(-5)
        }
    }
    
    private func updateData() {
        nameLabel.text = model?.name
        coin.text = "\(model?.coin ?? 0)米"
        imgView.kf.setImage(with: URL(string: model?.fullIcon))
    }
    
    private func updateBG() {
        if isChoose {
            bgView.backgroundColor = UIColor(hex: "#fee4f1")
            bgView.layerBorderColor = .background.yuanlai
            bgView.layerBorderWidth = 1
        }else {
            bgView.backgroundColor = .background.container
            bgView.layerBorderColor = .clear
            bgView.layerBorderWidth = 0
        }
    }
}

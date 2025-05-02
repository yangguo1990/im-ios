//
//  IMChatEmojiView.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/15.
//

import UIKit

protocol IMChatEmojiViewDelegate: AnyObject {
    func chatEmojiViewOnDelete()
    func chatEmojiViewOnEmoji(_ emoji: String)
}

class IMChatEmojiView: UIView {
    weak var delegate: IMChatEmojiViewDelegate?
    let emotions = Constants.emotions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.itemSize = .init(width: 40, height: 40)
        layout.sectionInset = .init(top: 8, left: 8, bottom: 80, right: 8)
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellWithClass: EmojiCell.self)
        return collectionView
    }()
    
    lazy var deleteView: UIView = {
        let view = UIView()
        let color = UIColor.background.main
        let gradient = GradientView()
        gradient.gradientLayer.colors = [color.alpha(0).cgColor, color.cgColor]
        gradient.gradientLayer.locations = [0, 0.3]
        view.addSubview(gradient)
        gradient.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let btn = UIButton()
        btn.setImage(.init(named: "msg_delete"), for: .normal)
        btn.backgroundColor = .background.container
        btn.layer.cornerRadius = 6
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(10)
            make.width.equalTo(50)
            make.height.equalTo(36)
        }
        btn.addTarget(self, action: #selector(onDeleteBtnClick), for: .touchUpInside)
        return view
    }()
    
    @objc func onDeleteBtnClick() {
        delegate?.chatEmojiViewOnDelete()
    }
}

extension IMChatEmojiView {
    func setupView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        addSubview(deleteView)
        deleteView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.trailing.equalToSuperview().inset(8)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
    }
}

extension IMChatEmojiView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: EmojiCell.self, for: indexPath)
        cell.emoji.text = emotions[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.chatEmojiViewOnEmoji(emotions[indexPath.item])
    }

}

class EmojiCell: UICollectionViewCell {
    lazy var emoji: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25)
        return label
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
        contentView.addSubview(emoji)
        emoji.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

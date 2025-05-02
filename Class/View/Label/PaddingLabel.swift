//
//  PaddingLabel.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/15.
//

import UIKit

class PaddingLabel: UIView {
    lazy var label: UILabel = {
        let label = UILabel()
        return label
    }()
    let padding: UIEdgeInsets
    init(padding: UIEdgeInsets = .init(inset: 12)) {
        self.padding = padding
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(padding.top)
            make.left.equalToSuperview().offset(padding.left)
            make.bottom.equalToSuperview().inset(padding.bottom)
            make.trailing.equalToSuperview().inset(padding.right)
        }
    }
    
    var corners: (corner: UIRectCorner, radius: CGFloat)?
    override func layoutSubviews() {
        super.layoutSubviews()
        if let corners = corners {
            roundCorners(corners.corner, radius: corners.radius)
        }
    }
}

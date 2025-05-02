//
//  GradientView.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/15.
//

import UIKit

class GradientView: UIView {
    enum Direction {
        case v
        case h
        case z
    }
    var direction: Direction = .v {
        didSet {
            if direction == .v {
                gradientLayer.startPoint = .init(x: 0.5, y: 0)
                gradientLayer.endPoint = .init(x: 0.5, y: 1)
            }else if direction == .z {
                gradientLayer.startPoint = .init(x: 0, y: 0.5)
                gradientLayer.endPoint = .init(x: 1, y: 0.5)
            }else {
                gradientLayer.startPoint = .init(x: 0, y: 0)
                gradientLayer.endPoint = .init(x: 1, y: 1)
            }
        }
    }
    var colors: [UIColor]? {
        didSet {
            updateData()
        }
    }
    
    lazy var gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func updateData() {
        self.gradientLayer.colors = colors?.map{ $0.cgColor }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.bounds
    }
}

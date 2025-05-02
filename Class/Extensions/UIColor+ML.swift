//
//  UIColor+ML.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/22.
//

import UIKit
import Hue

extension UIColor {
    
    ///文本颜色
    struct text {
        static let body = UIColor(hex: "#333333")
        static let secondary = UIColor(hex: "#666666")
        static let describe = UIColor(hex: "#999999")
        static let white = UIColor(hex: "#ffffff")
    }
    
    ///背景颜色
    struct background {
        static let main = UIColor(hex: "#FFFFFF")
        static let container = UIColor(hex: "#F1F3F5")
        static let separator = UIColor(hex: "#F7F7F7")
        static let border = UIColor(hex: "#CCCCCC")
        static let cover = UIColor.black.alpha(0.3)
        static let shadom = UIColor.black.alpha(0.2)
        static let disableButton = UIColor(hex: "#EEEEEE")
        
        static let red = UIColor(hex: "#FB4240")
        static let green = UIColor(hex: "#1BDD7D")
        static let orange = UIColor(hex: "#FFE962")
        static let purple = UIColor(hex: "#835EFE")
        static let pink = UIColor(hex: "#FF72BE")
        static let shuimitao = UIColor(hex: "#954dff")
        static let yuanlai = UIColor(hex: "#ff6fb3")
    }
    
    ///渐变色
    struct gradient {
        
    }
}

extension UIColor {
    static func rgb(_ r: Int, _ g: Int, _ b: Int) -> UIColor {
        UIColor.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
    }
}

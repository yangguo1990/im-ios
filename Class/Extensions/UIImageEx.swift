//
//  UIImageEx.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/15.
//

import UIKit

extension UIImage {
    static func textToImage(_ text: String, size: CGSize, font: UIFont = .systemFont(ofSize: 16, weight: .semibold), textColor: UIColor = .white, backgroudColor: UIColor = .random.alpha(0.7)) -> UIImage? {
        let attributes = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: font
        ]
        
        ///background
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        backgroudColor.setFill()
        UIRectFill(.init(origin: .zero, size: size))
        
        ///text
        let textSize = text.size(withAttributes: attributes)
        let x = max(0, (size.width - textSize.width)/2)
        let y = max(0, (size.height - textSize.height)/2)
        let rect = CGRect(origin: .init(x: x, y: y), size: textSize)
        text.draw(with: rect, options: [.usesLineFragmentOrigin], attributes: attributes, context: nil)
        
        ///image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

//
//  UILabelEx.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/16.
//

import UIKit

extension UILabel {
    
    func addCopyTapGesture() {
        if (gestureRecognizers?.count ?? 0) > 0 {
            return
        }
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onCopyTap))
        tap.name = "Copy"
        addGestureRecognizer(tap)
    }
    
    @objc func onCopyTap() {
        if text.isNilOrEmpty { return }
        text?.copyToPasteboard()
    }
}

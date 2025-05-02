//
//  UIView+ML.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/23.
//

import UIKit

///keyboard
extension UIView {
    ///添加单击隐藏键盘的手势
    func addDissmissKeyboardTap() {
        addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onDissmissKeyboardGestureTap)))
    }
    
    @objc func onDissmissKeyboardGestureTap() {
        endEditing(true)
    }
}

///empty view
extension UIView {
    func showEmpty(_ empty: UIView? = nil, topOffset: CGFloat = 0) {
        hideEmpty()
        var view: UIView
        if let empty = empty {
            view = empty
        }else {
            let img = UIImageView(image: .init(named: "msg_empty"))
            img.contentMode = .center
            view = img
        }
        view.tag = Constants.tag.empty
        addSubview(view)
        view.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(topOffset)
        }
    }
    func hideEmpty() {
        viewWithTag(Constants.tag.empty)?.removeFromSuperview()
    }
}
extension UIView {
    func startRequest() {
        isUserInteractionEnabled = false
        if viewWithTag(Constants.tag.loading) == nil {
            let activity = UIActivityIndicatorView(style: .medium)
            activity.color = .white
            activity.startAnimating()
            activity.tag = Constants.tag.loading
            activity.frame = bounds
            activity.backgroundColor = UIColor(hex: "#121F37").alpha(0.95)
            activity.layer.cornerRadius = layerCornerRadius
            addSubview(activity)
        }
    }
    func stopRequest() {
        isUserInteractionEnabled = true
        viewWithTag(Constants.tag.loading)?.removeFromSuperview()
    }
}

extension UIView {
    func startRotate(_ duration: Double = 1.0) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0.0
        animation.toValue = -Double.pi * 2
        animation.duration = duration
        animation.repeatCount = .infinity
        layer.add(animation, forKey: "ML_ROTATE")
    }
    
    func stopRotate() {
        layer.removeAnimation(forKey: "ML_ROTATE")
    }
    
    func startScale(_ duration: Double = 1.0, from: Double = 0.2, to: Double = 1.2) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        animation.repeatCount = .infinity
        animation.autoreverses = true
        layer.add(animation, forKey: "ML_SCALE")
    }
    
    func stopScale() {
        layer.removeAnimation(forKey: "ML_SCALE")
    }
}

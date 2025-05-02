//
//  UIApplication+ML.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/22.
//

import UIKit

extension UIApplication {
    var currentWindow: UIWindow? {
        if #available(iOS 13, *) {
            for scene in connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    for window in windowScene.windows {
                        if window.isKeyWindow {
                            return window
                        }
                    }
                }
            }
        } else {
            return keyWindow
        }
        return nil
    }
}


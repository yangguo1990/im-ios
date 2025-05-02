//
//  MLExtensions.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/26.
//

import UIKit
import AudioToolbox

extension Double {
    func maxDigitsString(_ max: Int = 4, roundMode: NumberFormatter.RoundingMode = .floor) -> String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.maximumFractionDigits = max
        fmt.roundingMode = roundMode
        return fmt.string(for: self) ?? self.string
    }
}

extension Int {
    var badge: String? {
        if self <= 0 {
            return nil
        }
        if self < 100 {
            return self.string
        }
        return "99+"
    }
    
    ///转成分秒格式：mm:ss
    var toms: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        if let formattedString = formatter.string(from: TimeInterval(self)) {
            return formattedString
        } else {
            return "00:00"
        }
    }
}

extension UIDevice {
    static func vibrate() {
        let soundID = SystemSoundID(1521)
        AudioServicesPlaySystemSound(soundID)
    }
}

extension UIScrollView {
    var screenshotImage: UIImage? {
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(contentSize)
        
        let formerContentOffset = contentOffset
        let formerFrame = frame
        contentOffset = .zero
        frame = CGRect(origin: CGPoint.zero, size: contentSize)
        
        UIGraphicsBeginImageContextWithOptions(contentSize, false, UIScreen.main.scale)
        if let currentContext = UIGraphicsGetCurrentContext() {
            layer.render(in: currentContext)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        
        contentOffset = formerContentOffset
        frame = formerFrame
        return image
    }
}

extension UINavigationController {
    func popToViewController<T: UIViewController>(_ type: T.Type) {
        let vc = viewControllers.first {
            $0.isKind(of: type)
        }
        if let vc = vc {
            popToViewController(vc, animated: true)
        }else {
            popViewController()
        }
    }
}

extension Array {
    func split(intoChunksOf chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0 ..< Swift.min($0 + chunkSize, self.count)])
        }
    }
}

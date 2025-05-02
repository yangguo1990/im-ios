//
//  GiftAnimatePlayer.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/3/3.
//

import Foundation
import SVGAPlayer
import UIKit

class GiftAnimatePlayer: NSObject {
    static let share = GiftAnimatePlayer()
    private override init() {}
    
    @objc static func play(path: String, inView: UIView) {
        var path = path
        if path.hasPrefix("http") == false, let domain = UserCenter.share.userModel?.domain {
            path = domain.appendingPathComponent(path)
        }
        guard let url = URL(string: path) else { return }
        let parse = SVGAParser()
        parse.parse(with: url) { item in
            if let item = item {
                GiftAnimatePlayer.startAnimate(item, inView: inView)
            }
        } failureBlock: { error in
            ddPrint(error?.localizedDescription ?? "SVGAParser Error")
        }
    }
    
    private static func startAnimate(_ item: SVGAVideoEntity, inView: UIView) {
        stopAnimateIfNeed(inView)
        let size = item.videoSize
        guard size.width > 0 && size.height > 0 else { return }
        let w = min(size.width, inView.size.width)
        let h = w * (size.height / size.width)
        
        let svgaPlayer = SVGAPlayer()
        svgaPlayer.tag = Constants.tag.giftPlayer
        svgaPlayer.size = .init(width: w, height: h)
        svgaPlayer.center = inView.center
        svgaPlayer.loops = 1
        svgaPlayer.contentMode = .scaleAspectFit
        svgaPlayer.delegate = share
        svgaPlayer.clearsAfterStop = true
        svgaPlayer.videoItem = item
        
        inView.addSubview(svgaPlayer)
        svgaPlayer.startAnimation()
    }
    
    private static func stopAnimateIfNeed(_ inView: UIView) {
        guard let view = inView.viewWithTag(Constants.tag.giftPlayer) else { return }
        guard let player = view as? SVGAPlayer else { return }
        player.stopAnimation()
        player.removeFromSuperview()
    }
}

extension GiftAnimatePlayer: SVGAPlayerDelegate {
    func svgaPlayerDidFinishedAnimation(_ player: SVGAPlayer!) {
        player.stopAnimation()
        player.removeFromSuperview()
    }
}

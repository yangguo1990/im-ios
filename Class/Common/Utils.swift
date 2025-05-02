//
//  Utils.swift
//  IMPro
//
//  Created by ganlingyun on 2024/1/14.
//

import UIKit
import Segmentio

struct Utils {
    static func segmentioOptions() -> SegmentioOptions {
        let normal = SegmentioState(
            backgroundColor: .clear,
            titleFont: .systemFont(ofSize: 16),
            titleTextColor: .text.secondary,
            titleAlpha: 1)
        let selected = SegmentioState(
            backgroundColor: .clear,
            titleFont: .systemFont(ofSize: 18, weight: .bold),
            titleTextColor: .background.yuanlai,
            titleAlpha: 1)
        let segmentioStates = SegmentioStates(defaultState: normal, selectedState: selected, highlightedState: selected)
        let segmentioOptions = SegmentioOptions(
            backgroundColor: .background.main,
            segmentPosition: .dynamic,
            scrollEnabled: true,
            indicatorOptions: .init(type: .bottom, ratio: 0.5, color: .background.yuanlai),
            horizontalSeparatorOptions: .init(color: .clear),
            verticalSeparatorOptions: .init(color: .clear),
            labelTextAlignment: .center,
            segmentStates: segmentioStates,
            animationDuration: 0.25
        )
        return segmentioOptions
    }
    static func msgTime(_ time: Int64?) -> String? {
        guard var time = time, time > 0 else { return nil }
        if time > 140000000000 { ///如果是毫秒，除以1000
            time = time / 1000
        }
        let date = Date.init(timeIntervalSince1970: TimeInterval(time))
        let now = Date()
        if now.secondsSince(date) <= 3 * 60 { ///3分钟以内
            return "刚刚"
        }
        if date.isInToday {
            return date.string(withFormat: "HH:mm")
        }
        if date.isInCurrentYear {
            return date.string(withFormat: "MM-dd HH:mm")
        }
        
        return date.string(withFormat: "yyyy-MM-dd")
    }
    
    static func fmtTime(_ time: TimeInterval?, fmt: String = "yyyy-MM-dd HH:mm") -> String? {
        guard var time = time, time > 0 else { return nil }
        if time > 140000000000 { ///如果是毫秒，除以1000
            time = time / 1000
        }
        let date = Date.init(timeIntervalSince1970: time)
        return date.string(withFormat: fmt)
    }
}

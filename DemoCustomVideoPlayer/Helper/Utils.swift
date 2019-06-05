//
//  Utils.swift
//  DemoCustomVideoPlayer
//
//  Created by ly.hoang.quang on 6/5/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import UIKit

let videoRatio: CGFloat = 11/16

class Utils {
    
    static func getTimeString(from seconds: Int) -> String {
        let secondString = String(format: "%02d", seconds % 60)
        let minuteString = String(format: "%02d", seconds / 60)
        return "\(minuteString):\(secondString)"
    }
    
    static func miniFrameOfPlayer() -> CGRect {
        guard let keyWindow = UIApplication.shared.keyWindow else { return .zero }
        let widthMini = keyWindow.frame.size.width / 2
        let heightMini = widthMini * videoRatio
        return CGRect(x: 0, y: 0, width: widthMini, height: heightMini)
    }
    
    static func fullFrameOfPlayer() -> CGRect {
        guard let keyWindow = UIApplication.shared.keyWindow else { return .zero }
        let fullWidth = keyWindow.frame.size.width
        let fullHeight = fullWidth * videoRatio
        return CGRect(x: 0, y: 0, width: fullWidth, height: fullHeight)
    }
}

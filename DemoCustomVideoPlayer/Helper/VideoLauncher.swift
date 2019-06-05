//
//  VideoLauncher.swift
//  DemoCustomVideoPlayer
//
//  Created by ly.hoang.quang on 6/4/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import UIKit

class VideoLauncher {
    
    static let instance = VideoLauncher()
    
    private init() {}
    
    private var viewLauncher: VideoLauncherView?
    
    func showVideoPlayer() {
        if let keyWindow = UIApplication.shared.keyWindow {
            if viewLauncher == nil {
                let view = VideoLauncherView()
                view.frame = CGRect(x: keyWindow.frame.width - 30, y: keyWindow.frame.height - 30, width: 30, height: 30)
                keyWindow.addSubview(view)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    view.frame = keyWindow.frame
                }) {[weak self] (completed) in
                    self?.viewLauncher = view
                }
            } else {
                fullVideoPlayerAndReplay()
            }
        }
    }
    
    func minimumVideoPlayer() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        let frame = Utils.miniFrameOfPlayer()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.viewLauncher?.frame = CGRect(x: keyWindow.frame.width - frame.width - 10,
                                              y: keyWindow.frame.height - frame.height - 30,
                                              width: frame.width,
                                              height: frame.height)
            self.viewLauncher?.videoPlayerView.setMiniFrameForPlayerLayer()
        }) { (completed) in
        }
    }
    
    func fullVideoPlayer() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.viewLauncher?.frame = keyWindow.frame
            self.viewLauncher?.videoPlayerView.setFullFrameForPlayerLayer()
        }) {(completed) in
        }
    }
    
    func fullVideoPlayerAndReplay() {
        fullVideoPlayer()
        viewLauncher?.videoPlayerView.replayVideo()
    }
}

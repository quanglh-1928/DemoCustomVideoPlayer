//
//  VideoLauncherView.swift
//  DemoCustomVideoPlayer
//
//  Created by ly.hoang.quang on 6/5/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import UIKit

class VideoLauncherView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var videoPlayerView: VideoPlayerView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("VideoLauncherView", owner: self, options: nil)
        addSubview(contentView)
        AutoLayoutHelper.fit(contentView, superView: self)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        clipsToBounds = true
    }
    
}

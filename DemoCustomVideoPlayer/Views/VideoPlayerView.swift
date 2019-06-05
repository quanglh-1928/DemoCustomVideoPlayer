//
//  VideoPlayerView.swift
//  DemoCustomVideoPlayer
//
//  Created by ly.hoang.quang on 6/4/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var controlsContainerView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var pausePlayButton: UIButton!
    @IBOutlet weak var runingTimeLabel: UILabel!
    @IBOutlet weak var videoSlider: UISlider!
    @IBOutlet weak var lengthTimeLabel: UILabel!
    
    private let urlString = "https://firebasestorage.googleapis.com/v0/b/demoanalytics-30aa0.appspot.com/o/videoplayback.mp4?alt=media&token=bba10bc6-c618-420a-97a4-a313ac206946"
    var avPlayer: AVPlayer?
    var playerLayer: CALayer?
    var isPlaying = false
    var isMiniPlayer = false
    var isEnd = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("VideoPlayerView", owner: self, options: nil)
        addSubview(contentView)
        AutoLayoutHelper.fit(contentView, superView: self)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        activityIndicatorView.startAnimating()
        
        pausePlayButton.isHidden = true
        
        videoSlider.addTarget(self, action: #selector(onSlider), for: .valueChanged)
        videoSlider.value = 0.0
        
        setupPlayerView()
        
        setupGradientLayer()
    }
    
    private func setupPlayerView() {
        if let url = URL(string: urlString) {
            avPlayer = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: avPlayer)
            videoView.layer.addSublayer(playerLayer ?? CALayer())
            
            avPlayer?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            avPlayer?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer?.currentItem)
            avPlayer?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 2), queue: .main, using: { (timeProgress) in
                let seconds = CMTimeGetSeconds(timeProgress)
                self.runingTimeLabel.text = Utils.getTimeString(from: Int(seconds))
                
                if let duration = self.avPlayer?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    self.videoSlider.value = Float(seconds / durationSeconds)
                }
                
            })
            
            avPlayer?.play()
            
        }
    }
    
    private func setupGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.clear, UIColor.black]
        gradient.locations = [0.7, 1.2]
        controlsContainerView.layer.addSublayer(gradient)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            if let duration = avPlayer?.currentItem?.duration {
                let seconds = Int(CMTimeGetSeconds(duration))
                lengthTimeLabel.text =  Utils.getTimeString(from: Int(seconds))
            }
        } else if keyPath == "timeControlStatus" {
            if avPlayer?.timeControlStatus == .playing {
                activityIndicatorView.stopAnimating()
                pausePlayButton.isHidden = false
                isPlaying = true
                setFullFrameForPlayerLayer()
            }
        }
    }
    
    @objc func playerDidFinishPlaying(){
        isPlaying = false
        isEnd = true
        pausePlayButton.setImage(UIImage(named: "play_ic"), for: .normal)
    }
    
    @objc private func onSlider() {
        if let duration = avPlayer?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let seekTime = CMTime(value: Int64(videoSlider.value * Float(totalSeconds)), timescale: 1)
            avPlayer?.seek(to: seekTime)
        }
    }
    
    func setFullFrameForPlayerLayer() {
        playerLayer?.frame = Utils.fullFrameOfPlayer()
    }
    
    func setMiniFrameForPlayerLayer() {
        playerLayer?.frame = Utils.miniFrameOfPlayer()
    }
    
    func replayVideo() {
        avPlayer?.seek(to: CMTime(value: 0, timescale: 1))
        isEnd = false
        controlsContainerView.isHidden = false
        playVideo()
    }
    
    func playVideo() {
        avPlayer?.play()
        pausePlayButton.setImage(UIImage(named: "pause_ic"), for: .normal)
        isPlaying = true
    }
    
    func pauseVideo() {
        avPlayer?.pause()
        pausePlayButton.setImage(UIImage(named: "play_ic"), for: .normal)
        isPlaying = false
    }
    
    @IBAction func onPause(_ sender: Any) {
        if isEnd {
            replayVideo()
            return
        }
        if isPlaying {
            pauseVideo()
        } else {
            playVideo()
        }
    }
    
    @IBAction func onMiniSize(_ sender: Any) {
        VideoLauncher.instance.minimumVideoPlayer()
        controlsContainerView.isHidden = true
        isMiniPlayer = true
    }
    
    @IBAction func onFullSize(_ sender: Any) {
        if !isMiniPlayer { return }
        VideoLauncher.instance.fullVideoPlayer()
        controlsContainerView.isHidden = false
        isMiniPlayer = false
    }
    
    @IBAction func onFoward(_ sender: Any) {
        if let duration = avPlayer?.currentItem?.duration, let currentTime = avPlayer?.currentItem?.currentTime() {
            let totalSeconds = CMTimeGetSeconds(duration)
            let currentSeconds = CMTimeGetSeconds(currentTime)
            if currentSeconds + 10 >= totalSeconds {
                avPlayer?.seek(to: duration)
            } else {
                let seekTime = CMTime(value: Int64(currentSeconds + 10), timescale: 1)
                avPlayer?.seek(to: seekTime)
            }
        }
    }
    
    @IBAction func onRewind(_ sender: Any) {
        if let currentTime = avPlayer?.currentItem?.currentTime() {
            let currentSeconds = CMTimeGetSeconds(currentTime)
            if currentSeconds - 10 <= 0 {
                let seekTime = CMTime(value: 0, timescale: 1)
                avPlayer?.seek(to: seekTime)
            } else {
                let seekTime = CMTime(value: Int64(currentSeconds - 10), timescale: 1)
                avPlayer?.seek(to: seekTime)
            }
        }
    }
}

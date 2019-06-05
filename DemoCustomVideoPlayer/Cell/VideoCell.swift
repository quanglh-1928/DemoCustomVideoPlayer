//
//  VideoCell.swift
//  DemoCustomVideoPlayer
//
//  Created by ly.hoang.quang on 6/4/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import UIKit

class VideoCell: UICollectionViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.size.width / 2
    }

}

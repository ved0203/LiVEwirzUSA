//
//  SliderCC.swift
//  ScreenOPSN
//
//  Created by Dhruvin Bhalodiya on 04/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AVKit
import FSPagerView

class SliderCC: FSPagerViewCell {
    // MARK: - All Outlet
    @IBOutlet weak var artistImage: UIImageViewProperty!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistProfile: UIImageViewProperty!
    @IBOutlet weak var postDetailsLabel: UILabel!
    @IBOutlet weak var postLocationLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shortCommentLabel: UILabel!
    @IBOutlet weak var btnartistName: UIButton!
    @IBOutlet weak var total_comments: UILabel!
    @IBOutlet weak var total_likes: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet var playVw: PlayerVWClass!
    // MARK: - Intilize Varriable
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

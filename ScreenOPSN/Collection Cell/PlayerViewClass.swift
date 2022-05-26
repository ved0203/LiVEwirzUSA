//
//  PlayerViewClass.swift
//  Slideshow
//
//  Created by Dhruvin Bhalodiya on 30/11/20.
//

import Foundation
import AVKit
import AVFoundation

class PlayerVWClass: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
}

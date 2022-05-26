//
//  PostViewControllerPreview.swift
//  ScreenOPSN
//
//  Created by shadab sheikh on 2020-03-20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit

class PostViewControllerPreview: UIViewController, AVPlayerViewControllerDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imageView: UIImageViewProperty!
    
    var isImage: Bool = false
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var videoURL: URL!
    var imageURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isImage {
            videoView.isHidden = true
            imageView.isHidden = false
        } else {
            videoView.isHidden = false
            imageView.isHidden = true
        }
        
        videoView.clipsToBounds = true
        videoView.layer.cornerRadius = 10.0
     }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
    }
    
    // MARK: - Set UI
    func setUI() {
        if isImage {
            videoView.isHidden = true
            imageView.isHidden = false
            imageView.downloadImage(from: imageURL)
        } else {
            videoView.isHidden = false
            imageView.isHidden = true
            
            avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.frame =  CGRect(x:0, y: 0, width:videoView.frame.size.width, height:videoView.frame.size.height)
            avPlayerLayer.videoGravity = .resize
            videoView.layer.insertSublayer(avPlayerLayer, at: 0)
            videoView.layoutIfNeeded()
            
            let playerItem = AVPlayerItem(url: videoURL as URL)
            avPlayer.replaceCurrentItem(with: playerItem)
            avPlayer.play()
            
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.avPlayer.currentItem, queue: .main) { [weak self] _ in
                self?.avPlayer.seek(to: CMTime.zero)
                self?.avPlayer.play()
            }
         }
    }

    // MARK: - All Buuton Action
    @IBAction func didTappedOnBackButton(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    
 }

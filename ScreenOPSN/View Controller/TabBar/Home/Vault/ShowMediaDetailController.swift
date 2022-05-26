//
//  ShowMediaDetailController.swift
//  ScreenOPSN
//
//  Created by shadab sheikh on 2020-03-20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit

class ShowMediaDetailController: UIViewController, AVPlayerViewControllerDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var reviewPostImage: UIImageViewProperty!
    @IBOutlet weak var alertView: UIViewPropertys!
    @IBOutlet weak var alertView1: UIViewPropertys!
    @IBOutlet weak var transperentBG: UIView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var fullViewImage: UIView!
    @IBOutlet weak var zoomImage: UIImageView!
    @IBOutlet weak var btnPost: UIButton!
    
    var lblBlackText: UILabel?

    var isImage: Bool = false
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var videoURL: URL!
    var reviewImage: String = ""
    var eventId: String = ""
    var isStatus: String = ""
    var isPost = false
    var strComment = ""
    var selectindex = 0
    var arrValute: [NSDictionary] = []
    
    var count: CGFloat = 0
    var progressRing: CircularProgressBar!
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alertshow(title: "" , bool: true)
        self.postGetMediaDetail(eventId: self.eventId)
        self.setSwipe()
        print("Video URL=\(videoURL)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        avPlayer.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        avPlayer.pause()
    }

    func setEmptyLabel()  {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height

        lblBlackText = UILabel(frame: CGRect(x: 15, y: (screenHeight-100)/2, width: screenSize.size.width-30, height: 120))
        lblBlackText?.textAlignment = .center
        //For center alignment
        lblBlackText?.text = "No pics or vids for this event yet."
        lblBlackText?.textColor = .white
        lblBlackText?.backgroundColor = .clear
        lblBlackText?.font = UIFont.systemFont(ofSize: 17)

        //If required
        self.view.addSubview(lblBlackText!)
    }
    
    func imageCounter(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(incrementCount), userInfo: nil, repeats: true)
        count = 0
        timer.fire()
    }
    
    // Note only works when time has not been invalidated yet
    @objc func resetProgressCount() {
        count = 0
        timer.fire()
    }
    
    @objc func incrementCount(totalCount: CGFloat) {
        count += 1
        progressRing.progress = (count * 100)/totalCount
        progressRing.progressText = "\(Int(totalCount - count))"
        
        if count >= totalCount {
            timer.invalidate()
        }
    }
    
    // MARK: - Set UI
    func setUI() {
        self.fullViewImage.isHidden = true
        
        self.alertshow(title: "" , bool: true)
        if isImage {
            videoView.isHidden = true
            reviewPostImage.isHidden = false
            reviewPostImage.downloadImage(from: reviewImage)
        } else {
            videoView.isHidden = false
            reviewPostImage.isHidden = true
            avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.frame =  CGRect(x:0, y: 0, width:GlobalConstant.SCREENWIDTH, height:GlobalConstant.SCREENHEIGHT - 400)
            avPlayerLayer.videoGravity = .resize
            videoView.layer.insertSublayer(avPlayerLayer, at: 0)
            videoView.layoutIfNeeded()
            let playerItem = AVPlayerItem(url: videoURL as URL)
            print("Video URL=\(videoURL)")
            avPlayer.replaceCurrentItem(with: playerItem)
            avPlayer.play()
            
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.avPlayer.currentItem, queue: .main) { [weak self] _ in
                self?.avPlayer.seek(to: CMTime.zero)
                self?.avPlayer.play()
            }
        }
        if self.isPost {
            self.commentTextView.text = self.strComment
            self.commentTextView.isUserInteractionEnabled = false
            self.btnPost.isHidden = true
        }
    }
    
    func alertshow(title: String, bool: Bool) {
        self.alertLabel.text = title
        self.alertView.isHidden = bool
        self.alertView1.isHidden = bool
        self.transperentBG.isHidden = bool
    }
    
    func postGetMediaDetail(eventId: String) {
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)

            var dictPost:[String: AnyObject]!
            dictPost = ["event_id": eventId as AnyObject ]
            
            WebHelper.requestPostUrl(strURL: APIName.kkGetMediaList, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    self.setEmptyLabel()
                } else if resultString == "1" {
                    self.arrValute =  success.object(forKey: "response") as! [NSDictionary]
                    self.setData()
                    Global.hideActivityIndicator(self.view)
                } else {
                    Global.hideActivityIndicator(self.view)
                }
            }, Failure: {
                failure in
                Global.hideActivityIndicator(self.view)
            })
        } else {
            Global.hideActivityIndicator(self.view)
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
    
    // MARK: - Swipe Gesture
    func setSwipe() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
                if selectindex > 0 {
                    self.selectindex -= 1
                    self.setData()
                }
            case .down:
                print("Swiped down")
            case .left:
                print("Swiped left")
                if selectindex < self.arrValute.count - 1 {
                    self.selectindex += 1
                    self.setData()
                }
            case .up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    func setData() {
        let mediaData = self.arrValute[self.selectindex]
        if mediaData["filetype"] as! String == "image" {
            isImage = true
            let imageURL = Global.getStringValue(mediaData.value(forKey: "fileurl") as AnyObject)
            self.reviewImage = imageURL
        } else if mediaData["filetype"] as! String == "video" {
            isImage = false
            let videourl = Global.getStringValue(mediaData.value(forKey: "fileurl") as AnyObject)
            self.videoURL = URL(string: videourl)!
        }
        
        self.setUI()
    }
    // MARK: - All Buuton Action
    @IBAction func didTappedOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTappedAlertCloseButton(_ sender: Any) {
        self.alertshow(title: "" , bool: true)
        
        if isStatus == "1" {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tab bar")
            self.present(nextViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTappedPostButton(_ sender: Any) {
    }

    @IBAction func didTappedClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTappedFullView(_ sender: Any) {
        if isImage {
            self.fullViewImage.isHidden = false
            zoomImage.downloadImage(from: reviewImage)
            
        } else {
            // Create an AVPlayer, passing it the HTTP Live Streaming URL.
            let player = AVPlayer(url: videoURL)
            
            // Create a new AVPlayerViewController and pass it a reference to the player.
            let controller = AVPlayerViewController()
            controller.player = player
            
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak self] _ in
                player.seek(to: CMTime.zero)
                player.play()
            }
            
            // Modally present the player and call the player's play() method when complete.
            present(controller, animated: true) {
                player.play()
            }
        }
    }
}

//
//  PostViewController.swift
//  ScreenOPSN
//
//  Created by shadab sheikh on 2020-03-20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit

class PostViewController: UIViewController, AVPlayerViewControllerDelegate, AVAudioPlayerDelegate {
    
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
    
    var isImage: Bool = false
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var videoURL: URL!
    var reviewImage: String = ""
    var vaultid: String = ""
    var isStatus: String = ""
    var isPost = false
    var strComment = ""
    var selectindex = 0
    var arrValute = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setSwipe()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FanCommentViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FanCommentViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        print("SelfView=\(self.view)")
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
        print("SelfView=\(self.view)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        avPlayer.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        avPlayer.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        commentTextView.tintColor = .black;
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
            
            avPlayer.replaceCurrentItem(with: playerItem)
            avPlayer.pause()
            
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
        var url: URL!
        var reviewImage: String = ""
        let arrData = self.arrValute[self.selectindex] as! NSDictionary
        if !self.isImage {
            let imageURL = Global.getStringValue(arrData.value(forKey: "filename") as AnyObject)
            url = URL(string: imageURL)!
        } else if self.isImage {
            reviewImage = Global.getStringValue(arrData.value(forKey: "filename") as AnyObject)
        }
        self.vaultid = Global.getStringValue(arrData.value(forKey: "vaultid") as AnyObject)
        self.reviewImage = reviewImage
        self.videoURL = url
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
        postDataForEvent()
    }
    
    
    @IBAction func didTappedClose(_ sender: Any) {
        self.fullViewImage.isHidden = true
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
    
    func postDataForEvent() {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            var dictPost:[String: AnyObject]!
            dictPost = ["userid": userid as AnyObject, "vaultid": vaultid as AnyObject, "post_comment": commentTextView.text as AnyObject ]
            
            WebHelper.requestPostUrl(strURL: APIName.kkPost_comment, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                
                
                if resultString == "0" {
                    self.alertshow(title: message , bool: false)
                    Global.hideActivityIndicator(self.view)
                } else if resultString == "1" {
                    
                    NotificationCenter.default.post(name: Notification.Name("reloadhome"), object: nil)
                    
                    self.alertshow(title: message , bool: false)
                    self.isStatus = "1"
                    Global.hideActivityIndicator(self.view)
                } else {
                    self.alertshow(title: message , bool: false)
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
}

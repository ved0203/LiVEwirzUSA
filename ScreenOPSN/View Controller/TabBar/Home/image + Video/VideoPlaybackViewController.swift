//
//  VideoPlaybackViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 24/02/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlaybackViewController: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var alertView: UIViewPropertys!
    @IBOutlet weak var alertView1: UIViewPropertys!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var transperentBG: UIView!
    
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var playerItem: AVPlayerItem!
    var videoURL: URL!
    //connect this to your uiview in storyboard
    var isStatus: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alertshow(title: "", bool: true)
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.frame = view.bounds
        avPlayerLayer.videoGravity = .resizeAspectFill
        //   AVLayerVideoGravityResizeAspectFill
        videoView.layer.insertSublayer(avPlayerLayer, at: 0)
        
        view.layoutIfNeeded()
        
        playerItem = AVPlayerItem(url: videoURL as URL)
        avPlayer.replaceCurrentItem(with: playerItem)
        
        avPlayer.play()
        
        print("Video URL VPVC=\(videoURL)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
        
    @IBAction func didTappedForSaveVideo(_ sender: Any) {
        
        let roleid = UserDefaults.standard.integer(forKey: "roleid")
        if roleid == 2 {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BroadCastViewController") as! BroadCastViewController
            nextViewController.videoURL = videoURL
            nextViewController.caption = ""
            nextViewController.comment = ""
            self.navigationController?.pushViewController(nextViewController, animated: true)
        } else {
            self.PostDataForSaveVideoInVault()
        }
    }
    
    @IBAction func didTappedForCancelVideo(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTappedForCloseAlert(_ sender: Any) {
        self.alertshow(title: "", bool: true)
        if isStatus == "1" {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tab bar")
            self.present(nextViewController, animated: true, completion: nil)
        }
    }
    
    func alertshow(title: String, bool: Bool) {
        self.alertLabel.text = title
        self.alertView.isHidden = bool
        self.alertView1.isHidden = bool
        self.transperentBG.isHidden = bool
    }
    
    func PostDataForSaveVideoInVault() {
        
        if Global.isInternetAvailable() {
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            Global.showActivityIndicator(self.view)
            
            dictPost = ["userid": userid  as AnyObject, "caption": "" as AnyObject, "video_time": "\(playerItem.duration.seconds)" as AnyObject]
            
            WebHelper.requestPostUrlWithFile(strURL: APIName.kkAdd_photo_video, Dictionary: dictPost, AndFilePath: videoURL, forFileParameterName: "vault_file", Success: {
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                let message: String? = success.object(forKey: "message") as? String
                
                /// Result fail
                if resultString == "0" {
                    self.alertshow(title: message ?? "", bool: false)
                }  else if resultString == "1" {
                    self.isStatus = "1"
                    Global.hideActivityIndicator(self.view)
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tab bar")
                    self.present(nextViewController, animated: true, completion: nil)
                } else {
                    self.alertshow(title: message ?? "", bool: false)
                }
            }, Failure: {
                failure in
                Global.hideActivityIndicator(self.view)
            })
        }else {
            Global.hideActivityIndicator(self.view)
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
}

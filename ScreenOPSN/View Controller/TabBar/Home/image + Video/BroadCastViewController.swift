//
//  BroadCastViewController.swift
//  ScreenOPSN
//
//  Created by shadab sheikh on 2020-06-22.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AVFoundation

class BroadCastViewController: UIViewController {
    
    @IBOutlet weak var capturedImageView: UIImageViewProperty!
    @IBOutlet weak var switchOne: UISwitch!
    @IBOutlet weak var switchTwo: UISwitch!
    @IBOutlet weak var switchThree: UISwitch!
    @IBOutlet weak var switchFour: UISwitch!
    @IBOutlet weak var switchFive: UISwitch!
    
    @IBOutlet weak var alertView: UIViewPropertys!
    @IBOutlet weak var alertView1: UIViewPropertys!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var transperentBG: UIView!
    
    @IBOutlet weak var videoView: UIView!
    
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var playerItem: AVPlayerItem!
    var videoURL: URL!
    
    var image: UIImage = UIImage()
    
    var valueOne = "1"
    var valueTwo = "0"
    var valueThree = "0"
    var valueFour = "0"
    var valueFive = "0"
    
    var caption: String = ""
    var broadCastValue: String = ""
    var comment: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchOne.isOn = true
        valueOne = "1"
        switchTwo.isOn = false
        valueTwo = "0"
        switchThree.isOn = false
        valueThree = "0"
        switchFour.isOn = false
        valueFour = "0"
        
        broadCastValue = "0"
        
        if videoURL != nil {
            avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.frame = view.bounds
            avPlayerLayer.videoGravity = .resizeAspectFill
            //   AVLayerVideoGravityResizeAspectFill
            videoView.layer.insertSublayer(avPlayerLayer, at: 0)
            
            view.layoutIfNeeded()
            
            playerItem = AVPlayerItem(url: videoURL as URL)
            avPlayer.replaceCurrentItem(with: playerItem)
            
            avPlayer.play()
        }else {
            capturedImageView.image = image
        }
        
        print("Video URL BCVC=\(videoURL)")

        hideview(hide: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
    }
    
    func hideview(hide: Bool) {
        alertView.isHidden = hide
        alertView1.isHidden = hide
        transperentBG.isHidden = hide
    }
    
    @IBAction func didTappedOff(_ sender: Any) {
        hideview(hide: true)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tab bar")
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTappedOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSwitchOneClk(_ sender: UIButton) {
        switchOne.isOn = true
        valueOne = "1"
        switchTwo.isOn = false
        valueTwo = "0"
        switchThree.isOn = false
        valueThree = "0"
        switchFour.isOn = false
        valueFour = "0"
        broadCastValue = "0"
    }
    
    @IBAction func btnSwitchTwoClk(_ sender: UIButton) {
        
        switchOne.isOn = false
        valueOne = "0"
        switchTwo.isOn = true
        valueTwo = "15"
        switchThree.isOn = false
        valueThree = "0"
        switchFour.isOn = false
        valueFour = "0"
        broadCastValue = "15"
    }
    
    @IBAction func btnSwitchThreeClk(_ sender: UIButton) {
        
        switchOne.isOn = false
        valueOne = "0"
        switchTwo.isOn = false
        valueTwo = "0"
        switchThree.isOn = true
        valueThree = "30"
        switchFour.isOn = false
        valueFour = "0"
        broadCastValue = "30"
    }
    
    @IBAction func btnSwitchFourClk(_ sender: UIButton) {
        
        switchOne.isOn = false
        valueOne = "0"
        switchTwo.isOn = false
        valueTwo = "0"
        switchThree.isOn = false
        valueThree = "0"
        switchFour.isOn = true
        valueFour = "60"
        broadCastValue = "60"
    }
    
    @IBAction func switchOneAction(_ sender: Any) {
        if switchOne.isOn {
            valueOne = "1"
        } else {
            valueOne = "0"
        }
    }
    
    @IBAction func switchTwoAction(_ sender: Any) {
        if switchTwo.isOn {
            switchThree.isOn = false
            switchFour.isOn = false
            switchFive.isOn = false
            valueTwo = "1"
        } else {
            valueTwo = "0"
        }
    }
    
    @IBAction func switchThreeAction(_ sender: Any) {
        if switchThree.isOn {
            switchTwo.isOn = false
            switchFour.isOn = false
            switchFive.isOn = false
            valueThree = "15"
        } else {
            valueThree = "0"
        }
    }
    
    @IBAction func switchFourAction(_ sender: Any) {
        if switchFour.isOn {
            switchTwo.isOn = false
            switchThree.isOn = false
            switchFive.isOn = false
            valueFour = "30"
        } else {
            valueFour = "0"
        }
    }
    
    @IBAction func switchFiveAction(_ sender: Any) {
        if switchFive.isOn {
            switchTwo.isOn = false
            switchFour.isOn = false
            switchThree.isOn = false
            valueFive = "60"
        } else {
            valueFive = "0"
        }
    }
    
    @IBAction func didTappedDoitButton(_ sender: Any) {
        
        /* if videoURL != nil {
         PostDataForSaveVideoInVault()
         }else {
         PostDataForSavePhotoInVault()
         }*/
        
        PostDataForPostLive()
    }
    
    func PostDataForAppSetting(userid: String, save_to_vault: String, broadcast_now: String, broadcast_15min: String, broadcast_30min: String, broadcast_1hour: String) {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            
            var dictPost:[String: AnyObject]!
            
            dictPost = ["userid": userid as AnyObject, "save_to_vault": save_to_vault as AnyObject, "broadcast_now": broadcast_now as AnyObject, "broadcast_15min": broadcast_15min as AnyObject, "broadcast_30min": broadcast_30min as AnyObject, "broadcast_1hour": broadcast_1hour as AnyObject]
            
            WebHelper.requestPostUrl(strURL: APIName.kkUser_app_settings, Dictionary: dictPost, Success:{
                success in
                
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                } else if resultString == "1" {
                    self.hideview(hide: false)
                    Global.hideActivityIndicator(self.view)
                } else {
                }
            }, Failure: {
                failure in
            })
        } else {
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
    
    //MARK :- Adds Upload
    
    func PostDataForPostLive() {
        
        if Global.isInternetAvailable() {
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            Global.showActivityIndicator(self.view)
            dictPost = ["userid": userid  as AnyObject, "caption": caption  as AnyObject, "post_comment": comment  as AnyObject, "broadcast_post_value": broadCastValue  as AnyObject, "video_time" : "" as AnyObject]

            if videoURL != nil {
                WebHelper.requestPostUrlWithFile(strURL: APIName.kkAartist_add_post, Dictionary: dictPost, AndFilePath: videoURL, forFileParameterName: "post_image", Success: {
                    success in
                    let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                    /// Result fail
                    if resultString == "0" {
                        Global.hideActivityIndicator(self.view)
                    }  else if resultString == "1" {
                        Global.hideActivityIndicator(self.view)
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tab bar")
                        self.present(nextViewController, animated: true, completion: nil)
                    } else {
                        Global.hideActivityIndicator(self.view)
                    }

                }, Failure: {
                    failure in
                    Global.hideActivityIndicator(self.view)
                })
            } else {
                WebHelper.requestPostUrlWithImage(strURL: APIName.kkAartist_add_post, Dictionary: dictPost, AndImage: self.capturedImageView.image ?? UIImage(), forImageParameterName: "post_image", Success: {
                    success in
                    let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                    
                    /// Result fail
                    if resultString == "0" {
                        Global.hideActivityIndicator(self.view)
                    }  else if resultString == "1" {
                        Global.hideActivityIndicator(self.view)
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tab bar")
                        self.present(nextViewController, animated: true, completion: nil)
                    } else {
                        Global.hideActivityIndicator(self.view)
                    }
                }, Failure: {
                    failure in
                    Global.hideActivityIndicator(self.view)
                })
            }
        } else {
            Global.hideActivityIndicator(self.view)
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
    
    func PostDataForSavePhotoInVault() {
        
        if Global.isInternetAvailable() {
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            dictPost = ["userid": userid  as AnyObject]
            Global.showActivityIndicator(self.view)
            WebHelper.requestPostUrlWithImage(strURL: APIName.kkAdd_photo_video, Dictionary: dictPost, AndImage: self.capturedImageView.image ?? UIImage(), forImageParameterName: "vault_file", Success: {
                success in
                
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                /// Result fail
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                }  else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tab bar")
                    self.present(nextViewController, animated: true, completion: nil)
                } else {
                    Global.hideActivityIndicator(self.view)
                }
            }, Failure: {
                failure in
                Global.hideActivityIndicator(self.view)
            })
        }else{
            Global.hideActivityIndicator(self.view)
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
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
                /// Result fail
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                }  else if resultString == "1" {
                    
                    Global.hideActivityIndicator(self.view)
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tab bar")
                    self.present(nextViewController, animated: true, completion: nil)
                } else {
                    Global.hideActivityIndicator(self.view)
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

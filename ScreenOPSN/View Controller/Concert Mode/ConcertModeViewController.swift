//
//  ConcertModeViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 11/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import ImageSlideshow
import AVFoundation
import MediaPlayer
import AVKit

extension UIColor {
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    static let defaultOuterColor = UIColor.init(red: 1 / 255, green: 102 / 255, blue: 255 / 255, alpha: 0.5)
    static let defaultInnerColor = UIColor.rgb(1, 102, 255)
    static let defaultPulseFillColor = UIColor.rgb(1, 102, 255)
    static let defaultTextColor = UIColor.white
}

class ConcertModeViewController: UIViewController {
    @IBOutlet weak var videoCollection: UICollectionView!
    
    @IBOutlet weak var sponsorImage: UIImageView!
    @IBOutlet weak var sponsorVideo: UIView!
    
    @IBOutlet weak var profileImageView: UIImageViewProperty!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var btnusername: UIButton!
    
    // MARK: IBOutlet
    @IBOutlet var slideshow: ImageSlideshow!
  
    // MARK: PROPERTIES
    var selectedLink: NSArray = NSArray()

    var player = AVPlayer()
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var videoURL: URL!

    var index: Int = 0
    var next_imagetype: String = "fan"
    var current : NSDictionary = NSDictionary()
    
    @IBOutlet weak var progressView: UIView!
    var progressRing: CircularProgressBar!
    var count = 0
    var totalCount = 0
    var isImage = true
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GlobalConstant.isConcerOn = true
        
        self.sponsorImage.contentMode = .scaleAspectFit;
        self.sponsorImage.backgroundColor = UIColor.black
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.backItem?.hidesBackButton = true
        self.view.backgroundColor = .black
        
        navigationController?.navigationBar.barTintColor = .green
        navigationController?.isNavigationBarHidden = true
        
        profileImageView.isHidden = true
        username.isHidden = true
        btnusername.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        PostDataForGetAds()
        
        let xPosition = 20
        let yPosition = 20
        let position = CGPoint(x: xPosition, y: yPosition)
        
        progressRing = CircularProgressBar(radius: 20, position: position, innerTrackColor: .defaultInnerColor, outerTrackColor: .defaultOuterColor, textColor: .defaultTextColor, lineWidth: 5)
        progressView.layer.addSublayer(progressRing)
        progressRing.progress = 0
        progressRing.progressText = ""
    }
    
    func startCounter(){
        count = 0
        if (timer != nil) {
            timer.invalidate()
        }
        
        progressRing.progress = CGFloat((count * 100)/totalCount)
        progressRing.progressText = "\(Int(totalCount - count))"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.callInterval()
        }
    }
    
    func callInterval(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(incrementCount), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    @objc func incrementCount() {
        count += 1
        progressRing.progress = CGFloat((count * 100)/totalCount)
        progressRing.progressText = "\(Int(totalCount - count))"
        
        if count > totalCount-1 {
            timer.invalidate()
            PostDataForGetAds()
        }
    }
    
    @objc func appMovedToBackground() {
        GlobalConstant.isConcerOn = false
        if (timer != nil) {
            timer.invalidate()
        }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(PostDataForGetAds), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        GlobalConstant.isConcerOn = true
        self.tabBarController?.tabBar.isHidden = true
        
        if current.allKeys.count > 0 {
            let mimetype = current.value(forKey: "mimetype") as! String
            if mimetype == "video/quicktime" {
                self.avPlayer.pause()
            }
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.currentConcertScreen = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.avPlayer.pause()

        if (timer != nil) {
            timer.invalidate()
        }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(PostDataForGetAds), object: nil)

        if current.allKeys.count > 0 {
            let mimetype = current.value(forKey: "mimetype") as! String
            if mimetype == "video/quicktime" {
                self.avPlayer.pause()
            }
        }
    }
    
    @IBAction func profileButtonAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeProfileViewController") as! HomeProfileViewController
        nextViewController.getDataFromSearch = current
        nextViewController.isFromHome = false
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func rateUsButtonAction(_ sender: Any) {
        GlobalConstant.isConcerOn = false
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(PostDataForGetAds), object: nil)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.PostDataForOnOff(is_background: "1")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func PostDataForGetAds() {
        if (timer != nil) {
            timer.invalidate()
        }
        
        let eventID  = Global.getStringValue(UserDefaults.standard.value(forKey: "eventID") as AnyObject)
        var dictPost:[String: AnyObject]!
        dictPost = ["event_id": eventID as AnyObject, "imagetype": next_imagetype as AnyObject]
        
        WebHelper.requestPostUrl(strURL: APIName.kkConcert_mode_contents, Dictionary: dictPost, Success:{ success in
            let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
            if resultString == "0" {
                GlobalConstant.isConcerOn = false
                
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.PostDataForGetAds), object: nil)
                self.navigationController?.popViewController(animated: true)
            }else if resultString == "1" {
                let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                if message == "There is no contents available for this event!" {
                    GlobalConstant.isConcerOn = false
                    
                    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.PostDataForGetAds), object: nil)
                    self.navigationController?.popViewController(animated: true)
                }else {                                        
                    self.next_imagetype = success.object(forKey: "next_imagetype") as! String
                    let resultData: NSDictionary = success.object(forKey: "contents") as! NSDictionary
                    self.setupMedia(resultData: resultData)
                }
            }
        }, Failure: { failure in
            Global.showAlertMessageWithOkButtonAndTitle(GlobalConstant.APP_NAME, andMessage: failure.localizedDescription)
        })
    }
    
    func setupMedia(resultData: NSDictionary) {
        current = resultData
        if current.object(forKey: "imagetype") as! String == "sponsor" {
            self.profileImageView.isHidden = true
            self.username.isHidden = true
            self.btnusername.isHidden = true
        } else {
            self.profileImageView.isHidden = false
            self.username.isHidden = false
            self.btnusername.isHidden = false
        }
        
        let profile_pic = Global.getStringValue(resultData.value(forKey: "profile_pic") as AnyObject)
        if profile_pic.isEmpty == false {
            self.profileImageView.sd_setImage(with: URL(string: profile_pic), placeholderImage: UIImage(named: "imgpsh_fullsize_anim"))
            self.profileImageView.backgroundColor = UIColor.white
        }
        
        self.username.text = Global.getStringValue(resultData.value(forKey: "name") as AnyObject)
        
        let mimetype = resultData.value(forKey: "mimetype") as! String
        if mimetype == "video/quicktime" {
            self.sponsorVideo.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            
            self.sponsorVideo.isHidden = false
            self.sponsorImage.isHidden = true
            
            let video_url = Global.getStringValue(resultData.value(forKey: "video_url") as AnyObject)
            let fileName = (video_url as NSString).lastPathComponent

            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            if let pathComponent = url.appendingPathComponent(fileName) {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {

                    player = AVPlayer(url: URL(fileURLWithPath: filePath))
                    let playerLayer = AVPlayerLayer(player: player)
                    playerLayer.frame = self.sponsorVideo.bounds
                    playerLayer.backgroundColor = UIColor.black.cgColor
                    self.sponsorVideo.layer.addSublayer(playerLayer)
                    player.play()

                    let videoDuration : Int = Int((player.currentItem?.asset.duration.seconds)!)
                    totalCount = videoDuration

                    startCounter()
                } else {

                    player = AVPlayer(url: URL(string: video_url)!)
                    let playerLayer = AVPlayerLayer(player: player)
                    playerLayer.frame = self.sponsorVideo.bounds
                    playerLayer.backgroundColor = UIColor.black.cgColor
                    self.sponsorVideo.layer.addSublayer(playerLayer)
                    player.play()
                 
                    let videoDuration : Int = Int((player.currentItem?.asset.duration.seconds)!)
                    totalCount = videoDuration

                    startCounter()
                    Downloader.load(URL: URL(string: video_url)!)
                }
            } else {

                player = AVPlayer(url: URL(string: video_url)!)
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = self.sponsorVideo.bounds
                playerLayer.backgroundColor = UIColor.black.cgColor
                self.sponsorVideo.layer.addSublayer(playerLayer)
                player.play()
                
                let videoDuration : Int = Int((player.currentItem?.asset.duration.seconds)!)
                totalCount = videoDuration

                startCounter()
                Downloader.load(URL: URL(string: video_url)!)
            }
        }else {

            self.sponsorVideo.isHidden = true
            self.sponsorImage.isHidden = false
         
            sponsorVideo.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

            let fileurl = Global.getStringValue(resultData.value(forKey: "fileurl") as AnyObject)
            let fileName = (fileurl as NSString).lastPathComponent
            
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            if let pathComponent = url.appendingPathComponent(fileName) {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {

                    let image = UIImage(contentsOfFile: filePath)
                    self.sponsorImage.image = image
                    self.sponsorImage.backgroundColor = UIColor.black
                } else {

                    self.sponsorImage.sd_setImage(with: URL(string: fileurl), placeholderImage: UIImage(named: "placeholder"))
                    self.sponsorImage.backgroundColor = UIColor.black
                    Downloader.load(URL: URL(string: fileurl)!)
                }
            } else {

                self.sponsorImage.sd_setImage(with: URL(string: fileurl), placeholderImage: UIImage(named: "placeholder"))
                self.sponsorImage.backgroundColor = UIColor.black
                Downloader.load(URL: URL(string: fileurl)!)
            }

            totalCount = 3
            startCounter()
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        // self.PostDataForGetAds()
    }
}

class Downloader {
    class func load(URL: URL) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            if (error == nil) {
                // Success

                let fileManager = FileManager.default
                do {
                    let fileName = (URL.path as NSString).lastPathComponent
                    
                    let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
                    let fileURL = documentDirectory.appendingPathComponent(fileName)
                    if let imageData = data {
                        try imageData.write(to: fileURL)
                    }
                } catch {
                    // print(error)
                }
            }
            else {
                // Failure
            }
        })
        task.resume()
    }
}

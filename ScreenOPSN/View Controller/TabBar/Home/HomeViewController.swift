//
//  HomeViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 28/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices
import AVFoundation
import FSPagerView
import SafariServices

let kCloseSafariViewControllerNotification = "kCloseSafariViewControllerNotification"

extension UIApplication {
    /// Top visible viewcontroller
    var topMostVisibleViewController : UIViewController? {
        
        if UIApplication.shared.keyWindow?.rootViewController is UINavigationController {
            return (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).visibleViewController
        }
        return nil
    }
}

class HomeViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, QRString, FanCommentViewControllerDelegate, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var noArtistFound: UILabel!
    @IBOutlet weak var othersTableView: UITableView!
    
    @IBOutlet weak var holdImageUIView: UIViewPropertys!
    @IBOutlet weak var capturedImageView: UIImageViewProperty!
    @IBOutlet weak var alertView: UIViewPropertys!
    @IBOutlet weak var alertView1: UIViewPropertys!
    @IBOutlet weak var alertLabel: UILabel!
    
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var transperentBG: UIView!
    @IBOutlet weak var artistCollection: UICollectionView!
    @IBOutlet var vwSlider: FSPagerView!
    
    @IBOutlet weak var buttonVideo: UIButton!
    @IBOutlet weak var buttonCamera: UIButton!
    @IBOutlet weak var buttonGallery: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var customAlertView: UIView!
    
    var arrayartist: NSArray = NSArray()
    var arrayFan: NSArray = NSArray()
    let imagePicker = UIImagePickerController()
    let videoFileName = "/video.mp4"
    var placeholdeImage: UIImage = UIImage()
    
    var tapArtist: Bool = false
    var isRun = "1"
    var count = 0
    var timer = Timer()
    var stopIndex: Int?
    
    var isViewAppear: Bool = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        customAlertView.isHidden = true;
        GlobalConstant.isConcerOn = false
        
        imagePicker.delegate = self
        self.alertshow(title: "", bool: true)
        self.placeholdeImage = UIImage(named: "new_blue_bg")!
        showImageCapturedUI(image: self.placeholdeImage, bool: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("reloadhome"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didBeginToStartConcertMode(notification:)), name: Notification.Name("concertModeOn"), object: nil)
        
        self.othersTableView.estimatedRowHeight = 100
        self.othersTableView.rowHeight = UITableView.automaticDimension
        self.vwSlider.isInfinite = true
        self.vwSlider.automaticSlidingInterval = 4.0
        
        let slider = UINib(nibName: "SliderCC", bundle: Bundle.main)
        self.vwSlider.register(slider, forCellWithReuseIdentifier: "SliderCC")
        PostDataForGetAds(imagetype: "fan")
        
        UITextField.appearance().tintColor = .white
        UITextView.appearance().tintColor = .white
        
        // self.othersTableView.register(FanTableViewCell.self, forCellReuseIdentifier: "FanTableViewCell")

        let roleid = UserDefaults.standard.integer(forKey: "roleid")
        if roleid == 2 {
            lblMessage.text = "Welcome to LiVEwirz! Create your first post and connect with your fans!"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isViewAppear = false
        Global.hideActivityIndicator(self.view)
    }
    
    @objc func appMovedToForeground() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.PostDataForGetAds(imagetype: "fan")
        })
    }
    
    @objc func didBeginToStartConcertMode(notification: Notification) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let navigationController : UINavigationController = appDelegate.getVisibleViewController(nil)! as! UINavigationController
        let visibleViewController : UIViewController = navigationController.viewControllers[navigationController.viewControllers.count-1]
        
        if visibleViewController.isKind(of: VideoViewController.self) == false && visibleViewController.isKind(of: BroadCastViewController.self) == false {
            PostDataForGetAds(imagetype: "fan")
        }
    }
    
    func PostDataForGetAds(imagetype: String) {
        
        let eventID  = Global.getStringValue(UserDefaults.standard.value(forKey: "eventID") as AnyObject)
        
        var dictPost:[String: AnyObject]!
        dictPost = ["event_id": eventID as AnyObject, "imagetype": imagetype as AnyObject]
        
        WebHelper.requestPostUrl(strURL: APIName.kkConcert_mode_contents, Dictionary: dictPost, Success:{ success in
            let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
            
            if resultString == "0" {
                
            }else if resultString == "1" {
                let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                if message == "There is no contents available for this event!" {
                    
                }else {
                    let eventStart = Global.getStringValue(UserDefaults.standard.value(forKey: "eventStart") as AnyObject)
                    
                    if eventStart == "1"  {
                        if GlobalConstant.isConcerOn == false {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ConcertModeViewController") as! ConcertModeViewController
                            self.navigationController?.pushViewController(nextViewController, animated: true)
                        }
                    }
                }
            }
        }, Failure: { failure in
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isViewAppear = true
        
        self.tabBarController?.tabBar.isHidden = false
        GlobalConstant.isConcerOn = false
        self.isRun = "1"
        
        Global.navigatioinBarClear(vc: self)
        buttonVideo.isEnabled = true
        buttonCamera.isEnabled = true
        buttonGallery.isEnabled = true
        searchButton.isEnabled = true
        
        PostDataForGetArtistPost()
        PostDataForGetFanPost()
    }
    
    func getstringForQR(QrString: String) {
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            dictPost = ["userid": userid as AnyObject, "qrtext": QrString as AnyObject]
            
            WebHelper.requestPostUrl(strURL: APIName.kkEvent_info_after_scan_qrcode, Dictionary: dictPost, Success:{
                success in
                
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    self.alertshow(title: message, bool: false)
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    if self.isRun == "1" {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ExclusiveDataViewController") as! ExclusiveDataViewController
                        nextViewController.exclusiveData = success.object(forKey: "response") as! NSArray
                        self.navigationController?.pushViewController(nextViewController, animated: true)
                        self.isRun = "0"
                    }
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
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        PostDataForGetArtistPost()
        PostDataForGetFanPost()
    }
    
    // MARK : - Button Action
    
    @IBAction func didTappedQRAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "QRViewController") as! QRViewController
        nextViewController.getQRStringDelegate = self
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func didTappedSearchEventAction(_ sender: Any) {
        searchButton.isEnabled = false
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EventSearchViewController") as! EventSearchViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func didTappedNext(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LanyardViewController") as! LanyardViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func didTappedCamera(_ sender: Any) {
        openCamera()
    }
    
    @IBAction func didTappedGallery(_ sender: Any) {
        openGallery()
    }
    
    @IBAction func didTappedVideo(_ sender: Any) {
        buttonVideo.isEnabled = false
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func didTappedOk(_ sender: Any) {
        customAlertView.isHidden = true;
    }
    
    // MARK : - CAMERA & GALLERY
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.videoMaximumDuration = TimeInterval(23.0)
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeVideo as String]
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            customAlertView.isHidden = false
        }
    }
    
    func openGallery()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.videoMaximumDuration = TimeInterval(23.0)
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeVideo as String]
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            customAlertView.isHidden = false
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.dismiss(animated: true, completion: nil)
        let roleid = UserDefaults.standard.integer(forKey: "roleid")
        if roleid == 2 {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ImageSavedAndPostViewController") as! ImageSavedAndPostViewController
            nextViewController.image = image
            self.navigationController?.pushViewController(nextViewController, animated: true)
        } else {
            showImageCapturedUI(image: image, bool: false)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showImageCapturedUI(image: UIImage, bool: Bool) {
        transperentBG.isHidden = bool
        holdImageUIView.isHidden = bool
        capturedImageView.image = image
    }
    
    @IBAction func didTappedLikeDislikeAction(_ sender: Any) {
        self.tapArtist = true
        let dic = self.arrayFan[(sender as AnyObject).tag]
        let status = Global.getStringValue((dic as AnyObject).object(forKey: "like_status") as AnyObject)
        
        var passvalue = ""
        if status == "0" {
            passvalue = "1"
        } else {
            passvalue = "0"
        }
        self.PostDataForLikeDislike(status: passvalue, postid: Global.getStringValue((dic as AnyObject).object(forKey: "postid") as AnyObject))
    }
    
    @IBAction func didTappedCommentAction(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FanCommentViewController") as! FanCommentViewController
        nextViewController.delegate = self
        let dic = self.arrayFan[(sender as AnyObject).tag]
        nextViewController.postid = Global.getStringValue((dic as AnyObject).object(forKey: "postid") as AnyObject)
        self.navigationController?.hidesBottomBarWhenPushed = true
        nextViewController.hidesBottomBarWhenPushed = true

        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func didTappedArtistLikeDislikeAction(_ sender: Any) {
        self.tapArtist = false
        
        let dic = self.arrayartist[(sender as AnyObject).tag]
        let status = Global.getStringValue((dic as AnyObject).object(forKey: "like_status") as AnyObject)
        var passvalue = ""
        if status == "0" {
            passvalue = "1"
        } else {
            passvalue = "0"
        }
        self.PostDataForLikeDislike(status: passvalue, postid: Global.getStringValue((dic as AnyObject).object(forKey: "postid") as AnyObject))
    }
    
    @IBAction func didTappedArtistCommentAction(_ sender: Any) {
        //self.alertshow(title: "This functionality is under Development", bool: false)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FanCommentViewController") as! FanCommentViewController
        nextViewController.delegate = self
        let dic = self.arrayartist[(sender as AnyObject).tag]
        nextViewController.postid = Global.getStringValue((dic as AnyObject).object(forKey: "postid") as AnyObject)
        nextViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func didPressedBack() {
        PostDataForGetArtistPost()
        PostDataForGetFanPost()
    }
    
    // share text
    @IBAction func shareTextButton(_ sender: UIButton) {
        
        // text to share
        
        let dic = self.arrayFan[(sender as AnyObject).tag]
        
        let text = Global.getStringValue((dic as AnyObject).object(forKey: "post_by_username") as AnyObject)
        let image = Global.getStringValue((dic as AnyObject).object(forKey: "post_comment") as AnyObject)
        let post_comment = Global.getStringValue((dic as AnyObject).object(forKey: "post_url") as AnyObject)
        
        let user_name = UserDefaults.standard.value(forKey: "name") as! String
        
        
        // set up activity view controller
        let textToShare = ["LiVEwirz\nChecck out \(user_name) LiVEwirz\n\(text), \(post_comment), \(image)\n\n#LiVEwirz" ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //     activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTappedReportAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ReportViewController") as! ReportViewController
        let dic = self.arrayFan[(sender as AnyObject).tag]
        
        nextViewController.dataDict = dic as! NSDictionary
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func didTappedSaveButton(_ sender: Any) {
        PostDataForSavePhotoInVault()
    }
    
    @IBAction func didTappedCancelButton(_ sender: Any) {
        showImageCapturedUI(image: self.placeholdeImage, bool: true)
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let lable = gesture.view as! UILabel
        
        let array = lable.text?.components(separatedBy: "by")
        let termsRange = (lable.text! as NSString).range(of: (array?.last!)!)
        
        if gesture.didTapAttributedTextInLabel(label: lable, inRange: termsRange) {
            
            let fanPost = arrayFan[lable.tag] as! NSDictionary
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeProfileViewController") as! HomeProfileViewController
            let suggestionData = fanPost
            nextViewController.getDataFromSearch = suggestionData
            nextViewController.isFromHome = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    func showPreview(fanPost : NSDictionary) {
        
        print(fanPost)
        
        let filetype = Global.getStringValue(fanPost.value(forKey: "filetype") as AnyObject)
        var url: URL!
        var reviewImage: String = ""
        var isImage = true
        
        if filetype == "video" {
            isImage = false
            let strUrl = Global.getStringValue(fanPost.value(forKey: "fileurl") as AnyObject)
            url = URL(string: strUrl)!
        } else {
            reviewImage = Global.getStringValue(fanPost.value(forKey: "fileurl") as AnyObject)
        }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let postViewControllerPreview = storyBoard.instantiateViewController(withIdentifier: "PostViewControllerPreview") as! PostViewControllerPreview
        postViewControllerPreview.isImage = isImage
        postViewControllerPreview.imageURL = reviewImage
        postViewControllerPreview.videoURL = url
        self.navigationController?.pushViewController(postViewControllerPreview, animated: true)
    }
    
    func PostDataForLikeDislike(status: String, postid: String) {
        
        if Global.isInternetAvailable() {
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            
            dictPost = ["userid": userid as AnyObject, "postid": postid as AnyObject,"status": status as AnyObject,]
            
            WebHelper.requestPostUrl(strURL: APIName.kkPost_like_unlike, Dictionary: dictPost, Success:{
                success in
                
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                if resultString == "1" {
                    DispatchQueue.main.async {
                        if !self.tapArtist {
                            self.PostDataForGetArtistPost()
                        } else {
                            self.PostDataForGetFanPost()
                        }
                    }
                }
            }, Failure: {
                failure in
            })
        } else {
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
    
    func PostDataForGetArtistPost() {
        
        if Global.isInternetAvailable() {
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            dictPost = ["userid": userid as AnyObject]
            
            WebHelper.requestPostUrl(strURL: APIName.kkArtists_followed_posts_list, Dictionary: dictPost, Success:{
                
                success in
                
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                if resultString == "0" {
                    self.noArtistFound.isHidden = false
                    self.artistCollection.isHidden = true
                    self.vwSlider.isHidden = true
                } else if resultString == "1" {
                    self.noArtistFound.isHidden = true
                    self.artistCollection.isHidden = false
                    self.vwSlider.isHidden = false
                    self.arrayartist = success.object(forKey: "artist_posts") as! NSArray
                    DispatchQueue.main.async {
                        self.artistCollection.reloadData()
                        self.vwSlider.reloadData()
                    }
                } else {
                }
            }, Failure: {
                failure in
            })
        } else {
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
    
    //MARK :- Fan Post Retrive
    
    func PostDataForGetFanPost() {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            
            dictPost = ["userid": userid as AnyObject]
            
            WebHelper.requestPostUrl(strURL: APIName.kkHomeposts_list, Dictionary: dictPost, Success:{
                success in
                
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                } else if resultString == "1" {
                    self.arrayFan = success.object(forKey: "fan_posts") as! NSArray
                    DispatchQueue.main.async {
                        self.othersTableView.reloadData()
                    }
                    let seconds = 5.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        Global.hideActivityIndicator(self.view)
                    }
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
    
    //MARK :- Adds Upload
    
    func PostDataForSavePhotoInVault() {
        if Global.isInternetAvailable() {
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            Global.showActivityIndicator(self.view)
            
            dictPost = ["userid": userid  as AnyObject, "caption": "" as AnyObject, "video_time": "" as AnyObject]
            
            WebHelper.requestPostUrlWithImage(strURL: APIName.kkAdd_photo_video, Dictionary: dictPost, AndImage: self.capturedImageView.image!, forImageParameterName: "vault_file", Success: {
                success in
                
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                let message: String? = success.object(forKey: "message") as? String
                
                /// Result fail
                if resultString == "0" {
                    self.alertshow(title: message ?? "", bool: false)
                    self.showImageCapturedUI(image: self.capturedImageView.image!, bool: true)
                }  else if resultString == "1" {
                    NotificationCenter.default.post(name: Notification.Name("reloadhome"), object: nil)
                    self.showImageCapturedUI(image: self.capturedImageView.image!, bool: true)
                    self.alertshow(title: message ?? "", bool: false)
                    
                    Global.hideActivityIndicator(self.view)
                } else {
                    self.alertshow(title: message ?? "", bool: false)
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
    
    @IBAction func didTappedOkButton(_ sender: Any) {
        self.alertshow(title: "", bool: true)
    }
    
    func alertshow(title: String, bool: Bool) {
        self.alertLabel.text = title
        self.alertView.isHidden = bool
        self.alertView1.isHidden = bool
        self.transperentBG.isHidden = bool
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

extension Range where Bound == String.Index {
    var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                       length: self.upperBound.encodedOffset -
                       self.lowerBound.encodedOffset)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: FanTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FanTableViewCell", for: indexPath) as! FanTableViewCell
        let fanPost = arrayFan[indexPath.row] as! NSDictionary
        
        var post_comment = "\(Global.getStringValue(fanPost.value(forKey: "post_comment") as AnyObject))"
        post_comment = post_comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var post_by_username = "\(Global.getStringValue(fanPost.value(forKey: "post_by_username") as AnyObject))"
        post_by_username = post_by_username.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var post_location = "\(Global.getStringValue(fanPost.value(forKey: "post_location") as AnyObject))"
        post_location = post_location.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var string = post_comment.isEmpty ? "by " + "@" + post_by_username : post_comment + " by " + "@" + post_by_username
        string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var event_name = "\(Global.getStringValue(fanPost.value(forKey: "event_name") as AnyObject))"
        event_name = event_name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        cell.eventName.text = event_name
        cell.postName.text = string
        cell.postName.textColor =  UIColor.black
        cell.postName.tag = indexPath.row
        
        let text = string
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "@" + post_by_username)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: range1)
        cell.postName.attributedText = underlineAttriString
        cell.postName.isUserInteractionEnabled = true
        cell.postName.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        cell.postName.sizeToFit()
        
        cell.postDate.text = Global.getStringValue(fanPost.value(forKey: "post_date") as AnyObject)
        cell.postLocation.text = post_location.isEmpty ? "NA" : post_location
        
        let totalComment = Global.getStringValue(fanPost.value(forKey: "total_comments") as AnyObject)
        
        if totalComment != "0" {
            cell.totalComment.text = totalComment
        }else {
            cell.totalComment.text = ""
        }
        
        let totalLikes = Global.getStringValue(fanPost.value(forKey: "total_likes") as AnyObject)
        
        if totalLikes != "0" {
            cell.totalLikes.text =  totalLikes
        }else {
            cell.totalLikes.text =  ""
        }
        
        let status = Global.getStringValue(fanPost.value(forKey: "like_status") as AnyObject)
        
        if status == "0" {
            cell.likeImg.setImage(UIImage(named: "heartblank.png")!.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.likeImg.tintColor = .lightGray
        } else {
            cell.likeImg.setImage(UIImage(named: "liked.png")!.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.likeImg.tintColor = .red
        }
        
        cell.commentButton.setImage(UIImage(named: "comment.png")!.withRenderingMode(.alwaysTemplate), for: .normal)
        cell.commentButton.tintColor = .lightGray
        
        cell.reportButton.setImage(UIImage(named: "alert.png")!.withRenderingMode(.alwaysTemplate), for: .normal)
        cell.reportButton.tintColor = .lightGray
        
        cell.shareButton.setImage(UIImage(named: "sharee.png")!.withRenderingMode(.alwaysTemplate), for: .normal)
        cell.shareButton.tintColor = .lightGray
        
        cell.likeImg.tag = indexPath.row
        cell.commentButton.tag = indexPath.row
        cell.reportButton.tag = indexPath.row
        cell.shareButton.tag = indexPath.row
        
        if fanPost.value(forKey: "thumbnail") as! String != "" {
            let str = Global.getStringValue(fanPost.value(forKey: "thumbnail") as AnyObject)
            cell.postImage.sd_setImage(with: URL(string: str), placeholderImage: UIImage(named: "imgpsh_fullsize_anim"))
        }else{
            cell.postImage.image = UIImage(named: "imgpsh_fullsize_anim")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fanPost = arrayFan[indexPath.row] as! NSDictionary
        showPreview(fanPost: fanPost)
    }
    
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch _ {
            let thumbnail = UIImage(named: "Video camera")
            return thumbnail
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayartist.count
    }
    
    @objc func buttonClicked(_ sender: AnyObject?) {
        let button = sender as! UIButton
        let artistPost = arrayartist[button.tag] as! NSDictionary
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeProfileViewController") as! HomeProfileViewController
        let suggestionData = artistPost
        nextViewController.getDataFromSearch = suggestionData
        nextViewController.isFromHome = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MySelfCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MySelfCollectionViewCell", for: indexPath) as! MySelfCollectionViewCell
        
        cell.btnartistName.tag = indexPath.item
        cell.btnartistName.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        let artistPost = arrayartist[indexPath.row] as! NSDictionary
        let str = Global.getStringValue(artistPost.value(forKey: "user_profile_pic") as AnyObject)
        cell.artistProfile.sd_setImage(with: URL(string: str), placeholderImage: UIImage(named: "imgpsh_fullsize_anim"))
        let str2 = Global.getStringValue(artistPost.value(forKey: "post_img_url") as AnyObject)
        cell.artistImage.sd_setImage(with: URL(string: str2), placeholderImage: UIImage(named: "imgpsh_fullsize_anim"))
        
        cell.artistName.text = Global.getStringValue(artistPost.value(forKey: "post_by_username") as AnyObject)
        cell.shortCommentLabel.text = Global.getStringValue(artistPost.value(forKey: "post_comment") as AnyObject)
        cell.postLocationLabel.text = Global.getStringValue(artistPost.value(forKey: "created_on") as AnyObject)
        
        cell.total_likes.text = Global.getStringValue(artistPost.value(forKey: "total_likes") as AnyObject)
        cell.total_comments.text = Global.getStringValue(artistPost.value(forKey: "total_comments") as AnyObject)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let status = Global.getStringValue(artistPost.value(forKey: "like_status") as AnyObject)
        
        if status == "0" {
            cell.likeButton.setImage(#imageLiteral(resourceName: "white hrt"), for: .normal)
        } else {
            cell.likeButton.setImage(#imageLiteral(resourceName: "liked"), for: .normal)
            
        }
        cell.likeButton.tag = indexPath.row
        cell.commentButton.tag = indexPath.row
        cell.tag = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        //Set collection view layout
        return CGSize(width: (GlobalConstant.SCREENWIDTH)/1, height: 450)
    }
    
    func startTimer() {
        self.timer =  Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: false)
    }
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        if let coll = artistCollection {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)! < arrayartist.count - 1) {
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                } else {
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: false)
                }
            }
        }
    }
    
    func timeAgo(date: Date) -> String {
        
        let secondsAgo = Int(Date().timeIntervalSince(date))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
    }
}

// MARK: FAPager Datasource Method
extension HomeViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if(isViewAppear){
            return self.arrayartist.count
        }
        return 0
    }
    
    func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSPagerViewCell, forItemAt index: Int){
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "SliderCC", at: index) as! SliderCC
        let artistPost = arrayartist[index] as! NSDictionary
        let filetype = Global.getStringValue(artistPost.value(forKey: "filetype") as AnyObject)
        if filetype == "video" {
            cell.playVw.playerLayer.player = nil
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "SliderCC", at: index) as! SliderCC
        cell.btnartistName.tag = index
        cell.btnartistName.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        let artistPost = arrayartist[index] as! NSDictionary
        let filetype = Global.getStringValue(artistPost.value(forKey: "filetype") as AnyObject)
        let str = Global.getStringValue(artistPost.value(forKey: "user_profile_pic") as AnyObject)
        cell.artistProfile.sd_setImage(with: URL(string: str), placeholderImage: UIImage(named: "imgpsh_fullsize_anim"))
        cell.btnPlay.isHidden = true
        cell.playVw.isHidden = true
        if filetype == "video" {
            cell.btnPlay.isHidden = false
            let strURL = Global.getStringValue(artistPost.value(forKey: "fileurl") as AnyObject)
            let url: URL = URL(string: strURL)!
            let image = self.generateThumbnail(path: url)
            if image != nil {
                cell.artistImage.image = image!
            }
            if self.stopIndex == index {
                cell.playVw.isHidden = false
                cell.btnPlay.isHidden = true
                DispatchQueue.main.async {
                    let player = AVPlayer(url: url)
                    cell.playVw.playerLayer.player = player
                    cell.playVw.player?.play()
                    NotificationCenter.default.addObserver(self, selector: #selector(self.finishPlay), name: .AVPlayerItemDidPlayToEndTime, object: nil)
                }
            }
        } else {
            let str2 = Global.getStringValue(artistPost.value(forKey: "post_img_url") as AnyObject)
            cell.artistImage.sd_setImage(with: URL(string: str2), placeholderImage: UIImage(named: "imgpsh_fullsize_anim"))
        }
        cell.artistName.text = Global.getStringValue(artistPost.value(forKey: "post_by_username") as AnyObject)
        cell.shortCommentLabel.text = Global.getStringValue(artistPost.value(forKey: "post_comment") as AnyObject)
        cell.postLocationLabel.text = Global.getStringValue(artistPost.value(forKey: "created_on") as AnyObject)
        
        cell.total_likes.text = Global.getStringValue(artistPost.value(forKey: "total_likes") as AnyObject)
        cell.total_comments.text = Global.getStringValue(artistPost.value(forKey: "total_comments") as AnyObject)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let status = Global.getStringValue(artistPost.value(forKey: "like_status") as AnyObject)
        
        if status == "0" {
            cell.likeButton.setImage(#imageLiteral(resourceName: "white hrt"), for: .normal)
        } else {
            cell.likeButton.setImage(#imageLiteral(resourceName: "liked"), for: .normal)
        }
        cell.likeButton.tag = index
        cell.commentButton.tag = index
        cell.btnPlay.tag = index
        cell.tag = index
        cell.likeButton.addTarget(self, action: #selector(self.didTappedArtistLikeDislikeAction(_:)), for: .touchUpInside)
        cell.btnPlay.addTarget(self, action: #selector(self.btnPlayClk(_:)), for: .touchUpInside)
        cell.commentButton.addTarget(self, action: #selector(self.didTappedArtistCommentAction(_:)), for: .touchUpInside)
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        if index != self.stopIndex {
            self.stopIndex = nil
            self.vwSlider.automaticSlidingInterval = 3.0
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        Global.showActivityIndicator(self.view)
        var isImage = true
        let artistPost = arrayartist[index] as! NSDictionary
        let filetype = Global.getStringValue(artistPost.value(forKey: "filetype") as AnyObject)
        var url: URL!
        var reviewImage: String = ""
        if filetype == "video" {
            isImage = false
            let strUrl = Global.getStringValue(artistPost.value(forKey: "fileurl") as AnyObject)
            url = URL(string: strUrl)!
        } else {
            reviewImage = Global.getStringValue(artistPost.value(forKey: "post_img_url") as AnyObject)
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        nextViewController.isImage = isImage
        nextViewController.reviewImage = reviewImage
        nextViewController.videoURL = url
        nextViewController.isPost = true
        nextViewController.strComment = Global.getStringValue(artistPost.value(forKey: "post_comment") as AnyObject)
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func btnPlayClk(_ sender: UIButton) {
        self.vwSlider.automaticSlidingInterval = 0.0
        self.stopIndex = sender.tag
        self.vwSlider.reloadData()
    }
    
    @objc func finishPlay() {
        self.stopIndex = nil
        self.vwSlider.automaticSlidingInterval = 3.0
        self.vwSlider.reloadData()
    }
}

extension HomeViewController{
    
    @IBAction func initMerchant(_ sender: UIButton) {
        performLogin(offline: false)
    }
    
    func performLogin(offline: Bool) {
        // Set your URL for your backend server that handles OAuth.  This sample uses an instance of the
        // sample retail node server that's available at https://github.com/paypal/paypal-retail-node. To
        // set this to Live, simply change /sandbox to /live.  The returnTokenOnQueryString value tells
        // the sample server to return the actual token values instead of the compositeToken
        let url = NSURL(string: "http://pph-retail-sdk-sample.herokuapp.com/toPayPal/" + "sandbox" + "?returnTokenOnQueryString=true")
        
        // Check if there's a previous token saved in UserDefaults and, if so, use that.  This will also
        // check that the saved token matches the environment.  Otherwise, kick open the
        // SFSafariViewController to expose the login and obtain another token.
        let tokenDefault = UserDefaults.init()
        if((tokenDefault.string(forKey: "ACCESS_TOKEN") != nil) && ("sandbox" == tokenDefault.string(forKey: "ENVIRONMENT"))) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kCloseSafariViewControllerNotification), object: tokenDefault.string(forKey: "ACCESS_TOKEN"))
        } else {
            // Present a SFSafariViewController to handle the login to get the merchant account to use.
            let svc = SFSafariViewController(url: url! as URL)
            svc.delegate = self
            self.present(svc, animated: true, completion: nil)
        }
    }
    
    // This function would be called if the user pressed the Done button inside the SFSafariViewController.
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    }
}

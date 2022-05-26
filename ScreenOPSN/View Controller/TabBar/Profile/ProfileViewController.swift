//
//  ProfileViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 28/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import AlamofireImage
import AVFoundation

class ProfileViewController: UIViewController, FanCommentViewControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageViewProperty!
    @IBOutlet weak var labelProfileName: UILabel!
    
    @IBOutlet weak var labelPosts: UILabel!
    @IBOutlet weak var labelFollowers: UILabel!
    @IBOutlet weak var labelFollowing: UILabel!
    
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelBirthdate: UILabel!
    @IBOutlet weak var labelEmailAddress: UILabel!
    @IBOutlet weak var textMobileNumber: UITextField!
    @IBOutlet weak var textAddress: UITextField!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    
    @IBOutlet weak var switchPublic: UISwitch!
    
    @IBOutlet weak var transparentBackground: UIView!
    @IBOutlet weak var popView: UIViewPropertys!
    @IBOutlet weak var profileView: UIViewPropertys!
    
    // My detail view objects
    @IBOutlet weak var myFriendTableView: UITableView!
    @IBOutlet weak var scrollProfile: UIScrollView!
    
    var arrayFan: NSArray = NSArray()
    var arrFollowersList = [AppContactFilterModel]()
    var arrFollowingsList = [AppContactFilterModel]()
    var profileDataType = "post"
    
    var resultData: NSDictionary = NSDictionary()
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view7: UIView!
    @IBOutlet weak var view8: UIView!
    @IBOutlet weak var view9: UIView!
    @IBOutlet weak var view10: UIView!
    @IBOutlet weak var view11: UIView!
    @IBOutlet weak var view12: UIView!
    @IBOutlet weak var view13: UIView!
    @IBOutlet weak var view14: UIView!
    @IBOutlet weak var view15: UIView!
    @IBOutlet weak var view16: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchPublic.isOn = false
        profileDataType = "post"
        
        myFriendTableView.estimatedRowHeight = 0
        
        hideDeleteView(hide: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("profile"), object: nil)
        
        if (Global.getStringValue(UserDefaults.standard.value(forKey: "rolename") as AnyObject)) == "Fan" {
            view10.translatesAutoresizingMaskIntoConstraints = true
            view10.frame = CGRect.init(x: view10.frame.origin.x, y: view10.frame.origin.y, width: view10.frame.size.width, height: 0)
        }
        updateUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //call any function
            self.updateUI()
        }
    }
    
    func updateUI()  {
        textMobileNumber.placeholder = " "
        textAddress.placeholder = " "
        
        view1.customViewProperty()
        view2.customViewProperty()
        view3.customViewProperty()
        view4.customViewProperty()
        view5.customViewProperty()
        view6.customViewProperty()
        view7.customViewProperty()
        view8.customViewProperty()
        view9.customViewProperty()
        view10.customViewProperty()
        view11.customViewProperty()
        view12.customViewProperty()
        view13.customViewProperty()
        view14.customViewProperty()
        view15.customViewProperty()
        view16.customViewProperty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        postDataForGetUserProfile()
        Global.setNavBarColor_isTranslucentTruef(vc: self)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        postDataForGetUserProfile()
    }
    
    func hideDeleteView(hide: Bool) {
        self.transparentBackground.isHidden = hide
        self.popView.isHidden = hide
        self.profileView.isHidden = hide
    }
    
    @IBAction func shareButtonAction(sender: AnyObject) {
        let someText:String = "www.livewirz.com - Connect with me on LiVEwirz and get exclusive in-event backstage videos! Don’t miss out!"
        let sharedObjects:[AnyObject] = [someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.postToTwitter, UIActivity.ActivityType.mail]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func rateUsButtonAction(_ sender: Any) {
        rateApp()
    }
    
    func rateApp() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/" + "1500807007") else {
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func onPressShowProfile(_ sender: Any) {
        myFriendTableView.isHidden = true
        scrollProfile.isHidden = false
        self.myFriendTableView.reloadData()
    }
    
    @IBAction func onPressShowPost(_ sender: Any) {
        profileDataType = "post"
        myFriendTableView.isHidden = false
        scrollProfile.isHidden = true
        self.myFriendTableView.reloadData()
    }
    
    @IBAction func onPressShowFollowers(_ sender: Any) {
        profileDataType = "followers"
        myFriendTableView.isHidden = false
        scrollProfile.isHidden = true
        self.myFriendTableView.reloadData()
    }
    
    @IBAction func onPressShowFollowings(_ sender: Any) {
        profileDataType = "followings"
        myFriendTableView.isHidden = false
        scrollProfile.isHidden = true
        self.myFriendTableView.reloadData()
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
    
    @IBAction func didTappedLikeDislikeAction(_ sender: Any) {
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
        // self.alertshow(title: "This functionality is under Development", bool: false)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FanCommentViewController") as! FanCommentViewController
        nextViewController.delegate = self
        let dic = self.arrayFan[(sender as AnyObject).tag]
        nextViewController.postid = Global.getStringValue((dic as AnyObject).object(forKey: "postid") as AnyObject)
        self.navigationController?.pushViewController(nextViewController, animated: true)
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
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTappedReport(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ReportViewController") as! ReportViewController
        let dic = self.arrayFan[(sender as AnyObject).tag]
        nextViewController.dataDict = dic as! NSDictionary
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func didTappedOnShareAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
        nextViewController.resultData = resultData
        if profileImage != nil {
            nextViewController.profile = profileImage.image ?? UIImage(named: "imgpsh_fullsize_anim")!
        }
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func didTappedOnFeedbackAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FeedBackViewController") as! FeedBackViewController
        if profileImage != nil {
            nextViewController.profile = profileImage.image ?? UIImage(named: "imgpsh_fullsize_anim")!
        }
        nextViewController.profilename = labelProfileName.text!
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func didTappedEditProfileAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func didTappedPostSettingsAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ArtistSettingViewController") as! ArtistSettingViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func didTappedChangePasswordAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func didTappedOnTermsAndCoditionAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTappedOnSignOuButton(_ sender: Any) {
        hideDeleteView(hide: false)
    }
    
    @IBAction func onTapLogout(_ sender: Any) {
        hideDeleteView(hide: true)
        self.postDataForUserLogout()
    }
    
    @IBAction func onTapSwitchPublic(_ sender: UISwitch) {
        self.PostDataForAddsUpload()
    }
    
    @IBAction func onTapNo(_ sender: Any) {
        hideDeleteView(hide: true)
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
                        self.PostDataForGetMyPost()
                    }
                }
            }, Failure: {
                failure in
            })
        } else {
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
    
    func postDataForUserLogout() {
        
        if Global.isInternetAvailable() {
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            
            dictPost = ["userid": userid as AnyObject]
            
            WebHelper.requestPostUrl(strURL: APIName.kkUser_logout, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                if resultString == "0" {
                    
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    
                    UserDefaults.standard.setValue("00", forKey: "isLogin")
                    UserDefaults.standard.setValue("0", forKey: "eventStart")
                    UserDefaults.standard.setValue(nil, forKey: "eventID")

                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginActionViewController") as! LoginActionViewController
                    nextViewController.modalPresentationStyle = .fullScreen
                    let navigation : UINavigationController = UINavigationController(rootViewController: nextViewController)
                    navigation.setNavigationBarHidden(true, animated: false);
                    navigation.modalPresentationStyle = .fullScreen
                    
                    UIApplication.shared.windows.first?.rootViewController = navigation
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            }, Failure: {
                failure in
            })
        } else {
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
    
    func postDataForGetUserProfile() {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            dictPost = ["userid": userid as AnyObject]
            WebHelper.requestPostUrl(strURL: APIName.kkUser_profile, Dictionary: dictPost, Success:{
                success in
                let resultDict:NSDictionary? = success.object(forKey: "response") as? NSDictionary
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                if resultString == "0" {
                } else if resultString == "1" {
                    self.resultData = resultDict!
                    self.setProfileData(resultData: resultDict!)
                }
                self.PostDataForGetMyPost()
            }, Failure: {
                failure in
                self.PostDataForGetMyPost()
            })
        } else {
            Global.hideActivityIndicator(self.view)
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
    
    func PostDataForAddsUpload() {
        if Global.isInternetAvailable() {
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            Global.showActivityIndicator(self.view)
            
            let name = Global.getStringValue(resultData.value(forKey: "name") as AnyObject)
            let dob =  Global.getStringValue(resultData.value(forKey: "dob") as AnyObject)
            let address = Global.getStringValue(resultData.value(forKey: "address") as AnyObject)
            let city_name = Global.getStringValue(resultData.value(forKey: "city_name") as AnyObject)
            let phone_no = Global.getStringValue(resultData.value(forKey: "phone_no") as AnyObject)
            let email = Global.getStringValue(resultData.value(forKey: "email") as AnyObject)
            let state_id = Global.getStringValue(resultData.value(forKey: "state_id") as AnyObject)
            let user_profile =  switchPublic.isOn ? "public" : "private"
            
            dictPost = ["user_profile": user_profile  as AnyObject, "userid": userid  as AnyObject, "name": name as AnyObject, "address": address as AnyObject, "dob": dob  as AnyObject, "cityname": city_name  as AnyObject, "phone_no": phone_no as AnyObject, "email": email as AnyObject, "state_id": state_id as AnyObject]
            
            WebHelper.requestPostUrlWithImage(strURL: APIName.kkUpdate_profile, Dictionary: dictPost, AndImage: self.profileImage.image!, forImageParameterName: "profile_pic", Success: {
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                /// Result fail
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                }
                else if resultString == "1" {
                    NotificationCenter.default.post(name: Notification.Name("profile"), object: nil)
                    Global.hideActivityIndicator(self.view)
                    self.navigationController?.popToRootViewController(animated: true)
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
    
    func PostDataForGetMyPost() {
        if Global.isInternetAvailable() {
            var dictPost:[String: AnyObject]!
            dictPost = ["userid": UserDefaults.standard.value(forKey: "userid") as AnyObject]
            WebHelper.requestPostUrl(strURL: APIName.kkMy_post_list, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                } else if resultString == "1" {
                    self.arrayFan = success.object(forKey: "response") as! NSArray
                    DispatchQueue.main.async {
                        self.myFriendTableView.reloadData()
                    }
                    let seconds = 5.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        Global.hideActivityIndicator(self.view)
                    }
                } else {
                    Global.hideActivityIndicator(self.view)
                }
                self.PostDataForGetFollowersList()
            }, Failure: {
                failure in
                Global.hideActivityIndicator(self.view)
            })
        } else {
            Global.hideActivityIndicator(self.view)
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
    
    func PostDataForGetFollowersList() {
        
        if Global.isInternetAvailable() {
            var dictPost:[String: AnyObject]!
            dictPost = ["userid": UserDefaults.standard.value(forKey: "userid") as AnyObject]
            WebHelper.requestPostUrl(strURL: APIName.kkMy_frnd_list, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                } else if resultString == "1" {
                    
                    self.arrFollowersList = []
                    self.arrFollowingsList = []
                    
                    let followed:NSArray =  (success.object(forKey: "followed") as? NSArray)!
                    let following:NSArray =  (success.object(forKey: "following") as? NSArray)!
                    
                    if followed.count > 0 {
                        for i in 0..<followed.count {
                            let dic:NSDictionary = followed[i] as! NSDictionary
                            
                            let filter = AppContactFilterModel()
                            filter.address = Global.getStringValue(dic.value(forKey: "address") as AnyObject)
                            filter.age =  Global.getStringValue(dic.value(forKey: "age") as AnyObject)
                            filter.city_id =  Global.getStringValue(dic.value(forKey: "city_id") as AnyObject)
                            filter.city_name =  Global.getStringValue(dic.value(forKey: "city_name") as AnyObject)
                            filter.cityname =  Global.getStringValue(dic.value(forKey: "cityname") as AnyObject)
                            filter.company_name =  Global.getStringValue(dic.value(forKey: "company_name") as AnyObject)
                            filter.country_code =  Global.getStringValue(dic.value(forKey: "country_code") as AnyObject)
                            filter.country_id =  Global.getStringValue(dic.value(forKey: "country_id") as AnyObject)
                            filter.country_name =  Global.getStringValue(dic.value(forKey: "country_name") as AnyObject)
                            filter.countryname =  Global.getStringValue(dic.value(forKey: "countryname") as AnyObject)
                            filter.created_on =  Global.getStringValue(dic.value(forKey: "created_on") as AnyObject)
                            filter.device_id =  Global.getStringValue(dic.value(forKey: "device_id") as AnyObject)
                            filter.device_token =  Global.getStringValue(dic.value(forKey: "device_token") as AnyObject)
                            filter.dob =  Global.getStringValue(dic.value(forKey: "dob") as AnyObject)
                            filter.email =  Global.getStringValue(dic.value(forKey: "email") as AnyObject)
                            filter.followers =  Global.getStringValue(dic.value(forKey: "followers") as AnyObject)
                            filter.following =  Global.getStringValue(dic.value(forKey: "following") as AnyObject)
                            filter.gender =  Global.getStringValue(dic.value(forKey: "gender") as AnyObject)
                            filter.invite_id =  Global.getStringValue(dic.value(forKey: "invite_id") as AnyObject)
                            filter.invited_by =  Global.getStringValue(dic.value(forKey: "invited_by") as AnyObject)
                            filter.is_email_verify = Global.getStringValue(dic.value(forKey: "is_email_verify") as AnyObject)
                            filter.is_phone_verify = Global.getStringValue(dic.value(forKey: "is_phone_verify") as AnyObject)
                            filter.modified_on = Global.getStringValue(dic.value(forKey: "modified_on") as AnyObject)
                            filter.name = Global.getStringValue(dic.value(forKey: "name") as AnyObject)
                            filter.oauth_provider = Global.getStringValue(dic.value(forKey: "oauth_provider") as AnyObject)
                            filter.oauth_uid = Global.getStringValue(dic.value(forKey: "oauth_uid") as AnyObject)
                            filter.phone_no = Global.getStringValue(dic.value(forKey: "phone_no") as AnyObject)
                            filter.posts = Global.getStringValue(dic.value(forKey: "posts") as AnyObject)
                            filter.profile_id = Global.getStringValue(dic.value(forKey: "profile_id") as AnyObject)
                            filter.profile_pic = Global.getStringValue(dic.value(forKey: "profile_pic") as AnyObject)
                            filter.request_status = Global.getStringValue(dic.value(forKey: "request_status") as AnyObject)
                            filter.roleid = Global.getStringValue(dic.value(forKey: "roleid") as AnyObject)
                            filter.rolename = Global.getStringValue(dic.value(forKey: "rolename") as AnyObject)
                            filter.state_id = Global.getStringValue(dic.value(forKey: "state_id") as AnyObject)
                            filter.state_name = Global.getStringValue(dic.value(forKey: "state_name") as AnyObject)
                            filter.statename = Global.getStringValue(dic.value(forKey: "statename") as AnyObject)
                            filter.upload_folder_name = Global.getStringValue(dic.value(forKey: "upload_folder_name") as AnyObject)
                            filter.user_status = Global.getStringValue(dic.value(forKey: "user_status") as AnyObject)
                            filter.userid = Global.getStringValue(dic.value(forKey: "userid") as AnyObject)
                            filter.zipcode = Global.getStringValue(dic.value(forKey: "zipcode") as AnyObject)
                            filter.invited_to = Global.getStringValue(dic.value(forKey: "invited_to") as AnyObject)
                            filter.is_login = Global.getStringValue(dic.value(forKey: "is_login") as AnyObject)
                            filter.status_id = Global.getStringValue(dic.value(forKey: "status_id") as AnyObject)
                            self.arrFollowingsList.append(filter)
                        }
                    }
                    
                    if following.count > 0 {
                        for i in 0..<following.count {
                            let dic:NSDictionary = following[i] as! NSDictionary
                            
                            let filter = AppContactFilterModel()
                            filter.address = Global.getStringValue(dic.value(forKey: "address") as AnyObject)
                            filter.age =  Global.getStringValue(dic.value(forKey: "age") as AnyObject)
                            filter.city_id =  Global.getStringValue(dic.value(forKey: "city_id") as AnyObject)
                            filter.city_name =  Global.getStringValue(dic.value(forKey: "city_name") as AnyObject)
                            filter.cityname =  Global.getStringValue(dic.value(forKey: "cityname") as AnyObject)
                            filter.company_name =  Global.getStringValue(dic.value(forKey: "company_name") as AnyObject)
                            filter.country_code =  Global.getStringValue(dic.value(forKey: "country_code") as AnyObject)
                            filter.country_id =  Global.getStringValue(dic.value(forKey: "country_id") as AnyObject)
                            filter.country_name =  Global.getStringValue(dic.value(forKey: "country_name") as AnyObject)
                            filter.countryname =  Global.getStringValue(dic.value(forKey: "countryname") as AnyObject)
                            filter.created_on =  Global.getStringValue(dic.value(forKey: "created_on") as AnyObject)
                            filter.device_id =  Global.getStringValue(dic.value(forKey: "device_id") as AnyObject)
                            filter.device_token =  Global.getStringValue(dic.value(forKey: "device_token") as AnyObject)
                            filter.dob =  Global.getStringValue(dic.value(forKey: "dob") as AnyObject)
                            filter.email =  Global.getStringValue(dic.value(forKey: "email") as AnyObject)
                            filter.followers =  Global.getStringValue(dic.value(forKey: "followers") as AnyObject)
                            filter.following =  Global.getStringValue(dic.value(forKey: "following") as AnyObject)
                            filter.gender =  Global.getStringValue(dic.value(forKey: "gender") as AnyObject)
                            filter.invite_id =  Global.getStringValue(dic.value(forKey: "invite_id") as AnyObject)
                            filter.invited_by =  Global.getStringValue(dic.value(forKey: "invited_by") as AnyObject)
                            filter.is_email_verify = Global.getStringValue(dic.value(forKey: "is_email_verify") as AnyObject)
                            filter.is_phone_verify = Global.getStringValue(dic.value(forKey: "is_phone_verify") as AnyObject)
                            filter.modified_on = Global.getStringValue(dic.value(forKey: "modified_on") as AnyObject)
                            filter.name = Global.getStringValue(dic.value(forKey: "name") as AnyObject)
                            filter.oauth_provider = Global.getStringValue(dic.value(forKey: "oauth_provider") as AnyObject)
                            filter.oauth_uid = Global.getStringValue(dic.value(forKey: "oauth_uid") as AnyObject)
                            filter.phone_no = Global.getStringValue(dic.value(forKey: "phone_no") as AnyObject)
                            filter.posts = Global.getStringValue(dic.value(forKey: "posts") as AnyObject)
                            filter.profile_id = Global.getStringValue(dic.value(forKey: "profile_id") as AnyObject)
                            filter.profile_pic = Global.getStringValue(dic.value(forKey: "profile_pic") as AnyObject)
                            filter.request_status = Global.getStringValue(dic.value(forKey: "request_status") as AnyObject)
                            filter.roleid = Global.getStringValue(dic.value(forKey: "roleid") as AnyObject)
                            filter.rolename = Global.getStringValue(dic.value(forKey: "rolename") as AnyObject)
                            filter.state_id = Global.getStringValue(dic.value(forKey: "state_id") as AnyObject)
                            filter.state_name = Global.getStringValue(dic.value(forKey: "state_name") as AnyObject)
                            filter.statename = Global.getStringValue(dic.value(forKey: "statename") as AnyObject)
                            filter.upload_folder_name = Global.getStringValue(dic.value(forKey: "upload_folder_name") as AnyObject)
                            filter.user_status = Global.getStringValue(dic.value(forKey: "user_status") as AnyObject)
                            filter.userid = Global.getStringValue(dic.value(forKey: "userid") as AnyObject)
                            filter.zipcode = Global.getStringValue(dic.value(forKey: "zipcode") as AnyObject)
                            filter.invited_to = Global.getStringValue(dic.value(forKey: "invited_to") as AnyObject)
                            filter.is_login = Global.getStringValue(dic.value(forKey: "is_login") as AnyObject)
                            filter.status_id = Global.getStringValue(dic.value(forKey: "status_id") as AnyObject)
                            self.arrFollowersList.append(filter)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.myFriendTableView.reloadData()
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
    
    func setProfileData(resultData: NSDictionary) {
        
        labelPosts.text! = Global.getStringValue(resultData.value(forKey: "posts") as AnyObject)
        labelFollowers.text! = Global.getStringValue(resultData.value(forKey: "followers") as AnyObject)
        labelFollowing.text! = Global.getStringValue(resultData.value(forKey: "following") as AnyObject)
        
        self.profileImage.downloadImage(from: Global.getStringValue(resultData.value(forKey: "profile_pic") as AnyObject))
        
        let name = Global.getStringValue(resultData.value(forKey: "name") as AnyObject)
        
        let user_profile = Global.getStringValue(resultData.value(forKey: "user_profile") as AnyObject)
        if user_profile.isEmpty || user_profile == "public" {
            switchPublic.isOn = true
        } else {
            switchPublic.isOn = false
        }
        
        if name.isEmpty {
            self.labelProfileName.text! = "--"
        } else {
            self.labelProfileName.text! = name
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        if (Global.getStringValue(resultData.value(forKey: "dob") as AnyObject) == "" ) {
            self.labelBirthdate.text! =  ""
        } else {
            let date: Date? = dateFormatter.date(from: Global.getStringValue(resultData.value(forKey: "dob") as AnyObject)) as Date?
            if date != nil {
                self.labelBirthdate.text! =  dateFormatter.string(from: date!)
            }else{
                print("Wrong DOB talk to admin.")
            }
        }
        
        self.labelUserName.text! = Global.getStringValue(resultData.value(forKey: "name") as AnyObject)
        self.labelCity.text! =  Global.getStringValue(resultData.value(forKey: "city_name") as AnyObject)
        self.labelLocation.text! =  Global.getStringValue(resultData.value(forKey: "state_name") as AnyObject)
        self.labelEmailAddress.text! = Global.getStringValue(resultData.value(forKey: "email") as AnyObject)
        self.textMobileNumber.text! = Global.getStringValue(resultData.value(forKey: "phone_no") as AnyObject)
        self.textAddress.text! = Global.getStringValue(resultData.value(forKey: "address") as AnyObject)
    }
    
    // POST tab action method
    
    func didPressedBack() {
        PostDataForGetMyPost()
    }
}

// MARK: Image donwload extension
let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func downloadImage(from imgURL: String!) {
        if imgURL != "" {
            let url = URLRequest(url: URL(string: imgURL)!)
            // set initial image to nil so it doesn't use the image from a reused cell
            image = nil
            // check if the image is already in the cache
            if let imageToCache = imageCache.object(forKey: imgURL! as NSString) {
                self.image = imageToCache
                return
            }
            
            // download the image asynchronously
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                }
                DispatchQueue.main.async {
                    // create UIImage
                    let imageToCache = UIImage(data: data!)
                    // add image to cache
                    imageCache.setObject(imageToCache  ?? UIImage(named: "Camera")!, forKey: imgURL! as NSString)
                    self.image = imageToCache
                }
            }
            task.resume()
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if profileDataType == "post" {
            return arrayFan.count
        } else if profileDataType == "followers" {
            return arrFollowersList.count
        } else {
            return arrFollowingsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if profileDataType == "post" {
            
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
            
            let str = Global.getStringValue(fanPost.value(forKey: "fileurl") as AnyObject)
            
            let filetype = Global.getStringValue(fanPost.value(forKey: "filetype") as AnyObject)
            
            if cell.postImage.image == nil {
                DispatchQueue.main.async {
                    
                    if filetype == "video" {
                        let url: URL = URL(string: str)!
                        let image = self.generateThumbnail(path: url)
                        if image != nil {
                            cell.postImage.image = image!
                        }
                    } else {
                        cell.postImage.sd_setImage(with: URL(string: str), placeholderImage: UIImage(named: "imgpsh_fullsize_anim"))
                    }
                }
            }
            return cell
        } else {
            let cell: AppContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AppContactTableViewCell", for: indexPath) as! AppContactTableViewCell
            let requestData: AppContactFilterModel
            if profileDataType == "followers" {
                requestData = self.arrFollowersList[indexPath.row]
            } else {
                requestData = self.arrFollowingsList[indexPath.row]
            }
            let image = requestData.profile_pic
            cell.contactProfileImg.downloadImage(from: image)
            cell.labelcontactName.text = requestData.name
            cell.labelshortName.text = requestData.rolename
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if profileDataType == "post" {
            let fanPost = arrayFan[indexPath.row] as! NSDictionary
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
            
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            
            let requestData: AppContactFilterModel
            
            if profileDataType == "followers" {
                requestData = self.arrFollowersList[indexPath.row]
            } else {
                requestData = self.arrFollowingsList[indexPath.row]
            }
            
            nextViewController.getUserDetails = requestData
            nextViewController.isFrom = "3"
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if profileDataType == "post" {
                return 120
            }
            return 80
        }
    }
    
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            let thumbnail = UIImage(named: "Video camera")
            return thumbnail
        }
    }
}

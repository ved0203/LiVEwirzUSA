//
//  HomeProfileViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 05/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AVFoundation

class HomeProfileViewController: UIViewController, FanCommentViewControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageViewProperty!
    @IBOutlet weak var labelProfileName: UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelBirthdate: UILabel!
    @IBOutlet weak var labelEmailAddress: UILabel!
    @IBOutlet weak var textMobileNumber: UILabel!
    @IBOutlet weak var textAddress: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    
    @IBOutlet weak var labelPost: UILabel!
    @IBOutlet weak var labelFollowers: UILabel!
    @IBOutlet weak var labelFollowing: UILabel!
    
    
    @IBOutlet weak var viewInvited: UIViewPropertys!
    @IBOutlet weak var viewAcceptDecline: UIViewPropertys!
    @IBOutlet weak var viewAlreadyFriend: UIViewPropertys!
    @IBOutlet weak var btnBlock: UIButton!
    @IBOutlet weak var labelFollowedStatus: UILabel!
    
    var isFromHome: Bool!
    var getDataFromSearch: NSDictionary = NSDictionary()
    
    var getUserDetails: AppContactFilterModel = AppContactFilterModel()
    var isFrom = ""
    var isFromRequest: Bool = false
    var isFromSuggestion: Bool = false
    var block: Bool = false
    
    // My detail view objects
    @IBOutlet weak var myPostTableView: UITableView!
    @IBOutlet weak var myFriendTableView: UITableView!
    @IBOutlet weak var viewPost: UIView!
    
    @IBOutlet weak var viewProfile: UIView!
    
    var tapArtist: Bool = false
    var arrayFan: NSArray = NSArray()
    var arrFollowersList = [AppContactFilterModel]()
    var arrFollowingsList = [AppContactFilterModel]()
    
    var profileDataType = "post"
    
    var userProfile: NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewInvited.isHidden = true
        viewAlreadyFriend.isHidden = true
        viewPost.isHidden = true
        myPostTableView.isHidden = true
        myFriendTableView.isHidden = true
        profileDataType = "post"
        
        profileDataType = "post"
        viewPost.isHidden = false
        viewProfile.isHidden = true
        myPostTableView.isHidden = false
        myFriendTableView.isHidden = true
        self.myPostTableView.reloadData()
        self.myFriendTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global.navigatioinBarClear(vc: self)
        if isFromHome == true {
            postDataForGetConcertUserProfile()
        }else {
            postDataForGetUserProfile()
        }
    }
    
    @IBAction func didTappedBlockButton(_ sender: Any) {
        
        if userProfile.value(forKey: "invite_id")==nil {
            return
        }
        let invite_id = userProfile.value(forKey: "invite_id") as! String
        let invited_by = UserDefaults.standard.value(forKey: "userid") as! String
        let invited_to = userProfile.value(forKey: "userid") as! String
        
        if block == false {
            postDataForInvite(invite_id: "", invited_by: invited_by, invited_to: invited_to, request_status: "4")
        }else {
            postDataForInvite(invite_id: invite_id, invited_by: invited_by, invited_to: invited_to, request_status: "3")
        }
    }
    
    func postDataForInvite(invite: String, status: String) {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            var dictPost:[String: AnyObject]!
            dictPost = ["invited_by": userid as AnyObject, "invited_to": invite as AnyObject, "request_status": status as AnyObject, "invite_id": "" as AnyObject]
            print("Dict of Info HOMEPROFILE=\(dictPost)")

            WebHelper.requestPostUrl(strURL: APIName.kkRequest_for_frnd, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    Global.showAlertView(vc: self, titleString: "", messageString: message)
                } else if resultString == "1" {
                    self.navigationController?.popViewController(animated: true)
                    Global.hideActivityIndicator(self.view)
                } else {
                    Global.hideActivityIndicator(self.view)
                }
            }, Failure: {
                failure in
                Global.hideActivityIndicator(self.view)
            })
        } else {
            self.alert(message: "Internet is not connected!", title: "Internet")
            Global.hideActivityIndicator(self.view)
        }
    }
    
    @IBAction func didTappedOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTappedOnShowProfilePic(_ sender: Any) {
        
        let profileView = ProfileImageView(nibName: "ProfileImageView", bundle: nil)
        profileView.modalPresentationStyle = .overCurrentContext
        profileView.image = Global.getStringValue(userProfile.value(forKey: "profile_pic") as AnyObject)
        self.present(profileView, animated: false, completion: nil)
    }
    
    @IBAction func didTappedReportAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ReportViewController") as! ReportViewController
        let dic = self.getUserDetails
        nextViewController.userIDTo = dic.userid
        nextViewController.isFromProfile = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    func postDataForGetUserProfile() {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            var dictPost:[String: AnyObject]!
            
            if isFromHome == true {
                dictPost = ["userid": getDataFromSearch.object(forKey: "post_by_userid") as AnyObject]
            }else {
                dictPost = ["userid": getDataFromSearch.object(forKey: "userid") as AnyObject]
            }
            
            WebHelper.requestPostUrl(strURL: APIName.kkUser_profile, Dictionary: dictPost, Success:{
                success in
                let resultDict:NSDictionary? = success.object(forKey: "response") as? NSDictionary
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                self.userProfile = resultDict!
                
                if resultString == "1" {
                    print(resultDict!)
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
    
    func postDataForGetConcertUserProfile() {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            
            print("getDataFromSearch=\(getDataFromSearch)")
            let invited_by = UserDefaults.standard.value(forKey: "userid") as! String
            let invited_to = getDataFromSearch.object(forKey: "post_by_userid") as! String
            
            var dictPost:[String: AnyObject]!
            dictPost = ["loggedin_userid": invited_by as AnyObject, "concert_userid": invited_to as AnyObject]

            WebHelper.requestPostUrl(strURL: APIName.kkConcert_User_profile, Dictionary: dictPost, Success:{
                success in
                let resultDict:NSDictionary? = success.object(forKey: "response") as? NSDictionary
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                if resultString == "1" {
                    self.userProfile = resultDict!
                    self.setProfileData(resultData: resultDict!)
                    self.PostDataForGetMyPost()
                }
                else if resultString == "0" {
                    // Create the alert controller
                    let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
                    // Create the actions
                    let okAction = UIAlertAction(title: "Ok", style: .default) {
                        UIAlertAction in
                        self.navigationController?.popViewController(animated: true)
                    }
                    // Add the actions
                    alertController.addAction(okAction)
                    // Present the controller
                    self.present(alertController, animated: true, completion: nil)

                }else{
                    self.PostDataForGetMyPost()
                }
            }, Failure: {
                failure in
                self.PostDataForGetMyPost()
            })
        } else {
            Global.hideActivityIndicator(self.view)
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
    
    func setProfileData(resultData: NSDictionary) {
        print("Set Profile Data=\(resultData)")
        labelPost.text! = Global.getStringValue(resultData.value(forKey: "posts") as AnyObject)
        labelFollowers.text! = Global.getStringValue(resultData.value(forKey: "followers") as AnyObject)
        labelFollowing.text! = Global.getStringValue(resultData.value(forKey: "following") as AnyObject)
        
        let show_unblock_button = Global.getStringValue(resultData.value(forKey: "show_unblock_button") as AnyObject)
        
        if show_unblock_button == "no" {
            block = false
            btnBlock.setTitle("Block", for: .normal)
        }else {
            block = true
            btnBlock.setTitle("Unblock", for: .normal)
        }
        
        if isFromSuggestion {
            viewInvited.isHidden = false
        } else {
            let request_status = Global.getStringValue(resultData.value(forKey: "request_status") as AnyObject)
            
            if request_status == "2" {
                
                viewAlreadyFriend.isHidden = false
                viewInvited.isHidden = true
                
            } else {
                let is_invited = Global.getStringValue(resultData.value(forKey: "is_invited") as AnyObject)
                if is_invited == "no" {
                    
                    viewInvited.isHidden = true
                    viewAlreadyFriend.isHidden = true
                } else {
                    
                    viewAlreadyFriend.isHidden = false
                    viewInvited.isHidden = true
                }
            }
        }
        
        self.profileImage.downloadImage(from: Global.getStringValue(resultData.value(forKey: "profile_pic") as AnyObject))
        self.labelProfileName.text! = Global.getStringValue(resultData.value(forKey: "name") as AnyObject)
        //        self.labelUserName.text! = Global.getStringValue(resultData.value(forKey: "name") as AnyObject)
        //        self.labelBirthdate.text! =  Global.getStringValue(resultData.value(forKey: "dob") as AnyObject)
        //        self.labelLocation.text! =  Global.getStringValue(resultData.value(forKey: "city_name") as AnyObject)
        //        self.labelEmailAddress.text! = Global.getStringValue(resultData.value(forKey: "email") as AnyObject)
        //        self.textMobileNumber.text! = Global.getStringValue(resultData.value(forKey: "phone_no") as AnyObject)
        //        self.textAddress.text! = Global.getStringValue(resultData.value(forKey: "address") as AnyObject)
    }
    
    
    
    // MARK: Button Action
    
    @IBAction func didTappedAcceptButton(_ sender: Any) {
        
        let invite_id = Global.getStringValue(getDataFromSearch.object(forKey: "invite_id") as AnyObject)
        let invited_by = Global.getStringValue(getDataFromSearch.object(forKey: "invited_by") as AnyObject)
        let invited_to = Global.getStringValue(getDataFromSearch.object(forKey: "invited_to") as AnyObject)
        postDataForInvite(invite_id: invite_id, invited_by: invited_by, invited_to: invited_to, request_status: "2")
    }
    
    @IBAction func didTappedDeclineButton(_ sender: Any) {
        let invite_id = Global.getStringValue(getDataFromSearch.object(forKey: "invite_id") as AnyObject)
        let invited_by = Global.getStringValue(getDataFromSearch.object(forKey: "invited_by") as AnyObject)
        let invited_to = Global.getStringValue(getDataFromSearch.object(forKey: "invited_to") as AnyObject)
        postDataForInvite(invite_id: invite_id, invited_by: invited_by, invited_to: invited_to, request_status: "3")
        
    }
    
    @IBAction func didTappedOnInviteButton(_ sender: Any) {
        let invited_to = Global.getStringValue(getDataFromSearch.object(forKey: "userid") as AnyObject)
        postDataForInvite(invite: invited_to)
    }
    
    func postDataForInvite(invite_id: String, invited_by: String, invited_to: String, request_status: String) {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            var dictPost:[String: AnyObject]!
            dictPost = ["invited_by": userid as AnyObject, "invited_to": invited_to as AnyObject, "request_status": request_status as AnyObject, "invite_id": invite_id as AnyObject]
            print("Dict of Info HOMEPROFILE=\(dictPost)")

            WebHelper.requestPostUrl(strURL: APIName.kkRequest_for_frnd, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    Global.showAlertView(vc: self, titleString: "", messageString: message)
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    
                    self.navigationController?.popViewController(animated: true)
                    Global.showAlertView(vc: self, titleString: "", messageString: message)
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
    
    func postDataForInvite(invite: String) {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            var dictPost:[String: AnyObject]!
            dictPost = ["invited_by": userid as AnyObject, "invited_to": invite as AnyObject, "request_status": "1" as AnyObject, "invite_id": "" as AnyObject]

            WebHelper.requestPostUrl(strURL: APIName.kkRequest_for_frnd, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    Global.showAlertView(vc: self, titleString: "", messageString: message)
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    self.viewInvited.isHidden = true
                    self.viewAlreadyFriend.isHidden = false
                    self.labelFollowedStatus.text = "Invited"
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
    
    // POST tab action method
    
    func didPressedBack() {
        PostDataForGetMyPost()
    }
    
    func PostDataForGetMyPost() {
        
        if Global.isInternetAvailable() {
            var dictPost:[String: AnyObject]!
            
            if isFromHome == true {
                dictPost = ["userid": getDataFromSearch.object(forKey: "post_by_userid") as AnyObject]
            }else {
                dictPost = ["userid": UserDefaults.standard.value(forKey: "userid") as AnyObject]
            }
            
            WebHelper.requestPostUrl(strURL: APIName.kkMy_post_list, Dictionary: dictPost, Success:{
                success in
                
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                } else if resultString == "1" {
                    self.arrayFan = success.object(forKey: "response") as! NSArray
                    
                    DispatchQueue.main.async {
                        self.myPostTableView.reloadData()
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
            
            if isFromHome == true {
                dictPost = ["userid": getDataFromSearch.object(forKey: "post_by_userid") as AnyObject]
            }else {
                dictPost = ["userid": UserDefaults.standard.value(forKey: "userid") as AnyObject]
            }
            
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
                        self.myPostTableView.reloadData()
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
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let lable = gesture.view as! UILabel
        
        let array = lable.text?.components(separatedBy: "by")
        let termsRange = (lable.text! as NSString).range(of: (array?.last!)!)
        
        if gesture.didTapAttributedTextInLabel(label: lable, inRange: termsRange) {
            print("Tapped username")
            
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
        nextViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func shareTextButton(_ sender: UIButton) {
        
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
    
    @IBAction func onPressShowProfile(_ sender: Any) {
        viewPost.isHidden = true
        viewProfile.isHidden = false
        myPostTableView.isHidden = true
        myFriendTableView.isHidden = true
    }
    
    @IBAction func onPressShowPost(_ sender: Any) {
        profileDataType = "post"
        viewPost.isHidden = false
        viewProfile.isHidden = true
        myPostTableView.isHidden = false
        myFriendTableView.isHidden = true
        self.myPostTableView.reloadData()
        self.myFriendTableView.reloadData()
    }
    
    @IBAction func onPressShowFollowers(_ sender: Any) {
        profileDataType = "followers"
        viewPost.isHidden = false
        viewProfile.isHidden = true
        myPostTableView.isHidden = true
        myFriendTableView.isHidden = false
        self.myPostTableView.reloadData()
        self.myFriendTableView.reloadData()
    }
    
    @IBAction func onPressShowFollowings(_ sender: Any) {
        profileDataType = "followings"
        viewPost.isHidden = false
        viewProfile.isHidden = true
        myPostTableView.isHidden = true
        myFriendTableView.isHidden = false
        self.myPostTableView.reloadData()
        self.myFriendTableView.reloadData()
    }
}

extension HomeProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return arrayFan.count
        } else {
            if profileDataType == "followers" {
                return arrFollowersList.count
            } else {
                return arrFollowingsList.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 0 {
            
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
        
        if tableView.tag == 0 {
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

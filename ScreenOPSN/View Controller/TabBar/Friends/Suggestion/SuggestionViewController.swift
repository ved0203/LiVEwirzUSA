//
//  SuggestionViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 03/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SuggestionViewController: UIViewController, UISearchDisplayDelegate, UISearchBarDelegate  {
    @IBOutlet weak var tranparentBG: UIView!
    @IBOutlet weak var bunnyView: UIViewPropertys!
    @IBOutlet weak var popUpView: UIViewPropertys!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var suggestionTableView: UITableView!
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearching: Bool = false
    var refreshControl = UIRefreshControl()
    var suggestion_Array = [AppContactFilterModel]()
    var filteredData = [AppContactFilterModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAler(title: "", bool: true)
        
        suggestionTableView.layer.cornerRadius = 10.0
        suggestionTableView.layer.shadowColor = UIColor.gray.cgColor
        suggestionTableView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        suggestionTableView.layer.shadowRadius = 12.0
        suggestionTableView.layer.shadowOpacity = 0.7
        // Do any additional setup after loading the view.
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        suggestionTableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        postDataForGetSuggestionList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SearchBar.setCustomProperty()
    }
    
    @objc func refresh(sender:AnyObject) {
        postDataForGetSuggestionList()
        // Code to refresh table view
    }
    
    func showAler(title: String, bool: Bool) {
        bunnyView.isHidden = bool
        popUpView.isHidden = bool
        tranparentBG.isHidden = bool
        alertLabel.text = title
    }
    
    @IBAction func didTappedOnInviteButton(_ sender: Any) {
        let requestData: AppContactFilterModel
        if isSearching {
            requestData = self.filteredData[(sender as AnyObject).tag]
        } else {
            requestData = self.suggestion_Array[(sender as AnyObject).tag]
        }
        
        if requestData.invite_id == "" {
            postDataForInvite(invite: requestData.userid, status: "2", inviteId: "")
        } else {
            postDataForInvite(invite: requestData.userid, status: "1", inviteId: "\(requestData.invite_id)")
        }
    }
    
    @IBAction func didTappedOkButton(_ sender: Any) {
        self.showAler(title: "", bool: true)
    }
    
    func postDataForInvite(invite: String, status: String, inviteId: String) {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            var dictPost:[String: AnyObject]!
            dictPost = ["invited_by": userid as AnyObject, "invited_to": invite as AnyObject, "request_status": status as AnyObject, "invite_id": inviteId as AnyObject]
            print("postDataForInvite=\(String(describing: dictPost))")
            WebHelper.requestPostUrl(strURL: APIName.kkRequest_for_frnd, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                print("success=\(String(describing: success))")

                let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    self.showAler(title: message, bool: false)
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    self.showAler(title: message, bool: false)
                } else {
                    Global.hideActivityIndicator(self.view)
                    self.showAler(title: message, bool: false)
                }
                self.postDataForGetSuggestionList()
            }, Failure: {
                failure in
                Global.hideActivityIndicator(self.view)
            })
        } else {
            showAler(title: "Please check your internet", bool: false)
            Global.hideActivityIndicator(self.view)
        }
    }
    
    func postDataForGetSuggestionList() {
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            var dictPost:[String: AnyObject]!
            dictPost = ["userid": userid as AnyObject]
            
            WebHelper.requestPostUrl(strURL: APIName.kkSuggestion, Dictionary: dictPost, Success:{
                success in
                
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                self.suggestion_Array = []
                self.filteredData = []
                
                if resultString == "0" {
                    self.refreshControl.endRefreshing()
                    Global.hideActivityIndicator(self.view)
                } else if resultString == "1" {
                    self.refreshControl.endRefreshing()
                    Global.hideActivityIndicator(self.view)
                    
                    let ArrayAdd:NSArray =  (success.object(forKey: "response") as? NSArray)!
                    
                    for i in 0..<ArrayAdd.count{
                        let dic:NSDictionary = ArrayAdd[i] as! NSDictionary
                        print(dic)
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
                        self.suggestion_Array.append(filter)
                    }
                } else {
                    Global.hideActivityIndicator(self.view)
                }
                self.suggestionTableView.reloadData()
            }, Failure: {
                failure in
                Global.hideActivityIndicator(self.view)
            })
        } else {
            Global.hideActivityIndicator(self.view)
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
    
    func postDataForGetSearchList(keyword: String) {
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            var dictPost:[String: AnyObject]!
            dictPost = ["userid": userid as AnyObject, "keyword": keyword as AnyObject]
            
            WebHelper.requestPostUrl(strURL: APIName.kkSearchfrnds, Dictionary: dictPost, Success:{
                success in
                
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                self.suggestion_Array = []
                self.filteredData = []
                
                if resultString == "0" {
                    self.refreshControl.endRefreshing()
                    Global.hideActivityIndicator(self.view)
                } else if resultString == "1" {
                    self.refreshControl.endRefreshing()
                    Global.hideActivityIndicator(self.view)
                    
                    let ArrayAdd:NSArray =  (success.object(forKey: "response") as? NSArray)!
                    
                    for i in 0..<ArrayAdd.count{
                        let dic:NSDictionary = ArrayAdd[i] as! NSDictionary
                        print(dic)
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
                        self.suggestion_Array.append(filter)
                    }
                    
                } else {
                    Global.hideActivityIndicator(self.view)
                }
                
                self.suggestionTableView.reloadData()
            }, Failure: {
                failure in
                
                Global.hideActivityIndicator(self.view)
                
            })
        } else {
            Global.hideActivityIndicator(self.view)
            self.alert(message: "Internet is not connected!", title: "Internet")
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            self.suggestionTableView.reloadData()
            
            self.postDataForGetSuggestionList()
        }else{
            self.postDataForGetSearchList(keyword: searchBar.text!)
        }
    }
}

extension SuggestionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return self.filteredData.count
        } else {
            return self.suggestion_Array.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SuggestionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SuggestionTableViewCell", for: indexPath) as! SuggestionTableViewCell
        let requestData: AppContactFilterModel
        
        if isSearching {
            requestData = self.filteredData[indexPath.row]
        } else {
            requestData = self.suggestion_Array[indexPath.row]
        }
        
        let image = requestData.profile_pic
        cell.contactProfileImg.downloadImage(from: image)
        cell.labelcontactName.text =  requestData.name
        cell.buttonInvite.tag = indexPath.row
        
        print("FollowId=\(requestData.invite_id)")
        if requestData.invite_id == "" {
            cell.labelTitle.text = "Follow"
        }else {
            cell.labelTitle.text = "Unfollow"
        }
        
        cell.imgIcon.image = cell.imgIcon.image?.withRenderingMode(.alwaysTemplate)
        cell.imgIcon.tintColor = Global.hexStringToUIColor("#0166ff")
        
        cell.bgView.layer.cornerRadius = 17.5
        cell.bgView.layer.borderColor = Global.hexStringToUIColor("#0166ff").cgColor
        cell.bgView.layer.borderWidth = 1.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        
        let requestData: AppContactFilterModel
        
        if isSearching {
            requestData = self.filteredData[indexPath.row]
        } else {
            requestData = self.suggestion_Array[indexPath.row]
        }
        
        nextViewController.getUserDetails = requestData
        nextViewController.isFrom = "2"
        nextViewController.isFromSuggestion = true
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        SearchBar.endEditing(true)
    }
}

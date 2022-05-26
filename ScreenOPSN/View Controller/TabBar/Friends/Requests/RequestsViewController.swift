//
//  RequestsViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 05/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class RequestsViewController: UIViewController, UISearchDisplayDelegate, UISearchBarDelegate , RequestTableViewCellDelegate {
    @IBOutlet weak var tranparentBG: UIView!
    @IBOutlet weak var bunnyView: UIViewPropertys!
    @IBOutlet weak var popUpView: UIViewPropertys!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var requestedTableView: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearching: Bool = false
    // var requestArray: NSArray = NSArray()
    var refreshControl = UIRefreshControl()
    var requestArray = [AppContactFilterModel]()
    var filteredData = [AppContactFilterModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAler(title: "", bool: true)
        requestedTableView.layer.cornerRadius = 10.0
        requestedTableView.layer.shadowColor = UIColor.gray.cgColor
        requestedTableView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        requestedTableView.layer.shadowRadius = 12.0
        requestedTableView.layer.shadowOpacity = 0.7
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        requestedTableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        postDataForGetInvitations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SearchBar.setCustomProperty()
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        postDataForGetInvitations()
    }
    
    // MARK: ShowAler
    
    func showAler(title: String, bool: Bool) {
        bunnyView.isHidden = bool
        popUpView.isHidden = bool
        tranparentBG.isHidden = bool
        alertLabel.text = title
    }
    
    // MARK: Button Action
    
    @IBAction func didTappedAcceptButton(_ sender: Any) {
        
        let requestData: AppContactFilterModel
        
        if isSearching {
            requestData = self.filteredData[(sender as AnyObject).tag]
        } else {
            requestData = self.requestArray[(sender as AnyObject).tag]
        }
        
        let invite_id = requestData.invite_id
        let invited_by = requestData.invited_by
        let invited_to = requestData.invited_to
        
        postDataForInvite(invite_id: invite_id, invited_by: invited_by, invited_to: invited_to, request_status: "2")
    }
    
    @IBAction func didTappedDeclineButton(_ sender: Any) {
        
        let requestData: AppContactFilterModel
        
        if isSearching {
            requestData = self.filteredData[(sender as AnyObject).tag]
        } else {
            requestData = self.requestArray[(sender as AnyObject).tag]
        }
        
        let invite_id = requestData.invite_id
        let invited_by = requestData.invited_by
        let invited_to = requestData.invited_to
        
        postDataForInvite(invite_id: invite_id, invited_by: invited_by, invited_to: invited_to, request_status: "3")
    }
    
    @IBAction func didTappedOkButton(_ sender: Any) {
        self.showAler(title: "", bool: true)
    }
    
    func postDataForInvite(invite_id: String, invited_by: String, invited_to: String, request_status: String) {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)

            var dictPost:[String: AnyObject]!
            dictPost = ["invited_by": invited_by as AnyObject, "invited_to": invited_to as AnyObject, "request_status": request_status as AnyObject, "invite_id": invite_id as AnyObject]
            
            WebHelper.requestPostUrl(strURL: APIName.kkRequest_for_frnd, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)

                let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    self.showAler(title: message, bool: false)
                    Global.hideActivityIndicator(self.view)
                } else if resultString == "1" {
                    self.showAler(title: message, bool: false)
                    Global.hideActivityIndicator(self.view)
                    self.postDataForGetInvitations()
                } else {
                    Global.hideActivityIndicator(self.view)
                }
            }, Failure: {
                failure in
                Global.hideActivityIndicator(self.view)
            })
        } else {
            Global.hideActivityIndicator(self.view)
        }
    }
    
    func postDataForGetInvitations() {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            dictPost = ["userid": userid as AnyObject]
            
            print("dictPost=\(String(describing: dictPost))")
       
            WebHelper.requestPostUrl(strURL: APIName.kkFrnd_requests, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                print("resultString=\(resultString)")
            
                self.filteredData = []
                self.requestArray = []
                
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    self.refreshControl.endRefreshing()
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    self.refreshControl.endRefreshing()
                    
                    let ArrayAdd:NSArray =  (success.object(forKey: "response") as? NSArray)!
                    
                    for i in 0..<ArrayAdd.count{
                        let dic:NSDictionary = ArrayAdd[i] as! NSDictionary
                        print(dic)
                        let filter = AppContactFilterModel()
                        filter.address = Global.getStringValue(dic.value(forKey: "address") as AnyObject)
                        filter.is_invited = Global.getStringValue(dic.value(forKey: "is_invited") as AnyObject)
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
                        filter.invited_to =  Global.getStringValue(dic.value(forKey: "invited_to") as AnyObject)
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
                        
                        filter.is_login = Global.getStringValue(dic.value(forKey: "is_login") as AnyObject)
                        filter.status_id = Global.getStringValue(dic.value(forKey: "status_id") as AnyObject)
                        
                        self.requestArray.append(filter)
                    }
                } else {
                    Global.hideActivityIndicator(self.view)
                }
                
                self.requestedTableView.reloadData()
            }, Failure: {
                failure in
                Global.hideActivityIndicator(self.view)
                self.showAler(title: failure.localizedDescription, bool: false)
            })
        } else {
            Global.hideActivityIndicator(self.view)
            self.showAler(title: "Internet is not connected!", bool: false)
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            self.requestedTableView.reloadData()
        }else{
            
            isSearching = true
            filteredData = requestArray.filter({( candy : AppContactFilterModel) -> Bool in
                return candy.toString().lowercased().contains(searchText.lowercased())
            })
            self.requestedTableView.reloadData()
        }
    }
    
}

extension RequestsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return self.filteredData.count
        } else {
            return self.requestArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RequestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RequestTableViewCell", for: indexPath) as! RequestTableViewCell
        cell.idx = indexPath.row
        cell.delegate = self
        
        cell.labelrequestSent.clipsToBounds = true
        cell.labelrequestSent.layer.cornerRadius = 5.0
        
        let requestData: AppContactFilterModel
        
        if isSearching {
            requestData = self.filteredData[indexPath.row]
        } else {
            requestData = self.requestArray[indexPath.row]
        }
        
        let image = requestData.profile_pic
        cell.requestProfileImg.downloadImage(from: image)
        cell.labelcontactName.text = requestData.name
        cell.labelshortName.text = requestData.rolename
        
        let isInvited = requestData.is_invited
        
        if isInvited == "no" {
            cell.viewAcceptDecline.isHidden = false
            cell.viewInvited.isHidden = true
        } else {
            cell.viewAcceptDecline.isHidden = true
            cell.viewInvited.isHidden = false
        }
        cell.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        
        let requestData: AppContactFilterModel
        
        if isSearching {
            requestData = self.filteredData[indexPath.row]
        } else {
            requestData = self.requestArray[indexPath.row]
        }
        
        nextViewController.getUserDetails = requestData
        nextViewController.isFrom = "1"
        nextViewController.isFromRequest = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        /*let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeProfileViewController") as! HomeProfileViewController
        let suggestionData = self.searchFriendArray[indexPath.row] as! NSDictionary
        nextViewController.getDataFromSearch = suggestionData
        nextViewController.isFromHome = false
        self.navigationController?.pushViewController(nextViewController, animated: true)*/
    }
    
    func didCancelSentRequest(index: Int) {
        let requestData: AppContactFilterModel
        
        if isSearching {
            requestData = self.filteredData[index]
        } else {
            requestData = self.requestArray[index]
        }
        
        postDataForInvite(invite_id: requestData.invite_id, invited_by: requestData.invited_by, invited_to: requestData.invited_to, request_status: "3")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        SearchBar.endEditing(true)
    }
    
}

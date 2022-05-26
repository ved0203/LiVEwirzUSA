//
//  AppContactsViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 02/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AppContactsViewController: UIViewController,
        UISearchDisplayDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var appContactTableView: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearching: Bool = false
    var refreshControl = UIRefreshControl()
    var myAppContact = [AppContactFilterModel]()
    var filteredData = [AppContactFilterModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appContactTableView.layer.cornerRadius = 10.0
        appContactTableView.layer.shadowColor = UIColor.gray.cgColor
        appContactTableView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        appContactTableView.layer.shadowRadius = 12.0
        appContactTableView.layer.shadowOpacity = 0.7
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        appContactTableView.addSubview(refreshControl) // not required when using UITableViewController
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        postDataForGetMyFriend()
    }

    override func viewDidAppear(_ animated: Bool) {
        SearchBar.setCustomProperty()
    }

    @objc func refresh(sender:AnyObject) {
        postDataForGetMyFriend()
        // Code to refresh table view
    }
    
    func postDataForGetMyFriend() {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            
            dictPost = ["userid": userid as AnyObject]
            
            WebHelper.requestPostUrl(strURL: APIName.kkMy_frnds, Dictionary: dictPost, Success:{
                success in

                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                self.myAppContact = []
                self.filteredData = []
                
                let filter = AppContactFilterModel()
                filter.name = "The LiVEwirz Team"
                filter.rolename = "Admin"
                self.myAppContact.append(filter)

                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    self.refreshControl.endRefreshing()
                    
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    self.refreshControl.endRefreshing()
                    
                    let response:NSArray =  (success.object(forKey: "response") as? NSArray)!
                    let followed:NSArray =  (success.object(forKey: "followed") as? NSArray)!
                    let following:NSArray =  (success.object(forKey: "following") as? NSArray)!
                    
                    if followed.count > 0 {
                        for i in 0..<followed.count {
                            let dic:NSDictionary = followed[i] as! NSDictionary
                            print(dic)
                            
                            if response.contains(dic) == false {
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
                                
                                self.myAppContact.append(filter)
                            }
                        }
                    }

                    if following.count > 0 {
                        for i in 0..<following.count {
                            let dic:NSDictionary = following[i] as! NSDictionary
                            print(dic)
                            
                            if response.contains(dic) == false {
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
                                
                                self.myAppContact.append(filter)
                            }
                        }
                    }
                    
                    for i in 0..<response.count {
                        let dic:NSDictionary = response[i] as! NSDictionary
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
                        filter.invited_to = Global.getStringValue(dic.value(forKey: "invited_to") as AnyObject)
                        filter.is_login = Global.getStringValue(dic.value(forKey: "is_login") as AnyObject)
                        filter.status_id = Global.getStringValue(dic.value(forKey: "status_id") as AnyObject)
                        
                        self.myAppContact.append(filter)
                    }
                } else {
                    Global.hideActivityIndicator(self.view)
                }
                
                self.appContactTableView.reloadData()
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
        
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            view.endEditing(true)
            self.appContactTableView.reloadData()
        } else {
            isSearching = true
            filteredData = myAppContact.filter({( candy : AppContactFilterModel) -> Bool in
                return candy.toString().lowercased().contains(searchText.lowercased())
            })
            self.appContactTableView.reloadData()
        }
    }
}

extension AppContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return self.filteredData.count
        } else {
            return self.myAppContact.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: AppContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AppContactTableViewCell", for: indexPath) as! AppContactTableViewCell
        let requestData: AppContactFilterModel
        
        if isSearching {
            requestData = self.filteredData[indexPath.row]
        } else {
            requestData = self.myAppContact[indexPath.row]
        }
        let image = requestData.profile_pic
        cell.contactProfileImg.downloadImage(from: image)
        cell.labelcontactName.text = requestData.name
        cell.labelshortName.text = requestData.rolename
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        let requestData: AppContactFilterModel
        
        if isSearching {
            requestData = self.filteredData[indexPath.row]
        } else {
            requestData = self.myAppContact[indexPath.row]
        }
        nextViewController.getUserDetails = requestData
        nextViewController.isFrom = "3"
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        SearchBar.endEditing(true)
    }
}

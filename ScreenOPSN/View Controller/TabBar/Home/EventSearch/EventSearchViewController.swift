//
//  EventSearchViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 06/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class EventSearchViewController: UIViewController {
    
    @IBOutlet weak var searchEventTableView: UITableView!
    @IBOutlet weak var txtKeyword: UITextField!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var alertView: UIViewPropertys!
    @IBOutlet weak var alertView1: UIViewPropertys!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var labelAlertAbout: UILabel!
    
    @IBOutlet weak var mailView: UIViewPropertys!
    @IBOutlet weak var mailView1: UIViewPropertys!
    
    @IBOutlet weak var btnSearch: UIView!
    
    var searchEventArray: NSArray = NSArray()
    
    var storeData: NSDictionary = NSDictionary()
    var statusReuslt: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Global.navigatioinBarClear(vc: self)
        
        searchEventTableView.layer.cornerRadius = 10.0
        searchEventTableView.layer.shadowColor = UIColor.gray.cgColor
        searchEventTableView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        searchEventTableView.layer.shadowRadius = 12.0
        searchEventTableView.layer.shadowOpacity = 0.7
        
        alertshow(title: "", status: "", bool: true)
        postDataForPrePopulateEvent()
        
        txtKeyword.customProperty()
    }
    
    func alertshow(title: String, status: String, bool: Bool) {
        self.statusReuslt = status
        self.labelAlertAbout.text = title
        self.alertView.isHidden = bool
        self.alertView1.isHidden = bool
        self.bgView.isHidden = bool
    }
    
    func mailshow( bool: Bool) {
        self.mailView.isHidden = bool
        self.mailView1.isHidden = bool
        self.bgView.isHidden = bool
    }
    
    @IBAction func didTappedHideAlert(_ sender: Any) {
        alertshow(title: "", status: "", bool: true)
        
        let action = self.storeData.value(forKey: "actions") as! NSDictionary
        let show_mail_popup = Global.getStringValue(action.value(forKey: "show_mail_popup") as AnyObject)
        if show_mail_popup == "yes" {
            self.mailshow(bool: false)
        }else{
            if statusReuslt != "0" {
                let roleid = UserDefaults.standard.value(forKey: "roleid") as! String
                if roleid == "3" {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextVC = storyBoard.instantiateViewController(withIdentifier: "LanyardViewController") as! LanyardViewController
                    nextVC.getData = self.storeData
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
        }
    }
    
    func postDataForPrePopulateEvent() {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            let roleid = UserDefaults.standard.integer(forKey: "roleid")
            
            var dictPost:[String: AnyObject]!
            
            dictPost = ["userid": userid as AnyObject, "roleid": roleid as AnyObject]
            WebHelper.requestPostUrl(strURL: APIName.kkPre_populate_events, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    self.noDataView.isHidden = false
                    self.searchEventTableView.isHidden = true
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    self.searchEventTableView.isHidden = false
                    self.noDataView.isHidden = true
                    self.searchEventArray = success.object(forKey: "events") as! NSArray
                    self.searchEventTableView.reloadData()
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
    
    func postDataForSearchEvent(keyword: String) {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            let roleid = UserDefaults.standard.integer(forKey: "roleid")
            
            var dictPost:[String: AnyObject]!
            
            dictPost = ["userid": userid as AnyObject, "keyword": keyword as AnyObject, "page_number": "0" as AnyObject, "roleid": roleid as AnyObject]
            WebHelper.requestPostUrl(strURL: APIName.kkSearch_events, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    self.noDataView.isHidden = false
                    self.searchEventTableView.isHidden = true
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    self.searchEventTableView.isHidden = false
                    self.noDataView.isHidden = true
                    self.searchEventArray = success.object(forKey: "events") as! NSArray
                    self.searchEventTableView.reloadData()
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
    
    func postDataForArtistToAddEvent(tm_eventid: String, event_name: String) {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            let roleid = UserDefaults.standard.integer(forKey: "roleid")
            
            var apiName = ""
            if roleid == 2 {
                apiName = APIName.kkAdd_event_by_artist
            } else {
                apiName = APIName.kkAdd_event_by_fan
            }
            
            var dictPost:[String: AnyObject]!
            dictPost = ["userid": userid as AnyObject,"roleid": roleid as AnyObject, "tm_eventid": tm_eventid as AnyObject, "event_name": event_name as AnyObject]
            
            WebHelper.requestPostUrl(strURL: apiName, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    self.alertshow(title: message, status: resultString, bool: false)
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    self.alertshow(title: message, status: resultString, bool: false)
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
    
    func postDataForMailArtistToAddEvent(tm_eventid: String, event_name: String) {
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            var dictPost:[String: AnyObject]!
            dictPost = ["userid": userid as AnyObject,"subject": "Request to add artist for event ABC" as AnyObject, "msgbody": "Please add an artist for event ABC" as AnyObject, "tm_eventid": tm_eventid as AnyObject, "event_name": event_name as AnyObject]
            
            WebHelper.requestPostUrl(strURL: APIName.kkSend_mail_for_add_artist, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                var message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    self.alertshow(title: message, status: resultString, bool: false)
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
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
    
    @IBAction func didTappedOnInviteButton(_ sender: Any) {
        self.storeData = (self.searchEventArray[(sender as AnyObject).tag] as? NSDictionary)!
        
        let roleid = UserDefaults.standard.value(forKey: "roleid") as! String
        if roleid == "3" {
            let action = self.storeData.value(forKey: "actions") as! NSDictionary
            let show_mail_popup = Global.getStringValue(action.value(forKey: "show_mail_popup") as AnyObject)
            if show_mail_popup == "yes" {
                self.mailshow(bool: false)
            }else{
                self.postDataForArtistToAddEvent(tm_eventid: Global.getStringValue(self.storeData.value(forKey: "tm_eventid") as AnyObject), event_name: Global.getStringValue(self.storeData.value(forKey: "event_name") as AnyObject))
            }
        }else{
            self.postDataForArtistToAddEvent(tm_eventid: Global.getStringValue(self.storeData.value(forKey: "tm_eventid") as AnyObject), event_name: Global.getStringValue(self.storeData.value(forKey: "event_name") as AnyObject))
        }
    }
    
    @IBAction func didTappedOnSearchButton(_ sender: Any) {
        txtKeyword.resignFirstResponder()
        
        let text: NSString = (txtKeyword.text ?? "") as NSString
        if text != "" {
            self.postDataForSearchEvent(keyword: text as String)
        }else {
            self.postDataForPrePopulateEvent()
        }
    }
    
    @IBAction func didTappedOnSendButton(_ sender: Any) {
        self.mailshow(bool: true)
        self.postDataForMailArtistToAddEvent(tm_eventid: Global.getStringValue(self.storeData.value(forKey: "tm_eventid") as AnyObject), event_name: Global.getStringValue(self.storeData.value(forKey: "event_name") as AnyObject))
    }
    
    @IBAction func didTappedOnCancelButton(_ sender: Any) {
        self.mailshow(bool: true)
    }
    
    @IBAction func didTappedOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension EventSearchViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text: NSString = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        
        if resultString.isEmpty {
            self.noDataView.isHidden = false
            self.searchEventTableView.isHidden = true
        } else {
            self.noDataView.isHidden = true
            self.searchEventTableView.isHidden = false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtKeyword.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text: NSString = (textField.text ?? "") as NSString
        if text != "" {
            self.postDataForSearchEvent(keyword: text as String)
        }else {
            self.postDataForPrePopulateEvent()
        }
    }
}

extension EventSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchEventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: EventSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EventSearchTableViewCell", for: indexPath) as! EventSearchTableViewCell
        let suggestionData = self.searchEventArray[indexPath.row] as! NSDictionary
        
        let image = Global.getStringValue(suggestionData.value(forKey: "image_url") as AnyObject)
        
        cell.eventImage.downloadImage(from: image)
        cell.labelEventTitle.text = Global.getStringValue(suggestionData.value(forKey: "event_name") as AnyObject)
        cell.labelDate.text = "\(Global.getStringValue(suggestionData.value(forKey: "event_date") as AnyObject)) \(Global.getStringValue(suggestionData.value(forKey: "event_time") as AnyObject))"
        cell.labelTime.text = Global.getStringValue(suggestionData.value(forKey: "city_name") as AnyObject)
        
        cell.selectedButton.tag = indexPath.row
        cell.detailsButton.tag = indexPath.row
        
        cell.selectedButton.layer.cornerRadius = 15.0
        cell.selectedButton.layer.borderWidth = 1.0
        cell.selectedButton.layer.borderColor = Global.hexStringToUIColor("#0166ff").cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

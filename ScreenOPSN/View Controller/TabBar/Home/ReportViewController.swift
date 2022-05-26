//
//  ReportViewController.swift
//  ScreenOPSN
//
//  Created by shadab sheikh on 2020-06-26.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ReportViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var tblReport: UITableView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewOne: UIViewPropertys!
    @IBOutlet weak var viewTwo: UIViewPropertys!
    
    var arrayReport:[NSDictionary] = [NSDictionary]()
    var checkedArray: NSMutableArray = NSMutableArray()
    var dataDict: NSDictionary = NSDictionary()
    
    var statusK: String = String()
    var otherThings = ""
    var userIDTo = ""
    
    var isFromProfile: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblReport.delegate = self
        tblReport.dataSource = self
        
        PostDataForGetReportPostReasons()
        
        self.tblReport.tableFooterView = UIView()
        hideView(titless: "", hide: true)
    }
    
    func hideView(titless: String, hide: Bool) {
        bgView.isHidden = hide
        viewOne.isHidden = hide
        viewTwo.isHidden = hide
        labelTitle.text = titless
    }
    
    func PostDataForGetReportPostReasons() {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            
            var dictPost:[String: AnyObject]!
            dictPost = [:]
            WebHelper.requestgetUrl(strURL: APIName.kkReport_post_reasons, Dictionary: dictPost, Controller: self, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    self.arrayReport = success.object(forKey: "reasons") as! [NSDictionary]
                    self.tblReport.reloadData()
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
    
    @IBAction func didTappedOk(_ sender: Any) {
        
        if statusK == "1" {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tab bar")
            self.present(nextViewController, animated: true, completion: nil)
            
        }
        hideView(titless: "", hide: true)
    }
    
    @IBAction func didTappedOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTappedReportNowButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        
        if checkedArray.count > 0 {
            
        } else {
            if otherThings == "" {
                self.hideView(titless: "Please choose an option", hide: false)
                return
            }else {
                let dict = arrayReport[9]
                let id = dict.value(forKey: "reason_id") as! String
                checkedArray.add(id)
            }
        }
        
        var service_types_id: String = ""
        
        for i in 0..<checkedArray.count{
            if i == 0 {
                service_types_id = checkedArray.object(at: i) as! String
            } else {
                service_types_id = service_types_id + ", "
                service_types_id = service_types_id + (checkedArray.object(at: i) as! String)
            }
        }
        
        if isFromProfile {
            PostDataForReportUser()
        } else {
            PostDataForReportNow(commentid: "", postid: dataDict.value(forKey: "postid") as! String, reasonid: service_types_id, other: otherThings)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.otherThings = textView.text
    }
    
    func PostDataForReportNow(commentid: String, postid: String, reasonid: String, other: String) {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            let roleid = UserDefaults.standard.value(forKey: "roleid") as! String
            
            dictPost = ["userid": userid as AnyObject, "roleid": roleid as AnyObject, "postid": postid as AnyObject,"commentid": commentid as AnyObject, "reason_id": reasonid as AnyObject, "other_comment": other as AnyObject]
            WebHelper.requestPostUrl(strURL: APIName.kkAdd_report_post, Dictionary: dictPost, Success:{
                success in
                
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                
                if resultString == "0" {
                    self.statusK = "0"
                    self.hideView(titless: message, hide: false)
                    Global.hideActivityIndicator(self.view)
                } else if resultString == "1" {
                    self.statusK = "1"
                    self.hideView(titless: message, hide: false)
                    Global.hideActivityIndicator(self.view)
                }
            }, Failure: {
                failure in
            })
        } else {
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
    
    func PostDataForReportUser() {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            
            dictPost = ["report_by_userid": userid as AnyObject, "report_to_userid": userIDTo as AnyObject, "other_comment": "" as AnyObject]
            
            WebHelper.requestPostUrl(strURL: APIName.kkAdd_report_user, Dictionary: dictPost, Success:{
                success in
                
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                
                if resultString == "0" {
                    self.statusK = "0"
                    self.hideView(titless: message, hide: false)
                    Global.hideActivityIndicator(self.view)
                } else if resultString == "1" {
                    self.statusK = "1"
                    self.hideView(titless: message, hide: false)
                    Global.hideActivityIndicator(self.view)
                }
            }, Failure: {
                failure in
            })
        } else {
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayReport.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ReportCell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
        
        let dict = arrayReport[indexPath.row]
        
        cell.checkUncheckButton.isUserInteractionEnabled = false

        if indexPath.row == 9 {
            cell.checkUncheckButton.isHidden = true
            cell.reportButton.isHidden = true
            cell.labelTitle.isHidden = true
            cell.txtOtherThings.isHidden = false
            cell.txtOtherThings.placeholder = "Other, please describe"
            cell.txtOtherThings.tintColor = .black;
        } else {
            cell.checkUncheckButton.isHidden = false
            cell.reportButton.isHidden = false
            cell.labelTitle.isHidden = false
            cell.txtOtherThings.isHidden = true
            
            cell.labelTitle.text = (dict.value(forKey: "reason") as! String)
            
            let id = dict.value(forKey: "reason_id") as! String
            
            if checkedArray.contains(id) {
                cell.checkUncheckButton.isSelected = true
            } else {
                cell.checkUncheckButton.isSelected = false
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = arrayReport[indexPath.row]
        let id = dict.value(forKey: "reason_id") as! String
        
        if checkedArray.contains(id) {
            checkedArray.remove(id)
        } else {
            checkedArray.add(id)
        }
        tblReport.reloadData()
    }
}

class ReportCell: UITableViewCell {
    @IBOutlet weak var checkUncheckButton: UIButtonProperts!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var reportButton: UIButtonProperts!
    @IBOutlet weak var txtOtherThings: IQTextView!
}

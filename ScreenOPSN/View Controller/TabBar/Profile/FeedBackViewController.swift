//
//  FeedBackViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 03/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class FeedBackViewController: UIViewController {

    @IBOutlet weak var textViewFeedBack: IQTextView!
    @IBOutlet weak var userProfile: UIImageViewProperty!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var viewTwo: UIViewPropertys!
    @IBOutlet weak var viewOne: UIViewPropertys!
    @IBOutlet weak var labelStatus: UILabel!

    @IBOutlet weak var btnSend: UIButton!

    var profile: UIImage = UIImage()
    var profilename: String = String()
    
    override func viewDidLoad() {
       
        super.viewDidLoad()

        textViewFeedBack.layer.borderColor = (UIColor.white).cgColor
        textViewFeedBack.layer.borderWidth = 1
        self.viewAlert(statusHide: true, txtStatus: "")

        btnSend.backgroundColor = UIColor.clear
        btnSend.layer.borderWidth = 1.0
        btnSend.layer.borderColor = UIColor.white.cgColor
        btnSend.layer.cornerRadius = 10.0
        
        textViewFeedBack.layer.cornerRadius = 5.0
        textViewFeedBack.layer.masksToBounds = true
     }
    
    override func viewWillAppear(_ animated: Bool) {
        Global.navigatioinBarClear(vc: self)
        
        userProfile.image = profile
        labelName.text = profilename
    }
    
    func viewAlert(statusHide: Bool, txtStatus: String) {
        self.bgView.isHidden = statusHide
        self.viewTwo.isHidden = statusHide
        self.viewOne.isHidden = statusHide
        self.labelStatus.text = txtStatus
    }
    
    @IBAction func okTapped(_ sender: Any) {
        self.viewAlert(statusHide: true, txtStatus: "")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didTappedFeedBackButton(_ sender: Any) {
        if textViewFeedBack.text.isEmpty {
            self.alert(message: "Please enter your feedback!.", title: "Feedback")
        } else {
            postDataForFeedback()
        }
    }
    
    @IBAction func didTappedOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func postDataForFeedback() {
        
        if Global.isInternetAvailable() {

            Global.showActivityIndicator(self.view)
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            
            dictPost = ["comments":textViewFeedBack.text! as AnyObject,"userid": userid as AnyObject]
            
            WebHelper.requestPostUrl(strURL: APIName.kkSend_feedback, Dictionary: dictPost, Success:{
                success in
                let resultDict:NSDictionary? = success.object(forKey: "response") as? NSDictionary
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                var resultMessage = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    self.viewAlert(statusHide: false, txtStatus: resultMessage)
                } else if resultString == "1" {
                    self.textViewFeedBack.placeholder = "Enter Comments"
                    Global.hideActivityIndicator(self.view)
                    resultMessage = "Thanks for the feedback. You rock! …but you know this already!"
                    self.viewAlert(statusHide: false, txtStatus: resultMessage)
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
}

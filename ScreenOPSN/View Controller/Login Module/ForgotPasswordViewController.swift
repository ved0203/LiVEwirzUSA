//
//  ForgotPasswordViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 23/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    var roleid: Int = 0
    
    @IBOutlet weak var textEmailAddress: UITextFeildPropertys!
    @IBOutlet weak var viewSep: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textEmailAddress.customProperty()
        viewSep.frame = CGRect(x: textEmailAddress.frame.origin.x, y: textEmailAddress.frame.origin.y + textEmailAddress.frame.size.height, width: textEmailAddress.frame.size.width, height: 1.0)
    }
    
    @IBAction func dismissView(_ sender: Any) {
           self.dismiss(animated: true, completion: nil)
       }
    
    @IBAction func goToSecond(_ sender: Any) {
        if textEmailAddress.text!.isEmpty {
            self.alert(message: "Please enter the registered email.", title: "Error")
        } else if !Global.validateEmail(textEmailAddress.text!) {
            self.alert(message: "Please enter valid email.", title: "Error")
        } else {
            postDataForUserLogin()
        }
    }
       
    func postDataForUserLogin() {
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)

            var dictPost:[String: AnyObject]!
            dictPost = ["email": textEmailAddress.text as AnyObject, "roleid": roleid as AnyObject]
            
            WebHelper.requestPostUrl(strURL: APIName.kkForgot_password, Dictionary: dictPost, Success:{
                success in

                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    self.alert(message: message, title: "Invalid Email")
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    GlobalConstant.isSuccessF = true
                    
                    // Create the alert controller
                    let alertController = UIAlertController(title: "Message", message: "We’ve sent you an email with password details.", preferredStyle: .alert)
                    // Create the actions
                    let okAction = UIAlertAction(title: "Ok", style: .default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                        self.dismiss(animated: true, completion: nil)
                    }
                    // Add the actions
                    alertController.addAction(okAction)
                    // Present the controller
                    self.present(alertController, animated: true, completion: nil)
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
}

//
//  ChangePassword.swift
//  ScreenOPSN
//
//  Created by Ravi Goradiya on 30/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var textPassword: UITextFeildPropertys!
    @IBOutlet weak var textNewPassword: UITextFeildPropertys!
    @IBOutlet weak var textConfPassword: UITextFeildPropertys!
    
    @IBOutlet weak var btnSubmit: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textPassword.customProperty()
        textNewPassword.customProperty()
        textConfPassword.customProperty()
        
        textPassword.isSecureTextEntry = true
        textNewPassword.isSecureTextEntry = true
        textConfPassword.isSecureTextEntry = true
        
        textPassword.autocorrectionType = .no
        textNewPassword.autocorrectionType = .no
        textConfPassword.autocorrectionType = .no
        
        btnSubmit.layer.borderWidth = 1.0
        btnSubmit.layer.borderColor = UIColor.white.cgColor
        btnSubmit.layer.cornerRadius = 10.0
    }
    
    @IBAction func didTappedOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToSecond(_ sender: Any) {
        if textNewPassword.text!.isEmpty {
            self.alert(message: "Please enter new password.", title: "Error")
        } else if textConfPassword.text!.isEmpty {
            self.alert(message: "Please enter confirm password.", title: "Error")
        } else if textNewPassword.text != textConfPassword.text {
            self.alert(message: "New password and confirm password does not match.", title: "Error")
        } else {
            postDataForChangePassword()
        }
    }
    
    func postDataForChangePassword() {
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            
            var dictPost:[String: AnyObject]!
            dictPost = [
                "userid": userid as AnyObject,
                "password": textNewPassword.text as AnyObject,
                "confirm_password": textConfPassword.text as AnyObject
            ]
            
            WebHelper.requestPostUrl(strURL: APIName.kkChange_password, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    self.alert(message: "Old password does not match.", title: "Invalid Password")
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    
                    self.navigationController?.popViewController(animated: true)
                    self.alert(message: "Success! Your password has been changed.", title: "Success")
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

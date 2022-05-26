//
//  SponsorTwoViewController.swift
//  ScreenOPS
//
//  Created by Apple on 27/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class FanRegisterStepOneViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var textName: UITextFeildPropertys!
    @IBOutlet weak var textEmailAddress: UITextFeildPropertys!
    @IBOutlet weak var textPassword: UITextFeildPropertys!
    
    @IBOutlet weak var alertView: UIViewPropertys!
    @IBOutlet weak var labelThankyou: UILabel!
    @IBOutlet weak var labelAlertName: UILabel!

    func alertshow(title: String, bool: Bool) {
        self.labelThankyou.text = title
        self.alertView.isHidden = bool
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        textPassword.isSecureTextEntry = true
        textPassword.autocorrectionType = .no
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.textPassword.tintColor = .black;
        self.textName.tintColor = .black;
        self.textEmailAddress.tintColor = .black;
    }

    @IBAction func didTappedNextStepAction(_ sender: Any) {
        self.labelAlertName.text = "Whoops!"
        if textName.text!.isEmpty {
            Global.showAlertView(vc: self, titleString: GlobalConstant.APP_NAME, messageString: "Please enter name")
        } else if textEmailAddress.text!.isEmpty {
            Global.showAlertView(vc: self, titleString: GlobalConstant.APP_NAME, messageString: "Please enter email address")
        } else if !Global.validateEmail(textEmailAddress.text!) {
            Global.showAlertView(vc: self, titleString: GlobalConstant.APP_NAME, messageString: "Please enter valid email address")
        } else if self.textPassword.text!.isEmpty  {
            Global.showAlertView(vc: self, titleString: GlobalConstant.APP_NAME, messageString: "Please enter password.")
        } else {
            postDataForVerifyEmail()
        }
    }
    
    @IBAction func didTapGoBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func dismissView(_ sender: Any) {
        alertshow(title: "", bool: true)
    }

    @IBAction func didTappedOnTermsAndCondition(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    func postDataForVerifyEmail() {
        Global.showActivityIndicator(self.view)
        
        var dictPost:[String: AnyObject]!
        dictPost = ["email": textEmailAddress.text as AnyObject]
        
        WebHelper.requestPostUrl(strURL: APIName.kkVerifyUserEmail, Dictionary: dictPost, Success:{
            success in
            let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
            let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
            Global.hideActivityIndicator(self.view)

            if resultString == "0" {
                self.labelAlertName.textColor = Global.hexStringToUIColor("#0166ff")
                self.alertshow(title: message, bool: false)
            } else if resultString == "1" {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FanRegisterStepTwoViewController") as! FanRegisterStepTwoViewController
                nextViewController.name = self.textName.text!
                nextViewController.email = self.textEmailAddress.text!
                nextViewController.password = self.textPassword.text!
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }, Failure: {
            failure in
            Global.hideActivityIndicator(self.view)
        })
    }
}

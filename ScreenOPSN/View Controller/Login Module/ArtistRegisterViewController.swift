//
//  SponsorTwoViewController.swift
//  ScreenOPS
//
//  Created by Apple on 27/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ArtistRegisterViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var textUserName: UITextFeildPropertys!
    @IBOutlet weak var textEmailAddress: UITextFeildPropertys!
    @IBOutlet weak var textPassword: UITextFeildPropertys!
    @IBOutlet weak var lblGenre:  UILabel!
    @IBOutlet weak var pickerGenre:  UIPickerView!
    @IBOutlet weak var viewGenreSelect:  UIView!
    @IBOutlet weak var alertView: UIViewPropertys!
    @IBOutlet weak var labelThankyou: UILabel!
    @IBOutlet weak var labelAlertName: UILabel!
    
    var arrGenre: NSArray = ["Please choose option below","ROCK","ALT","POP","EDM","METAL","PUNK", "COUNTRY","RAP","R&B","FUNK","LATIN","KPOP"];
    
    var strSelectedGenre = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        textPassword.isSecureTextEntry = true
        textPassword.autocorrectionType = .no

        textUserName.delegate = self
        textEmailAddress.delegate = self
        textPassword.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        self.textPassword.tintColor = .black;
        self.textUserName.tintColor = .black;
        self.textEmailAddress.tintColor = .black;
    }
    
    func alertshow(title: String, bool: Bool) {
        self.labelThankyou.text = title
        
        self.labelAlertName.textColor = Global.hexStringToUIColor("#0166ff")
        self.alertView.isHidden = bool
    }

    func postDataForUserSignUp() {
        Global.showActivityIndicator(self.view)
        var dictPost:[String: AnyObject]!
        dictPost = ["email": textEmailAddress.text as AnyObject, "password": textPassword.text as AnyObject, "name": textUserName.text as AnyObject, "dob": "" as AnyObject, "gender": "" as AnyObject, "roleid": "2" as AnyObject, "genre": lblGenre.text as AnyObject]
        WebHelper.requestPostUrl(strURL: APIName.kkUserSignUp, Dictionary: dictPost, Success:{
            success in
            let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
            let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)

            if resultString == "0" {
                self.labelAlertName.text = "Whoops!"
                self.alertshow(title: message, bool: false)
                Global.hideActivityIndicator(self.view)
            } else if resultString == "1" {
                
                Global.hideActivityIndicator(self.view)
                GlobalConstant.isSuccess = true
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ArtistRegisterSuccessViewController") as! ArtistRegisterSuccessViewController
                nextViewController.email = self.textEmailAddress.text!
                nextViewController.password = self.textPassword.text!
                self.navigationController?.pushViewController(nextViewController, animated: true)
            } else {
                Global.hideActivityIndicator(self.view)
            }
        }, Failure: {
            failure in
            Global.hideActivityIndicator(self.view)
        })
    }
    
    @IBAction func dismissView(_ sender: Any) {
        alertshow(title: "", bool: true)
    }
    
    @IBAction func btnDoneAction(_ sender: Any) {
        self.viewGenreSelect.isHidden = true
        if pickerGenre.selectedRow(inComponent: 0) != 0 {
            self.lblGenre.text = strSelectedGenre
        }
    }

    @IBAction func btnCancelAction(_ sender: Any) {
        self.viewGenreSelect.isHidden = true
    }

    @IBAction func didTappedRockOnAction(_ sender: Any) {
        self.labelAlertName.text = "Whoops!"
        if textUserName.text!.isEmpty {
            Global.showAlertView(vc: self, titleString: GlobalConstant.APP_NAME, messageString: "Please enter name")
        } else if textEmailAddress.text!.isEmpty {
            Global.showAlertView(vc: self, titleString: GlobalConstant.APP_NAME, messageString: "Please enter email address")
        } else if !Global.validateEmail(textEmailAddress.text!) {
            Global.showAlertView(vc: self, titleString: GlobalConstant.APP_NAME, messageString: "Please enter valid email address")
        } else if self.textPassword.text!.isEmpty  {
            Global.showAlertView(vc: self, titleString: GlobalConstant.APP_NAME, messageString: "Please enter password.")
        } else if lblGenre.text!.isEmpty || lblGenre.text == "Genre" {
            Global.showAlertView(vc: self, titleString: GlobalConstant.APP_NAME, messageString: "Please select genre")
        } else {
            postDataForUserSignUp()
        }
    }
    
    @IBAction func didTapSelectGenre(_ sender: Any) {
        self.view.endEditing(true)
        self.viewGenreSelect.isHidden = false
    }
    
    @IBAction func didTapGoBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true);
    }

    @IBAction func didTappedOnTermsAndCondition(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
        self.present(nextViewController, animated: true, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrGenre.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrGenre[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row > 0 {
            strSelectedGenre = (arrGenre[row] as? String)!
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //delegate method
        self.viewGenreSelect.isHidden = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //delegate method
        textField.resignFirstResponder()
        return true
    }
}

//
//  SponsorTwoViewController.swift
//  ScreenOPS
//
//  Created by Apple on 27/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class FanRegisterStepTwoViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    // MARK: IBOutlet
    @IBOutlet weak var textUserName: UITextFeildPropertys!
    @IBOutlet weak var lblGender:  UILabel!
    @IBOutlet weak var lblGenre:  UILabel!
    @IBOutlet weak var lblAge:  UILabel!
    @IBOutlet weak var pickerGenre:  UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var viewGenreSelect:  UIView!
    @IBOutlet weak var viewDateSelect:  UIView!
    @IBOutlet weak var alertView: UIViewPropertys!
    @IBOutlet weak var labelThankyou: UILabel!
    @IBOutlet weak var labelAlertName: UILabel!
    
    var email: String = ""
    var password: String = ""
    var name: String = ""
    var arrGender: NSArray = ["Please choose option below","Male","Female","Non-Binary","Prefer not to say"]
    var arrGenre: NSArray = ["Please choose option below","ROCK","ALT","POP","EDM","METAL","PUNK", "COUNTRY","RAP","R&B","FUNK","LATIN","KPOP"];
    
    var strSelectedGenre = "Genre"
    var strSelectedGender = "Gender"
    var strSelectedDate = "Birthday"

    var strError: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.maximumDate = Date()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.textUserName.tintColor = .black;
    }

    func alertshow(title: String, bool: Bool) {
        self.labelThankyou.text = title
        self.alertView.isHidden = bool
    }
    
    func postDataForUserSignUp() {
        Global.showActivityIndicator(self.view)
        
        var dictPost:[String: AnyObject]!
        dictPost = ["email": email as AnyObject, "password": password as AnyObject, "name": textUserName.text as AnyObject, "dob": lblAge.text as AnyObject, "gender": lblGender.text as AnyObject, "roleid": "3" as AnyObject, "genre": lblGenre.text as AnyObject]
        
        WebHelper.requestPostUrl(strURL: APIName.kkUserSignUp, Dictionary: dictPost, Success:{ [self]
            success in
            let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
            let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)

            if resultString == "0" {
                self.strError = message
                self.alertshow(title: message, bool: false)
                Global.hideActivityIndicator(self.view)
            } else if resultString == "1" {
                
                Global.hideActivityIndicator(self.view)
                GlobalConstant.isSuccess = true
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FanRegisterSuccessViewController") as! FanRegisterSuccessViewController
                nextViewController.email = self.email
                nextViewController.password = self.password

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
        if strError == "Email address already exist!" {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTappedRockOnAction(_ sender: Any) {
        self.labelAlertName.text = "Whoops!"
        if textUserName.text!.isEmpty {
            Global.showAlertView(vc: self, titleString: GlobalConstant.APP_NAME, messageString: "Please enter name")
        } else if lblGender.text!.isEmpty || lblGender.text == "Gender" {
            Global.showAlertView(vc: self, titleString: GlobalConstant.APP_NAME, messageString: "Please select gender")
        } else if lblAge.text!.isEmpty || lblAge.text == "Age" {
            Global.showAlertView(vc: self, titleString: GlobalConstant.APP_NAME, messageString: "Please enter age")
        } else if lblGenre.text!.isEmpty || lblGenre.text == "Genre" {
            Global.showAlertView(vc: self, titleString: GlobalConstant.APP_NAME, messageString: "Please select genre")
        } else {
            postDataForUserSignUp()
        }
    }
    
    @IBAction func didTapSelectGender(_ sender: Any) {
        self.view.endEditing(true)
        self.pickerGenre.tag = 0
        self.pickerGenre.reloadAllComponents()
        self.viewDateSelect.isHidden = true
        self.viewGenreSelect.isHidden = false
        pickerGenre.selectRow(0, inComponent: 0, animated: true)
    }
    
    @IBAction func didTapSelectGenre(_ sender: Any) {
        self.view.endEditing(true)
        self.pickerGenre.tag = 1
        self.pickerGenre.reloadAllComponents()
        self.viewDateSelect.isHidden = true
        self.viewGenreSelect.isHidden = false
        pickerGenre.selectRow(0, inComponent: 0, animated: true)
    }
    
    @IBAction func btnDoneAction(_ sender: UIButton) {
        if sender.tag == 1 {
            self.viewDateSelect.isHidden = true
            self.lblAge.text = strSelectedDate
        } else {
            self.viewGenreSelect.isHidden = true
            if((pickerGenre.selectedRow(inComponent: 0)) != 0)
            {
                self.lblGenre.text = strSelectedGenre
                self.lblGender.text = strSelectedGender
            }
        }
    }

    @IBAction func btnCancelAction(_ sender: UIButton) {
        if sender.tag == 1 {
            self.viewDateSelect.isHidden = true
        }else{
            self.viewGenreSelect.isHidden = true
        }
    }

    @IBAction func didTapSelectDate(_ sender: Any) {
        self.view.endEditing(true)
        self.viewGenreSelect.isHidden = true
        self.viewDateSelect.isHidden = false
    }
    
    @IBAction func didTapGoBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func onChangeDate(_ sender: Any) {
        print(datePicker.date);
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        strSelectedDate = formatter.string(from: datePicker.date)
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
        if pickerView.tag == 0 {
            return arrGender.count
        } else {
            return arrGenre.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return arrGender[row] as? String
        } else {
            return arrGenre[row] as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 && row > 0{
            strSelectedGender = (arrGender[row] as? String)!
        } else if (row > 0) {
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

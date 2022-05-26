//
//  EditProfileViewController.swift
//  LiVEwirz
//
//  Created by Apple on 28/02/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var profileImageView: UIImageViewProperty!
    @IBOutlet weak var textName: UITextFeildPropertys!
    @IBOutlet weak var textBirthdate: UITextFeildPropertys!
    @IBOutlet weak var textAddress: UITextFeildPropertys!
    @IBOutlet weak var textCity: UITextFeildPropertys!
    @IBOutlet weak var textLocation: UITextFeildPropertys!
    @IBOutlet weak var textEmailAddress: UITextFeildPropertys!
    @IBOutlet weak var textMobileNumber: UITextFeildPropertys!
    
    @IBOutlet weak var alertView: UIViewPropertys!
    @IBOutlet weak var alertView1: UIViewPropertys!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var labelThankyou: UILabel!
    
    @IBOutlet weak var viewForDatePicker: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var customAlertView: UIView!
    @IBOutlet weak var btnSave: UIButton!

    var arrayStates: NSArray = NSArray()
    var dictSelState: NSDictionary = NSDictionary()

    let thePicker = UIPickerView()
    var mobileNumber: String = ""
    var email: String = ""
    var strSelectedDate = ""

    var resultData: NSDictionary = NSDictionary()
    var profileimageEdit: UIImage = UIImage()
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        customAlertView.isHidden = true
        thePicker.delegate = self
        textLocation.inputView = thePicker
        
        viewForDatePicker.isHidden = true
        PostDataForGetStatesOfUs()
        postDataForGetUserProfile()
        
        updateUi()
    }
    
    func updateUi() {
        btnSave.layer.borderWidth = 1.0
        btnSave.layer.borderColor = UIColor.white.cgColor
        btnSave.layer.cornerRadius = 10.0

        textName.customProperty()
        textBirthdate.customProperty()
        textAddress.customProperty()
        textCity.customProperty()
        textLocation.customProperty()
        textEmailAddress.customProperty()
        textMobileNumber.customProperty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global.setNavBarColor_isTranslucentTruef(vc: self)
        self.alertshow( title: "", bool: true)
    }
    
    @objc func logoutUser() {
        self.PostDataForAddsUpload()
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.viewForDatePicker.isHidden = true
    }

    @IBAction func onChangeDate(_ sender: Any) {
        print(datePicker.date);
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        strSelectedDate = formatter.string(from: datePicker.date)
    }

    @IBAction func btnDoneAction(_ sender: UIButton) {
        self.viewForDatePicker.isHidden = true
        self.textBirthdate.text = strSelectedDate
    }
    
    func alertshow(title: String, bool: Bool) {
        self.labelThankyou.text = title
        self.alertView.isHidden = bool
        self.alertView1.isHidden = bool
        self.backgroundView.isHidden = bool
    }
    
    @IBAction func didTappedOnImage(_ sender: Any) {
        handleTap()
    }
    
    @IBAction func didTappedOnBirthDay(_ sender: Any) {
        self.view.endEditing(true)
        self.viewForDatePicker.isHidden = false
    }

    @IBAction func didTappedEditProfile(_ sender: Any) {
        PostDataForAddsUpload()
    }
    
    @IBAction func alertDismiss(_ sender: Any) {
        self.alertshow(title: "", bool: true)
    }
    
    @IBAction func didTappedOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTappedOk(_ sender: Any) {
        customAlertView.isHidden = true;
    }
    
    // MARK: - UIImagePicker Action Methods
    let imagePicker = UIImagePickerController()
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.alert)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        
        // Add the actions
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK : - CAMERA
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            customAlertView.isHidden = false
        }
    }
    
    // MARK : - GALLARY
    
    func openGallary () {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.profileImageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func PostDataForGetStatesOfUs() {
        
        if Global.isInternetAvailable() {
            
            var dictPost:[String: AnyObject]!
            dictPost = [:]
            WebHelper.requestgetUrl(strURL: APIName.kkStates_of_us, Dictionary: dictPost, Controller: self, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                if resultString == "1" {
                    
                    self.arrayStates = success.object(forKey: "response") as! NSArray
                    self.thePicker.reloadAllComponents()
                    self.thePicker.selectRow(0, inComponent: 0, animated: true)
                    if self.textLocation.text == "" {
                        
                    } else {
                        for dic in (self.arrayStates as NSArray as! [NSDictionary]) {
                            let name = Global.getStringValue((dic as AnyObject).object(forKey: "name") as AnyObject)
                            if self.textLocation.text == name {
                                self.dictSelState = dic
                                break
                            }
                        }
                    }
                }
            }, Failure: {
                failure in
            })
        }
    }
    
    func postDataForGetUserProfile() {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            
            dictPost = ["userid": userid as AnyObject]
            
            WebHelper.requestPostUrl(strURL: APIName.kkUser_profile, Dictionary: dictPost, Success:{
                success in
                let resultDict:NSDictionary? = success.object(forKey: "response") as? NSDictionary
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    self.alertshow( title: message, bool: false)
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    self.resultData = resultDict!
                    self.setProfileData(resultData: resultDict!)
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
    
    func setProfileData(resultData: NSDictionary) {
     
        self.profileImageView.downloadImage(from: Global.getStringValue(resultData.value(forKey: "profile_pic") as AnyObject))

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        if (Global.getStringValue(resultData.value(forKey: "dob") as AnyObject) == "" ) {
            self.textBirthdate.text! =  ""
        } else {
            let date: Date? = dateFormatter.date(from: Global.getStringValue(resultData.value(forKey: "dob") as AnyObject)) as Date?
            if date != nil {
                self.textBirthdate.text! =  dateFormatter.string(from: date!)
            }else{
                print("Wrong DOB talk to admin.")
            }
        }
        
        self.textName.text! = Global.getStringValue(resultData.value(forKey: "name") as AnyObject)

        self.textAddress.text! = Global.getStringValue(resultData.value(forKey: "address") as AnyObject)
        self.textCity.text! = Global.getStringValue(resultData.value(forKey: "city_name") as AnyObject)
        self.textLocation.text! = Global.getStringValue(resultData.value(forKey: "state_name") as AnyObject)
        self.mobileNumber = Global.getStringValue(resultData.value(forKey: "phone_no") as AnyObject)
        
        let mobile =  Global.getStringValue(resultData.value(forKey: "phone_no") as AnyObject)
        
        if !mobile.isEmpty {
            self.textMobileNumber.text = mobile
            self.textMobileNumber.isEnabled = false
        } else {
            self.textMobileNumber.text = mobile
            self.textMobileNumber.isEnabled = true
        }
        
        let email =  Global.getStringValue(resultData.value(forKey: "email") as AnyObject)
        
        if !email.isEmpty {
            self.textEmailAddress.text = email
            self.textEmailAddress.isEnabled = false
        } else {
            self.textEmailAddress.text = email
            self.textEmailAddress.isEnabled = true
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayStates.count + 1
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Please choose option below"
        }
        let dic = arrayStates[row+1]
        let name = Global.getStringValue((dic as AnyObject).object(forKey: "name") as AnyObject)
        return name
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row > 0 {
            let dic = arrayStates[row+1]
            let name = Global.getStringValue((dic as AnyObject).object(forKey: "name") as AnyObject)
            dictSelState = arrayStates[row+1] as! NSDictionary
            textLocation.text = name
        }else{
            textLocation.text = ""
            dictSelState = NSDictionary()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textLocation {
            if textLocation.text == "" {
                
            } else {
                for dic in (arrayStates as NSArray as! [NSDictionary]) {
                    let name = Global.getStringValue((dic as AnyObject).object(forKey: "name") as AnyObject)
                    if textLocation.text == name {
                        dictSelState = dic
                        break
                    }
                }
            }
            
            if dictSelState.allKeys.count > 0 {
                thePicker.selectRow(arrayStates.index(of: dictSelState), inComponent: 0, animated: false)
            } else {
                thePicker.selectRow(0, inComponent: 0, animated: false)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK :- Adds Upload
    
    func PostDataForAddsUpload() {
        
        if Global.isInternetAvailable() {
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            Global.showActivityIndicator(self.view)
            let username = UserDefaults.standard.value(forKey: "username") as! String

            let state_id = Global.getStringValue((dictSelState as AnyObject).object(forKey: "state_id") as AnyObject)
            let user_profile =  Global.getStringValue(resultData.value(forKey: "user_profile") as AnyObject)
            
            dictPost = ["username":username as AnyObject as AnyObject, "user_profile": user_profile  as AnyObject, "userid": userid  as AnyObject, "name": textName.text as AnyObject, "address": textAddress.text as AnyObject, "dob": textBirthdate.text  as AnyObject, "cityname": textCity.text  as AnyObject, "phone_no": textMobileNumber.text as AnyObject, "email": textEmailAddress.text as AnyObject, "state_id": (dictSelState.allKeys.count > 0) ? state_id as AnyObject : "" as AnyObject]

            WebHelper.requestPostUrlWithImage(strURL: APIName.kkUpdate_profile, Dictionary: dictPost, AndImage: self.profileImageView.image!, forImageParameterName: "profile_pic", Success: {
                success in

                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                let message: String? = success.object(forKey: "message") as? String
                
                /// Result fail
                if resultString == "0" {
                    self.alertshow( title: message!, bool: false)
                }
                else if resultString == "1" {
                    NotificationCenter.default.post(name: Notification.Name("profile"), object: nil)
                    Global.hideActivityIndicator(self.view)
                    self.alertshow( title: message!, bool: false)
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    Global.hideActivityIndicator(self.view)
                }
            }, Failure: {
                failure in
                Global.hideActivityIndicator(self.view)
            })
        } else {
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
}

// MARK: Set image Quality
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

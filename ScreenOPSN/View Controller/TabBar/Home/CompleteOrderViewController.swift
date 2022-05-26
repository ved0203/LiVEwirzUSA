//
//  CompleteOrderViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 03/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class CompleteOrderViewController: UIViewController, PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func userDidCancel(_ profileSharingViewController: PayPalProfileSharingViewController) {
        
    }
    
    func payPalProfileSharingViewController(_ profileSharingViewController: PayPalProfileSharingViewController, userDidLogInWithAuthorization profileSharingAuthorization: [AnyHashable : Any]) {
    }
    
    var environment:String = PayPalEnvironmentSandbox {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var resultText = "" // empty
    var payPalConfig = PayPalConfiguration() // default
    
    @IBOutlet weak var txtName: UITextFeildPropertys!
    @IBOutlet weak var txtStreet: UITextFeildPropertys!
    @IBOutlet weak var txtCity: UITextFeildPropertys!
    @IBOutlet weak var txtState: UITextFeildPropertys!
    @IBOutlet weak var txtZip: UITextFeildPropertys!
    @IBOutlet weak var transparentBackground: UIView!
    @IBOutlet weak var popView: UIViewPropertys!
    @IBOutlet weak var profileView: UIViewPropertys!
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    var getData: NSDictionary = NSDictionary()
    
    var isStatus: String = ""
    
    var arrayStates: NSArray = NSArray()
    var dictSelState: NSDictionary = NSDictionary()
    let thePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = true
        payPalConfig.merchantName = "LiveWirz"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
        // Setting the languageOrLocale property is optional.
        //
        // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
        // its user interface according to the device's current language setting.
        //
        // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
        // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
        // to use that language/locale.
        //
        // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
        
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        
        // Setting the payPalShippingAddressOption property is optional.
        //
        // See PayPalConfiguration.h for details.
        
        payPalConfig.payPalShippingAddressOption = .payPal;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.transparentBackground.isHidden = true
        self.popView.isHidden = true
        self.profileView.isHidden = true
        Global.navigatioinBarClear(vc: self)
        
        thePicker.delegate = self
        txtState.inputView = thePicker
        PostDataForGetStatesOfUs()
        
        updateUI()
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    func updateUI()  {
        txtZip.customProperty()
        txtName.customProperty()
        txtCity.customProperty()
        txtState.customProperty()
        txtStreet.customProperty()
        
        btnSubmit.layer.cornerRadius = 10.0
        btnSubmit.layer.borderWidth = 1.0
        btnSubmit.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func didTappedForCompleteOrder(_ sender: Any) {
        if txtName.text!.isEmpty {
            self.alertShow(alert: "Please enter name", bool: false)
        } else if txtStreet.text!.isEmpty {
            self.alertShow(alert: "Please enter Street", bool: false)
        } else if txtCity.text!.isEmpty {
            self.alertShow(alert: "Please enter City", bool: false)
        } else if txtState.text!.isEmpty {
            self.alertShow(alert: "Please enter State", bool: false)
        } else if txtZip.text!.isEmpty {
            self.alertShow(alert: "Please enter Zip", bool: false)
        } else {
            self.postDataForAddAddress(name: txtName.text ?? "", street: txtStreet.text ?? "", city: txtCity.text ?? "", state: txtState.text ?? "", zipcode: txtZip.text ?? "")
        }
    }
    
    //    @IBAction func didTappedForCompleteOrder(_ sender: Any)   {
    //        // Remove our last completed payment, just for demo purposes.
    //        resultText = ""
    //
    //        // Note: For purposes of illustration, this example shows a payment that includes
    //        //       both payment details (subtotal, shipping, tax) and multiple items.
    //        //       You would only specify these if appropriate to your situation.
    //        //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //        //       and simply set payment.amount to your total charge.
    //
    //        // Optional: include multiple items
    //        let item1 = PayPalItem(name: "Old jeans with holes", withQuantity: 2, withPrice: NSDecimalNumber(string: "84.99"), withCurrency: "USD", withSku: "Hip-0037")
    //
    //        let items = [item1]
    //        let subtotal = PayPalItem.totalPrice(forItems: items)
    //
    //        // Optional: include payment details
    //        let shipping = NSDecimalNumber(string: "5.99")
    //        let tax = NSDecimalNumber(string: "2.50")
    //        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
    //
    //        let total = subtotal.adding(shipping).adding(tax)
    //
    //        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Hipster Clothing", intent: .sale)
    //
    //        payment.items = items
    //        payment.paymentDetails = paymentDetails
    //
    //        if (payment.processable) {
    //            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
    //            paymentViewController?.modalPresentationStyle = .fullScreen
    //            present(paymentViewController!, animated: true, completion: nil)
    //        }
    //        else {
    //            // This particular payment will always be processable. If, for
    //            // example, the amount was negative or the shortDescription was
    //            // empty, this payment wouldn't be processable, and you'd want
    //            // to handle that here.
    //            print("Payment not processalbe: \(payment)")
    //        }
    //    }
    
    @IBAction func didTappedOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTappedOffButton(_ sender: Any) {
        self.alertShow(alert: "", bool: true)
        
        if isStatus == "1" {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tab bar")
            self.present(nextViewController, animated: true, completion: nil)
        }
    }
    
    func alertShow(alert: String, bool: Bool) {
        self.popView.isHidden = bool
        self.profileView.isHidden = bool
        self.labelTitle.text = alert
        self.transparentBackground.isHidden = bool
    }
    
    func postDataForAddAddress(name: String, street: String, city: String, state: String, zipcode: String) {
        
        if Global.isInternetAvailable() {
            
            Global.showActivityIndicator(self.view)
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            var dictPost:[String: AnyObject]!
            
            dictPost = ["userid": userid as AnyObject,"name": name as AnyObject, "street": street as AnyObject, "city": city as AnyObject, "state": state as AnyObject,  "zipcode": zipcode as AnyObject]
            
            WebHelper.requestPostUrl(strURL: APIName.kkSave_address, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    self.alertShow(alert: message, bool: false)
                } else if resultString == "1" {
                    self.isStatus = "1"
                    self.txtName.text = ""
                    self.txtStreet.text = ""
                    self.txtCity.text = ""
                    self.txtState.text = ""
                    self.txtZip.text = ""
                    
                    //self.postDataForAddtoCart()
                    Global.hideActivityIndicator(self.view)
                    self.alertShow(alert: "You should receive your package within 3-5 days.", bool: false)
                } else {
                    Global.hideActivityIndicator(self.view)
                }
            }, Failure: {
                failure in
                Global.hideActivityIndicator(self.view)
                self.alertShow(alert: failure.localizedDescription, bool: false)
            })
        } else {
            Global.hideActivityIndicator(self.view)
            self.alertShow(alert: "Internet is not connected!", bool: false)
        }
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

                    if self.txtState.text == "" {
                        
                    } else {
                        for dic in (self.arrayStates as NSArray as! [NSDictionary]) {
                            let name = Global.getStringValue((dic as AnyObject).object(forKey: "name") as AnyObject)
                            if self.txtState.text == name {
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
    
    func postDataForAddtoCart() {
        
        let userid = UserDefaults.standard.value(forKey: "userid") as! String
        let product_id = getData.value(forKey: "product_id") as! String
        
        var dictPost:[String: AnyObject]!
        
        dictPost = ["userid": userid as AnyObject,"product_id": product_id as AnyObject]
        
        WebHelper.requestPostUrl(strURL: APIName.kkAdd_to_cart, Dictionary: dictPost, Success:{
            success in
            let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
            let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
            
            if resultString == "0" {
                self.alertShow(alert: message, bool: false)
            }
        }, Failure: {
            failure in
            self.alertShow(alert: failure.localizedDescription, bool: false)
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int)
    -> Int {
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
            txtState.text = name
        }else{
            txtState.text = ""
            dictSelState = NSDictionary()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtState {
            if txtState.text == "" {
            } else {
                for dic in (arrayStates as NSArray as! [NSDictionary]) {
                    let name = Global.getStringValue((dic as AnyObject).object(forKey: "name") as AnyObject)
                    if txtState.text == name {
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
    
    // PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        resultText = ""
        //successView.isHidden = true
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            self.resultText = completedPayment.description
            self.showSuccess()
        })
    }
    
    // MARK: Future Payments
    
    @IBAction func authorizeFuturePaymentsAction(_ sender: AnyObject) {
        let futurePaymentViewController = PayPalFuturePaymentViewController(configuration: payPalConfig, delegate: self)
        present(futurePaymentViewController!, animated: true, completion: nil)
    }
    
    func payPalFuturePaymentDidCancel(_ futurePaymentViewController: PayPalFuturePaymentViewController) {
        futurePaymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalFuturePaymentViewController(_ futurePaymentViewController: PayPalFuturePaymentViewController, didAuthorizeFuturePayment futurePaymentAuthorization: [AnyHashable: Any]) {
        // send authorization to your server to get refresh token.
        futurePaymentViewController.dismiss(animated: true, completion: { () -> Void in
            self.resultText = futurePaymentAuthorization.description
            self.showSuccess()
        })
    }
    
    // MARK: Helpers
    
    func showSuccess() {
        self.alertShow(alert: "Success method called", bool: false)
        //      successView.isHidden = false
        //      successView.alpha = 1.0
        //      UIView.beginAnimations(nil, context: nil)
        //      UIView.setAnimationDuration(0.5)
        //      UIView.setAnimationDelay(2.0)
        //      successView.alpha = 0.0
        //      UIView.commitAnimations()
    }
}

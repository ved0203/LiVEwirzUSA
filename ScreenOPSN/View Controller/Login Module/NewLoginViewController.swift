
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import SafariServices
import Swifter

class NewLoginViewController: UIViewController {
    
    var isFanLogin : Bool = true
    var email: String = ""
    var password: String = ""

    @IBOutlet weak var textEmailAddress: UITextFeildPropertys!
    @IBOutlet weak var textPassword: UITextFeildPropertys!
    
    @IBOutlet weak var alertView: UIViewPropertys!
    @IBOutlet weak var labelThankyou: UILabel!
    @IBOutlet weak var labelAlertName: UILabel!
    
    var swifter: Swifter!
    var accToken: Credential.OAuthAccessToken?
    
    var twitterId = ""
    var twitterHandle = ""
    var twitterName = ""
    var twitterEmail = ""
    var twitterAccessToken = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textPassword.isSecureTextEntry = true
        textPassword.autocorrectionType = .no
        
        UITextField.appearance().tintColor = .white
        UITextView.appearance().tintColor = .white
    }
    
    // MARK @IBAction Methods
    @IBAction func didTappedOnFrogot(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        nextViewController.roleid = isFanLogin ? 3 : 2
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTappedOnTermsAndCondition(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapTwitterButton(_ sender: Any) {
        self.swifter = Swifter(consumerKey: TwitterConstants.CONSUMER_KEY, consumerSecret: TwitterConstants.CONSUMER_SECRET_KEY)
        self.swifter.authorize(withCallback: URL(string: TwitterConstants.CALLBACK_URL)!, presentingFrom: self, success: { accessToken, _ in
            self.accToken = accessToken
            self.getUserProfile()
        }, failure: { _ in
        })
    }
    
    func getUserProfile() {
        self.swifter.verifyAccountCredentials(includeEntities: false, skipStatus: false, includeEmail: true, success: { json in
            // Twitter Id
            if let twitterId = json["id_str"].string {
                self.twitterId = twitterId
            }
            // Twitter Handle
            if let twitterHandle = json["screen_name"].string {
                self.twitterHandle = twitterHandle
            }
            // Twitter Name
            if let twitterName = json["name"].string {
                self.twitterName = twitterName
            }
            // Twitter Email
            if let twitterEmail = json["email"].string {
                self.twitterEmail = twitterEmail
            }
            self.twitterAccessToken = self.accToken?.key ?? "Not exists"

            // Save the Access Token (accToken.key) and Access Token Secret (accToken.secret) using UserDefaults
            // This will allow us to check user's logging state every time they open the app after cold start.
            let userDefaults = UserDefaults.standard
            userDefaults.set(self.accToken?.key, forKey: "oauth_token")
            userDefaults.set(self.accToken?.secret, forKey: "oauth_token_secret")

            self.postDataForUserSocialLogin(oauth_provider: "twitter" , oauth_uid: self.twitterId as? String ?? "", name: self.twitterName as? String ?? "", email: self.twitterEmail as? String ?? "")
        }) { error in}
    }

    @IBAction func didTapFacebookButton(_ sender: Any) {
        handleFacebookAuthentication()
    }
    
    @IBAction func didTapGoogleButton(_ sender: Any) {
        handleGoogleAuthentication()
    }
    
    @IBAction func didTappedSignIn(_ sender: Any) {
        if textEmailAddress.text!.isEmpty {
            Global.showAlertView(vc: self, titleString: GlobalConstant.APP_NAME, messageString: "Please enter email address")
        } else if !Global.validateEmail(textEmailAddress.text!) {
            Global.showAlertView(vc: self, titleString: GlobalConstant.APP_NAME, messageString: "Please enter valid email address")
        } else if self.textPassword.text!.isEmpty  {
            Global.showAlertView(vc: self, titleString: GlobalConstant.APP_NAME, messageString: "Please enter password.")
        } else {
            postDataForUserLogin()
        }
    }
    
    @IBAction func didTapGoBack(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginActionViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @IBAction func alertDismiss(_ sender: Any) {
        self.alertshow(alert: "", title: "", bool: true)
    }
    
    //MARK
    
    func alertshow(alert: String, title: String, bool: Bool) {
        self.labelThankyou.text = title
        self.labelAlertName.text = alert
        self.alertView.isHidden = bool
    }
    
    func postDataForUserLogin() {
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            
            var dictPost:[String: AnyObject]!
            
            var fcmToken : String  = UserDefaults.standard.value(forKey: "fcmToken") as! String
            if fcmToken == "" {
                fcmToken = "0"
            }
            let device_id = UIDevice.current.identifierForVendor!.uuidString

            var roleId = "0";
            if isFanLogin {
                roleId = "3"
            } else {
                roleId = "2"
            }
            dictPost = ["email": textEmailAddress.text as AnyObject, "password": textPassword.text as AnyObject, "device_token": fcmToken as AnyObject, "device_id": device_id as AnyObject, "roleid": roleId as AnyObject]
            
            WebHelper.requestPostUrl(strURL: APIName.kkUserLogin, Dictionary: dictPost, Success:{
                success in
                let resultDict:NSDictionary? = success.object(forKey: "response") as? NSDictionary
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                if resultString == "0" {
                    let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                    self.alertshow(alert: "", title: message, bool: false)
                    
                    Global.hideActivityIndicator(self.view)
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    self.saveData(resultDict: resultDict!)
                } else {
                    Global.hideActivityIndicator(self.view)
                }
            }, Failure: {
                failure in
                Global.hideActivityIndicator(self.view)
            })
        } else {
            Global.hideActivityIndicator(self.view)
            Global.showAlertView(vc: self, titleString: "Internet", messageString: "Internet is not connected!")
        }
    }
    
    func postDataForUserSocialLogin(oauth_provider: String, oauth_uid: String, name: String, email: String) {
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            
            var dictPost:[String: AnyObject]!
            
            var fcmToken : String  = UserDefaults.standard.value(forKey: "fcmToken") as! String
            if fcmToken == "" {
                fcmToken = "0"
            }
            let device_id = UIDevice.current.identifierForVendor!.uuidString
            
            var roleId = "0";
            if isFanLogin {
                roleId = "3"
            } else {
                roleId = "2"
            }
            //
            dictPost = ["email": email as AnyObject, "name": name as AnyObject, "device_token": fcmToken as AnyObject, "device_id": device_id as AnyObject, "roleid": roleId as AnyObject, "oauth_uid":oauth_uid as AnyObject, "oauth_provider":oauth_provider as AnyObject,]
            
            WebHelper.requestPostUrl(strURL: APIName.kkSocial_login, Dictionary: dictPost, Success:{
                success in
                let resultDict:NSDictionary? = success.object(forKey: "response") as? NSDictionary
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                if resultString == "0" {
                    let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                    self.alertshow(alert: "", title: message, bool: false)
                    Global.hideActivityIndicator(self.view)
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    self.saveData(resultDict: resultDict!)
                } else {
                    Global.hideActivityIndicator(self.view)
                }
            }, Failure: {
                failure in
                
                Global.hideActivityIndicator(self.view)
                
            })
        } else {
            Global.hideActivityIndicator(self.view)
            Global.showAlertView(vc: self, titleString: "Internet", messageString: "Internet is not connected!")
        }
    }
    
    func saveData(resultDict: NSDictionary) {
        
        UserDefaults.standard.setValue("1", forKey: "isLogin")
        UserDefaults.standard.setValue(Global.getStringValue(resultDict.value(forKey: "userid") as AnyObject), forKey: "userid")
        UserDefaults.standard.setValue(Global.getStringValue(resultDict.value(forKey: "name") as AnyObject), forKey: "name")
        UserDefaults.standard.setValue(Global.getStringValue(resultDict.value(forKey: "email") as AnyObject), forKey: "email")
        UserDefaults.standard.setValue(Global.getStringValue(resultDict.value(forKey: "roleid") as AnyObject), forKey: "roleid")
        UserDefaults.standard.setValue(Global.getStringValue(resultDict.value(forKey: "rolename") as AnyObject), forKey: "rolename")
        UserDefaults.standard.setValue(Global.getStringValue(resultDict.value(forKey: "dob") as AnyObject), forKey: "dob")
        UserDefaults.standard.setValue(Global.getStringValue(resultDict.value(forKey: "gender") as AnyObject), forKey: "gender")
        UserDefaults.standard.setValue( Global.getStringValue(resultDict.value(forKey: "profile_pic") as AnyObject), forKey: "profile_pic")
        UserDefaults.standard.setValue(Global.getStringValue(resultDict.value(forKey: "phone_no") as AnyObject), forKey: "phone_no")
        
        UserDefaults.standard.setValue(Global.getStringValue(resultDict.value(forKey: "username") as AnyObject), forKey: "username")

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tab bar")
        self.present(nextViewController, animated: true, completion: nil)    
    }
}

// MARK: - Login with google
extension NewLoginViewController: GIDSignInDelegate {
    
    // Our custom functions
    private func handleGoogleAuthentication() {
        GIDSignIn.sharedInstance()?.clientID = "1025698973847-tmdkfim4gfoh2s2phbtc8ka0bkf4rseg.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    /// Required functions from protocols
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            //showPopup(isSuccess: false, type: .google)
        } else {
            self.postDataForUserSocialLogin(oauth_provider: "google" , oauth_uid: user.userID ?? "", name: user.profile.name ?? "", email: user.profile.email ?? "")
        }
    }
}

// Show the Authorization screen inside the app instead of opening Safari
extension NewLoginViewController: SFSafariViewControllerDelegate {}

extension NewLoginViewController {
    
    /// Our custom functions
    private func handleFacebookAuthentication() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if error != nil {
                // self.showPopup(isSuccess: false, type: .facebook)
                return
            }
            guard let token = AccessToken.current else {
                // self.showPopup(isSuccess: false, type: .facebook)
                return
            }
            
            GraphRequest(graphPath: "me", parameters: ["fields":"id,name , first_name, last_name , email,picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                guard let Info = result as? [String: Any] else { return }
                self.postDataForUserSocialLogin(oauth_provider: "facebook" , oauth_uid: Info["id"] as? String ?? "", name: Info["name"] as? String ?? "", email: Info["email"] as? String ?? "")
            })
        }
    }
}

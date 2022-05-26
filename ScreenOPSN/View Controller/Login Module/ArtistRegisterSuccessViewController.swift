
import UIKit

class ArtistRegisterSuccessViewController: UIViewController {
    
    var isFanLogin : Bool = false
    var email: String = ""
    var password: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTappedLetsGO(_ sender: Any) {
        self.postDataForUserLogin()
        /*let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewLoginViewController") as! NewLoginViewController
        nextViewController.isFanLogin = true
        self.navigationController?.pushViewController(nextViewController, animated: true)*/
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
            dictPost = ["email": email as AnyObject, "password": password as AnyObject, "device_token": fcmToken as AnyObject, "device_id": device_id as AnyObject, "roleid": roleId as AnyObject]
            
            WebHelper.requestPostUrl(strURL: APIName.kkUserLogin, Dictionary: dictPost, Success:{
                success in
                let resultDict:NSDictionary? = success.object(forKey: "response") as? NSDictionary
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                if resultString == "0" {
                    let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                    
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

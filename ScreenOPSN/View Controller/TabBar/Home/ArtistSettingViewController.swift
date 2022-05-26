//
//  ArtistSettingViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ArtistSettingViewController: UIViewController {

    // MARK: IBOutlet
    @IBOutlet weak var switchShareAll: UISwitch!
    @IBOutlet weak var switchShareConsert: UISwitch!
    @IBOutlet weak var switchDeleteAll: UISwitch!
    @IBOutlet weak var switchNotDelete: UISwitch!
    
    var isShareAll = true
    var isDelAll = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        postDataForGetArtistSetting()

    }
     
    override func viewWillAppear(_ animated: Bool) {
               Global.navigatioinBarClear(vc: self)
    }
    
    func postDataForGetArtistSetting() {
       if Global.isInternetAvailable() {
        Global.showActivityIndicator(self.view)
          var dictPost:[String: AnyObject]!
          let userid = UserDefaults.standard.value(forKey: "userid") as! String
          dictPost = ["userid": userid as AnyObject]
                    
          WebHelper.requestPostUrl(strURL: APIName.kkPosted_artist_setting, Dictionary: dictPost, Success:{
                   success in
            let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)

            if resultString == "0" {
                Global.hideActivityIndicator(self.view)
            } else if resultString == "1" {
                Global.hideActivityIndicator(self.view)
                
                let resultDict:NSDictionary? = (success.object(forKey: "response") as! NSArray)[0] as? NSDictionary
                self.setArtistData(resultData: resultDict!)
                
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
    
    func postDataForSaveArtistSetting() {
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            dictPost = [
                "userid": userid as AnyObject,
                "share_with_everyone": isShareAll as AnyObject,
                "share_with_concert_attendees": !isShareAll as AnyObject,
                "delete_after_broadcast": isDelAll as AnyObject,
                "never_delete" :  !isDelAll as AnyObject,
            ]
        
                    
          WebHelper.requestPostUrl(strURL: APIName.kkPosted_save_artist_setting, Dictionary: dictPost, Success:{
                   success in
            let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                        
            if resultString == "0" {
                Global.hideActivityIndicator(self.view)
            } else if resultString == "1" {
                Global.hideActivityIndicator(self.view)
                self.navigationController?.popViewController(animated: true)
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
    
    
    func setArtistData(resultData: NSDictionary) {
                
        switchShareAll.isOn = (resultData.value(forKey: "share_with_everyone") as! NSString).boolValue
        switchShareConsert.isOn = (resultData.value(forKey: "share_with_concert_attendees") as! NSString).boolValue
        switchDeleteAll.isOn = (resultData.value(forKey: "delete_after_broadcast") as! NSString).boolValue
        switchNotDelete.isOn = (resultData.value(forKey: "never_delete") as! NSString).boolValue
        
        isShareAll = (resultData.value(forKey: "share_with_everyone") as! NSString).boolValue
        isDelAll = (resultData.value(forKey: "delete_after_broadcast") as! NSString).boolValue
    }
    
    
    @IBAction func toggleShareAll(_ sender: Any){
        if (sender as AnyObject).tag == 1 {
            isShareAll = switchShareAll.isOn
            switchShareConsert.isOn = !switchShareAll.isOn
        } else {
            isShareAll = !switchShareConsert.isOn
            switchShareAll.isOn = !switchShareConsert.isOn
        }
    }
    
    
    @IBAction func toggleDelete(_ sender: Any){
        if (sender as AnyObject).tag == 3 {
           isDelAll = switchDeleteAll.isOn
           switchNotDelete.isOn = !switchDeleteAll.isOn
       } else {
           isDelAll = !switchNotDelete.isOn
           switchDeleteAll.isOn = !switchNotDelete.isOn
       }
    }
    
    
    @IBAction func saveArtistSetting(_ sender: Any){
        self.postDataForSaveArtistSetting()
    }
    
    
    
    @IBAction func didTappedOnBackButton(_ sender: Any) {
                 self.navigationController?.popViewController(animated: true)
              }
}

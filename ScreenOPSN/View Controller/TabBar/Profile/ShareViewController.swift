//
//  ShareViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 03/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Social

class ShareViewController: UIViewController {

    @IBOutlet weak var userProfile: UIImageViewProperty!

    var resultData: NSDictionary = NSDictionary()
    
    var profile: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     }
    
    override func viewWillAppear(_ animated: Bool) {
           Global.navigatioinBarClear(vc: self)
        userProfile.image = profile
        userProfile.downloadImage(from: Global.getStringValue(resultData.value(forKey: "profile_pic") as AnyObject))
    }
 
    @IBAction func facebookShare(_ sender: Any) {
       //Alert
        let webURL: NSURL = NSURL(string: "https://www.facebook.com/official_livewirz-100711601412315/")!
 
        if(UIApplication.shared.canOpenURL(webURL as URL)){
            // FB installed
            UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
        } else {
            // FB is not installed, open in safari
            UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func didTappedOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonInstagram(_ sender: Any) {
          //Alert
           let webURL: NSURL = NSURL(string: "https://www.instagram.com/official_livewirz/")!
    
           if(UIApplication.shared.canOpenURL(webURL as URL)){
               // FB installed
               UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
           } else {
               // FB is not installed, open in safari
               UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
           }
       }
    
    @IBAction func buttonTwitter(_ sender: Any) {
          //Alert
           let webURL: NSURL = NSURL(string: "https://twitter.com/LiVEwirz_USA")!
    
           if(UIApplication.shared.canOpenURL(webURL as URL)){
               // FB installed
               UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
           } else {
               // FB is not installed, open in safari
               UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
           }
       }
    
     
}

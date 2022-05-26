//
//  SplashVC.swift
//  ScreenOPSN
//
//  Created by Ved on 03/08/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let registration_id  = Global.getStringValue(UserDefaults.standard.value(forKey: "isLogin") as AnyObject)
         
         if registration_id == "1" {
             /// Introduction Navigation Controller
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tab bar")
                self.navigationController?.pushViewController(nextViewController, animated: true)
            })
         } else {
            Global.setNavBarColor_isTranslucentTruef(vc: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                      let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                      let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SponsorOneViewController") as! SponsorOneViewController
                self.navigationController?.pushViewController(nextViewController, animated: true)
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

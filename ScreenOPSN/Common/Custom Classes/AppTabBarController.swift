//
//  AppTabBarController.swift
//  ScreenOPSN
//
//  Created by Ved on 30/07/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class AppTabBarController: UITabBarController {

    @IBOutlet weak var mTabBar: UITabBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mTabBar.backgroundColor = UIColor.clear
        mTabBar.backgroundImage = UIImage()
        mTabBar.shadowImage = UIImage()  // removes the border
    }
    
    /*// MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }*/
}

//
//  ShopViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 28/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.selectedIndex = 2 
     }
    override func viewWillAppear(_ animated: Bool) {
       self.navigationItem.hidesBackButton = true
       Global.setNavBarColor_isTranslucentTruef(vc: self)
    }
}

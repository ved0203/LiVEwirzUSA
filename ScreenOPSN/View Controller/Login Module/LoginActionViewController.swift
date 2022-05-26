//
//  SponsorTwoViewController.swift
//  ScreenOPS
//
//  Created by Apple on 27/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class LoginActionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTappedLoginAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TypeSelectViewController") as! TypeSelectViewController
        nextViewController.isRegister = false
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func didTappedCreateAccountAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TypeSelectViewController") as! TypeSelectViewController
        nextViewController.isRegister = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}

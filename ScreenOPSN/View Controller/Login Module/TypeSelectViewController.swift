//
//  SponsorTwoViewController.swift
//  ScreenOPS
//
//  Created by Apple on 27/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class TypeSelectViewController: UIViewController {
    
    var isRegister : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func didTappedFanAccountCreateAction(_ sender: Any) {
        
        if isRegister {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FanRegisterStepOneViewController") as! FanRegisterStepOneViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewLoginViewController") as! NewLoginViewController
            nextViewController.isFanLogin = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    @IBAction func didTappedArtistAccountCreateAction(_ sender: Any) {
        if isRegister {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ArtistRegisterViewController") as! ArtistRegisterViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewLoginViewController") as! NewLoginViewController
            nextViewController.isFanLogin = false
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    @IBAction func didTapGoBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true);
    }
}

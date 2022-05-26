//
//  MyContactsViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 02/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MyContactsViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var buttonPhoneContact: UIButton!
    @IBOutlet weak var buttonAppContact: UIButton!
    
    // MARK: PROPERTIES
    var container: ContainerViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        GlobalConstant.isController2 = "1"
        buttonPhoneContact.setTitleColor(Global.hexStringToUIColor("#0166ff"), for: .normal)
        buttonAppContact.setTitleColor(.lightGray, for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.hidesBackButton = true
        Global.setNavBarColor_isTranslucentTruef(vc: self)
        
        if GlobalConstant.isController2 == "1" {
            buttonPhoneContact.setTitleColor(Global.hexStringToUIColor("#0166ff"), for: .normal)
            buttonAppContact.setTitleColor(.lightGray, for: .normal)
            container.firstLinkedSubView = "phoneContact"
            
        } else if GlobalConstant.isController2 == "2" {
            buttonAppContact.setTitleColor(Global.hexStringToUIColor("#0166ff"), for: .normal)
            buttonPhoneContact.setTitleColor(.lightGray, for: .normal)
            container.firstLinkedSubView = "appContact"
        }
    }
    
    // MARK: Button Action
    @IBAction func didTappedPhoneContactAction(_ sender: Any) {
        GlobalConstant.isController2 = "1"
        
        buttonPhoneContact.setTitleColor(Global.hexStringToUIColor("#0166ff"), for: .normal)
        buttonAppContact.setTitleColor(.lightGray, for: .normal)
        container.segueIdentifierReceivedFromParent("phoneContact")
    }
    
    @IBAction func didTappedAppContact(_ sender: Any) {
        GlobalConstant.isController2 = "2"
        
        buttonAppContact.setTitleColor(Global.hexStringToUIColor("#0166ff"), for: .normal)
        buttonPhoneContact.setTitleColor(.lightGray, for: .normal)
        container.segueIdentifierReceivedFromParent("appContact")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "container2" {
            self.container = segue.destination as? ContainerViewController
        }
    }
}

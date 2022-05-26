//
//  CustomAlert.swift
//  ScreenOPSN
//
//  Created by Ravi Goradiya on 14/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class CustomAlert: UIViewController {
    
    var alertMsg:String = ""
    
    @IBOutlet weak var labelAlertMsg: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelAlertMsg.text = alertMsg
        
    }
    
    @IBAction func dismissAlert(_ sender: Any) {
    
        self.dismiss(animated: false, completion: nil)
    }


}

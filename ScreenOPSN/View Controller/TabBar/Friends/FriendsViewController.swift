//
//  FriendsViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 28/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!

    // MARK: PROPERTIES
     var container: ContainerViewController!
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
        GlobalConstant.isController = "1"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        Global.setNavBarColor_isTranslucentTruef(vc: self)
        
        
        if GlobalConstant.isController == "1" {
            labelTwo.isHidden = true
            labelThree.isHidden = true
            labelOne.isHidden = false
            container.firstLinkedSubView = "allcontact"

        } else if GlobalConstant.isController == "2" {
            labelTwo.isHidden = false
            labelThree.isHidden = true
            labelOne.isHidden = true
            container.firstLinkedSubView = "request"

        } else if GlobalConstant.isController == "3" {
            labelTwo.isHidden = true
            labelThree.isHidden = false
            labelOne.isHidden = true
            
            container.firstLinkedSubView = "suggetion"
        }
        
    
        
    
    }
    
    // MARK: Button Action
    
    @IBAction func didTappedSearchAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SearchFriendViewController") as! SearchFriendViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
           
        
    }
    
    
    @IBAction func didTappedAllContactAction(_ sender: Any) {
        GlobalConstant.isController = "1"
        labelOne.isHidden = false
        labelTwo.isHidden = true
        labelThree.isHidden = true
        container.segueIdentifierReceivedFromParent("allcontact")

    }
    
    @IBAction func didTappedRequestAction(_ sender: Any) {
        GlobalConstant.isController = "2"

       labelOne.isHidden = true
       labelTwo.isHidden = false
       labelThree.isHidden = true
       container.segueIdentifierReceivedFromParent("request")

    }

    @IBAction func didTappedSuggestionsAction(_ sender: Any) {
       GlobalConstant.isController = "3"

       labelOne.isHidden = true
       labelTwo.isHidden = true
       labelThree.isHidden = false
       container.segueIdentifierReceivedFromParent("suggetion")

    }
    
    @IBAction func didTappedOnBackButton(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "container" {
            self.container = segue.destination as? ContainerViewController
         }
    }
}




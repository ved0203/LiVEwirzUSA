//
//  LanyardViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 03/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class LanyardViewController: UIViewController {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var labelEventTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    
    var getData: NSDictionary = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global.navigatioinBarClear(vc: self)
        
        let image = Global.getStringValue(getData.value(forKey: "image_url") as AnyObject)
        eventImage.downloadImage(from: image)
        labelEventTitle.text = Global.getStringValue(getData.value(forKey: "event_name") as AnyObject)
        labelDate.text = "\(Global.getStringValue(getData.value(forKey: "event_date") as AnyObject)) \(Global.getStringValue(getData.value(forKey: "event_time") as AnyObject))"
        labelAddress.text = Global.getStringValue(getData.value(forKey: "city_name") as AnyObject)
    }
    
    @IBAction func didTappedForGoingToCheckOut(_ sender: Any) {
        
         let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
         let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CompleteOrderViewController") as! CompleteOrderViewController
         self.navigationController?.pushViewController(nextViewController, animated: true)

       /* let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CheckOutViewController") as! CheckOutViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)*/
    }
    
    @IBAction func didTappedOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTappedForBack(_ sender: Any) {
        // Create the alert controller
        let alertController = UIAlertController(title: "Message", message: "OK, we’ve emailed you a QR code to pick it up. Just present it at any LiVEwirz booth at the show.", preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "Ok", style: .default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.sendBack()
        }
        // Add the actions
        alertController.addAction(okAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sendBack() {
        if let navController = self.navigationController {
            let array = navController.viewControllers
            for item in array {
                if item is EventSearchViewController {
                    self.navigationController?.popToViewController(item, animated: true)
                    break
                }
            }
        }
    }
}

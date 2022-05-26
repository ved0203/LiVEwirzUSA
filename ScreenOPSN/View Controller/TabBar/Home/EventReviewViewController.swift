//
//  EventReviewViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import FBSDKShareKit
import FloatRatingView

import Social

class EventReviewViewController: UIViewController, SharingDelegate {
    
    @IBOutlet weak var eventReviewTextView: UITextView!
    @IBOutlet weak var concertImage: UIImageView!
    @IBOutlet weak var concertDate: UILabel!
    @IBOutlet weak var concertLocation: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var transparentBackground: UIView!
    @IBOutlet weak var popView: UIViewPropertys!
    @IBOutlet weak var profileView: UIViewPropertys!
    @IBOutlet weak var submit: UIButton!
    
    var eventDetails: NSDictionary = NSDictionary()
    var arrayEvents: NSArray = NSArray()
    @IBOutlet weak var ratingView: FloatRatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      alertShow(hide: true, status: "")

        self.setEventDetails(event: eventDetails)

        self.eventReviewTextView.layer.cornerRadius = 10
        self.eventReviewTextView.layer.borderWidth = 1
        self.eventReviewTextView.layer.borderColor = (UIColor.lightGray).cgColor
        
        self.eventReviewTextView.isEditable = true
        self.eventReviewTextView.isSelectable = true
        self.ratingView.isUserInteractionEnabled = true
        self.submit.isHidden = false
        
        PostDataForGetEventReview()
        
        eventReviewTextView.tintColor = UIColor.black
     }
    
      override func viewWillAppear(_ animated: Bool) {
              Global.navigatioinBarClear(vc: self)
        }
    
     func setEventDetails(event: NSDictionary) {
           
               
           let image = Global.getStringValue(event.value(forKey: "image_url") as AnyObject)
                  concertImage.downloadImage(from: image)
                  eventName.text = Global.getStringValue(event.value(forKey: "event_name") as AnyObject)
                  concertDate.text = Global.getStringValue(event.value(forKey: "event_date") as AnyObject)
                  concertLocation.text = Global.getStringValue(event.value(forKey: "address") as AnyObject)
    
       }

    func PostDataForGetEventReview() {
        
            if Global.isInternetAvailable() {
               Global.showActivityIndicator(self.view)
               var dictPost:[String: AnyObject]!
                  let userid = UserDefaults.standard.value(forKey: "userid") as! String
                let event_id  = Global.getStringValue(eventDetails.value(forKey: "event_id") as AnyObject)
                dictPost = ["userid": userid as AnyObject, "event_id": event_id as AnyObject]
                
                WebHelper.requestPostUrl(strURL: APIName.kkPosted_event_list, Dictionary: dictPost, Success:{
                success in
                 
                    Global.hideActivityIndicator(self.view)
                    
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                if resultString == "0" {
                    
                } else if resultString == "1" {
                    self.arrayEvents = success.object(forKey: "response") as! NSArray
 
                    let dictEvent = self.arrayEvents.firstObject as! NSDictionary
                    let comment = Global.getStringValue(dictEvent.value(forKey: "comment") as AnyObject)
                    self.eventReviewTextView.text = comment
                    
                    let rating = Global.getStringValue(dictEvent.value(forKey: "rating") as AnyObject)
                    self.ratingView.rating = Double(rating)!
                    
                    self.eventReviewTextView.isEditable = false
                    self.eventReviewTextView.isSelectable = false
                    self.ratingView.isUserInteractionEnabled = false
                    self.submit.isHidden = true
                 }
                }, Failure: {
                       failure in
                Global.hideActivityIndicator(self.view)
                })
                } else {
                Global.hideActivityIndicator(self.view)
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
    
    func alertShow(hide: Bool, status: String) {
        transparentBackground.isHidden = hide
        popView.isHidden = hide
        profileView.isHidden = hide
    }
    
    @IBAction func didTappedOnBackButton(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didTappedOkButton(_ sender: Any) {
        alertShow(hide: true, status: "")
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tab bar")
//        self.present(nextViewController, animated: true, completion: nil)
         
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTappedSubmitButton(_ sender: Any) {
//        Global.showActivityIndicator(self.view)
//
//        let seconds = 2.0
//        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
//            Global.hideActivityIndicator(self.view)
//            self.alertShow(hide: false, status: "")
//        }

        PostAddEventReview()
   }
    
    func PostAddEventReview() {
        Global.showActivityIndicator(self.view)
        
        let review_by_userid = UserDefaults.standard.value(forKey: "userid") as! String
        let event_id  = Global.getStringValue(eventDetails.value(forKey: "event_id") as AnyObject)
        let rating = ratingView.rating
        let comment = eventReviewTextView.text
        
        var dictPost:[String: AnyObject]!
        dictPost = ["event_id": event_id as AnyObject, "review_by_userid": review_by_userid as AnyObject, "rating": rating as AnyObject, "comment": comment as AnyObject]

        WebHelper.requestPostUrl(strURL: APIName.kkAdd_event_review, Dictionary: dictPost, Success:{ success in

            Global.hideActivityIndicator(self.view)
            
            let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
            if resultString == "0" {
                
            }else if resultString == "1" {
                self.alertShow(hide: false, status: "")
            }
        }, Failure: { failure in
            Global.showAlertMessageWithOkButtonAndTitle(GlobalConstant.APP_NAME, andMessage: failure.localizedDescription)
        })
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
        
//        shareTextOnFaceBook()
       }
    
    func shareTextOnFaceBook() {
        let shareContent = ShareLinkContent()
        shareContent.contentURL = URL.init(string: "https://developers.facebook.com")! //your link
        shareContent.quote = "Text to be shared"
        ShareDialog(fromViewController: self, content: shareContent, delegate: self).show()
    }

    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        if sharer.shareContent.pageID != nil {
            print("Share: Success")
        }
    }
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("Share: Fail")
    }
    func sharerDidCancel(_ sharer: Sharing) {
        print("Share: Cancel")
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

//
//  VaultViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 28/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import AVFoundation

class VaultViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: IBOutlet
    @IBOutlet weak var videosCollectionView: UICollectionView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var stuffCollectionView: UICollectionView!
    @IBOutlet weak var showsTableView: UITableView!
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var labelFour: UILabel!
    
    @IBOutlet weak var lblMyShowBorder: UILabel!
    @IBOutlet weak var lblScreenTags: UILabel!
    
    @IBOutlet weak var transparentBackground: UIView!
    @IBOutlet weak var popView: UIViewPropertys!
    @IBOutlet weak var profileView: UIViewPropertys!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewlittle: UIView!
    @IBOutlet weak var noDataFound: UILabel!
    
    @IBOutlet weak var btnDeleteMultiple: UIButton!
    @IBOutlet weak var viewMultiDelete: UIView!
    
    @IBOutlet weak var viewForEvents: UIView!
    @IBOutlet weak var lblComingSoon: UILabel!
    
    var strSelectionType = "show"
    var videosArray: NSArray =  NSArray()
    var imageArray: NSArray =  NSArray()
    var multiDeleteArray: [NSDictionary] = []
    
    var stuffArray:[UIImage] = [#imageLiteral(resourceName: "3"),#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "2"),#imageLiteral(resourceName: "4"),#imageLiteral(resourceName: "3"),#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "2"),#imageLiteral(resourceName: "4"),#imageLiteral(resourceName: "3"),#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "2"),#imageLiteral(resourceName: "4"),#imageLiteral(resourceName: "3"),#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "2"),#imageLiteral(resourceName: "4"),#imageLiteral(resourceName: "3"),#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "2"),#imageLiteral(resourceName: "4"),#imageLiteral(resourceName: "3"),#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "2"),#imageLiteral(resourceName: "4")]
    
    var my_Event: NSArray = NSArray()
    
    var imagevideo = ""
    var dicDeleteItem = [String: String]()
    
    var isDelete = false
    var isMultipleDelete = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showsTableView.delegate = self
        self.showsTableView.dataSource = self
        
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        
        self.videosCollectionView.delegate = self
        self.videosCollectionView.dataSource = self
        
        self.stuffCollectionView.delegate = self
        self.stuffCollectionView.dataSource = self
        
        self.showsTableView.backgroundColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("reloadVault"), object: nil)
        
        self.noDataFound.text = "NO SHOWS YET"
        
        self.showsTableView.isHidden = false
        self.imageCollectionView.isHidden = true
        self.videosCollectionView.isHidden = true
        self.stuffCollectionView.isHidden = true
        self.handleItemSectionSelection(type: "show")
        
        self.labelOne.isHidden = false
        self.labelTwo.isHidden = true
        self.labelThree.isHidden = true
        // self.labelFour.isHidden = true
        
        postDataForGetAddedEvent()
        
        setupLongGestureVideoCollection()
        setupLongGestureImageCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.hideDeleteView(hide: true)
        
        self.navigationItem.hidesBackButton = true
        Global.setNavBarColor_isTranslucentTruef(vc: self)
        
        if self.labelTwo.isHidden == false{
            self.postDataForGetVaultPhoto()
        }else if self.labelOne.isHidden == false{
            self.postDataForGetAddedEvent()
        }else if self.labelThree.isHidden == false{
            self.postDataForGetVaultVideo()
        }
    }
    
    private func setupLongGestureVideoCollection() {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleVideoLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.videosCollectionView?.addGestureRecognizer(lpgr)
    }
    
    private func setupLongGestureImageCollection() {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleImageLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.imageCollectionView?.addGestureRecognizer(lpgr)
    }
    
    @objc func handleVideoLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }
        
        let p = gestureRecognizer.location(in: self.videosCollectionView)
        
        if let indexPath = self.videosCollectionView?.indexPathForItem(at: p) {
            print("Long press at item: \(indexPath.row)")
        }
    }
    
    @objc func handleImageLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }
        
        let p = gestureRecognizer.location(in: self.imageCollectionView)
        
        if let indexPath = self.imageCollectionView?.indexPathForItem(at: p) {
            print("Long press at item: \(indexPath.row)")
        }
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        self.showsTableView.isHidden = false
        self.imageCollectionView.isHidden = true
        self.videosCollectionView.isHidden = true
        self.stuffCollectionView.isHidden = true
        self.handleItemSectionSelection(type: "show")
        
        self.labelOne.isHidden = false
        self.labelTwo.isHidden = true
        self.labelThree.isHidden = true
        
        self.hideDeleteView(hide: true)
        
        postDataForGetAddedEvent()
    }
    
    // MARK: IBAction
    
    @IBAction func didTappedOnOptions(_ sender: UIButton) {
        if(sender.tag == 1){
            lblComingSoon.isHidden = true
            viewForEvents.isHidden = false
            lblMyShowBorder.isHidden = false
            lblScreenTags.isHidden = true
        }else{
            lblComingSoon.isHidden = false
            viewForEvents.isHidden = true
            lblMyShowBorder.isHidden = true
            lblScreenTags.isHidden = false
        }
    }
    
    @IBAction func didTappedForDeleteEvent(_ sender: Any) {
        self.statusLabel.text = "Deleting this event will remove all pictures and videos from this concert, and access to exclusive content will be revoked. THIS CAN NOT BE UNDONE. Are you sure?"
        hideDeleteView(hide: false)
    }
    
    func hideDeleteView(hide: Bool) {
        self.transparentBackground.isHidden = hide
        self.popView.isHidden = hide
        self.profileView.isHidden = hide
    }
    
    func handleItemSectionSelection(type: String) {
        strSelectionType = type
        multiDeleteArray.removeAll()
        viewMultiDelete.isHidden = true
    }
    
    func selectItem(selectedObj : NSDictionary){
        
        if let i = multiDeleteArray.firstIndex(of: selectedObj as NSDictionary){
            multiDeleteArray.remove(at: i)
        } else {
            multiDeleteArray.append(selectedObj as NSDictionary)
        }
        
        if multiDeleteArray.count > 0 {
            viewMultiDelete.isHidden = false
            isMultipleDelete = true
        } else {
            viewMultiDelete.isHidden = true
            isMultipleDelete = false
        }
        
        if self.strSelectionType == "photo" {
            // self.imageCollectionView.reloadItems(at: [IndexPath(row: (sender as AnyObject).tag, section: 0)])
            self.imageCollectionView.reloadData()
        } else if self.strSelectionType == "video" {
            // self.videosCollectionView.reloadItems(at: [IndexPath(row: (sender as AnyObject).tag, section: 0)])
            self.videosCollectionView.reloadData()
        }
        
        if self.strSelectionType == "photo" {
            if multiDeleteArray.count == imageArray.count {
                self.btnDeleteMultiple.setImage(UIImage(named: "check_box"), for: .normal)
            } else {
                self.btnDeleteMultiple.setImage(UIImage(named: "uncheck_box"), for: .normal)
            }
        } else if self.strSelectionType == "video" {
            if multiDeleteArray.count == videosArray.count {
                self.btnDeleteMultiple.setImage(UIImage(named: "check_box"), for: .normal)
            } else {
                self.btnDeleteMultiple.setImage(UIImage(named: "uncheck_box"), for: .normal)
            }
        }
    }
    
    @IBAction func didTappedEventDetail(_ sender: Any) {
        print("didTappedEventDetail = ShowMediaDetailController")
        let event = self.my_Event[(sender as AnyObject).tag] as! NSDictionary
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ShowMediaDetailController") as! ShowMediaDetailController
        nextViewController.eventId = event["event_id"] as! String
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func didTappedOffButton(_ sender: Any) {
        self.viewlittle.isHidden = true
        hideDeleteView(hide: true)
    }

    @IBAction func didTappedSelectDeSelectAll(_ sender: Any) {
        if self.strSelectionType == "photo" {
            if multiDeleteArray.count == imageArray.count {
                multiDeleteArray.removeAll()
                viewMultiDelete.isHidden = true
                isMultipleDelete = false
                self.btnDeleteMultiple.setImage(UIImage(named: "check_box"), for: .normal)
            } else {
                multiDeleteArray.removeAll()
                multiDeleteArray.append(contentsOf: imageArray as! [NSDictionary])
                isMultipleDelete = true
                self.btnDeleteMultiple.setImage(UIImage(named: "check_box"), for: .normal)
            }
            
            self.imageCollectionView.reloadData()
            
        } else if self.strSelectionType == "video" {
            if multiDeleteArray.count == videosArray.count {
                multiDeleteArray.removeAll()
                viewMultiDelete.isHidden = true
                isMultipleDelete = false
                self.btnDeleteMultiple.setImage(UIImage(named: "check_box"), for: .normal)
            } else {
                multiDeleteArray.removeAll()
                multiDeleteArray.append(contentsOf: videosArray as! [NSDictionary])
                isMultipleDelete = true
                self.btnDeleteMultiple.setImage(UIImage(named: "check_box"), for: .normal)
            }
            
            self.videosCollectionView.reloadData()
        }
    }
    
    @IBAction func didTappedSelectMultiItem(_ sender: Any) {
        
        var selectedObj : [String : String] = [:]
        if self.strSelectionType == "photo" {
            selectedObj = self.imageArray[(sender as AnyObject).tag] as! [String : String]
        } else if self.strSelectionType == "video" {
            selectedObj = self.videosArray[(sender as AnyObject).tag] as! [String : String]
        }
        self.selectItem(selectedObj: selectedObj as NSDictionary)
    }
    
    @IBAction func didTappedDeleteImage(_ sender: Any) {
        
        dicDeleteItem = self.imageArray[(sender as AnyObject).tag] as! [String : String]
        isDelete = true
        print("dict ",dicDeleteItem)
        self.imagevideo = "1"
        self.statusLabel.text = "Are you sure you want to delete this photo?"
        hideDeleteView(hide: false)
    }
    
    @IBAction func didTappedDeleteMultiItems() {
        self.statusLabel.text = "Are you sure you want to delete all selected items?"
        hideDeleteView(hide: false)
    }
    
    @IBAction func didTappedDeleteVideo(_ sender: Any) {
        dicDeleteItem = self.videosArray[(sender as AnyObject).tag] as! [String : String]
        isDelete = true
        self.imagevideo = "2"
        self.statusLabel.text = "Are you sure you want to delete this video?"
        // postDataForDelete(vaultid: Global.getStringValue((dic as AnyObject).value(forKey: "vaultid") as AnyObject))
        hideDeleteView(hide: false)
    }
    
    @IBAction func didTappedShowsActionButton(_ sender: Any) {
        self.noDataFound.text = "NO SHOWS YET"
        
        self.handleItemSectionSelection(type: "show")
        self.showsTableView.isHidden = false
        self.imageCollectionView.isHidden = true
        self.videosCollectionView.isHidden = true
        self.stuffCollectionView.isHidden = true
        
        self.labelOne.isHidden = false
        self.labelTwo.isHidden = true
        self.labelThree.isHidden = true
        
        postDataForGetAddedEvent()
    }
    
    @IBAction func didTappedPhotosActionButton(_ sender: Any) {
        self.noDataFound.text = "NO PHOTOS YET"
        
        self.handleItemSectionSelection(type: "photo")
        self.showsTableView.isHidden = true
        self.imageCollectionView.isHidden = false
        self.videosCollectionView.isHidden = true
        self.stuffCollectionView.isHidden = true
        
        self.labelOne.isHidden = true
        self.labelTwo.isHidden = false
        self.labelThree.isHidden = true
        
        postDataForGetVaultPhoto()
    }
    
    @IBAction func didTappedVideoActionButton(_ sender: Any) {
        self.noDataFound.text = "NO VIDEOS YET"
        
        self.handleItemSectionSelection(type: "video")
        self.showsTableView.isHidden = true
        self.imageCollectionView.isHidden = true
        self.videosCollectionView.isHidden = false
        self.stuffCollectionView.isHidden = true
        
        self.labelOne.isHidden = true
        self.labelTwo.isHidden = true
        self.labelThree.isHidden = false
        
        postDataForGetVaultVideo()
    }
    
    @IBAction func didTappedStuffActionButton(_ sender: Any) {
        self.noDataFound.text = "NO STUFF YET"
        
        self.handleItemSectionSelection(type: "stuff")
        self.showsTableView.isHidden = true
        self.imageCollectionView.isHidden = true
        self.videosCollectionView.isHidden = true
        self.stuffCollectionView.isHidden = false
        
        self.labelOne.isHidden = true
        self.labelTwo.isHidden = true
        self.labelThree.isHidden = true
        
        self.noDataFound.isHidden = true
        self.stuffCollectionView.reloadData()
    }
    
    @IBAction func didTappedEventDetailButton(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
        let event = self.my_Event[sender.tag] as! NSDictionary
        
        nextVC.naviLatitude = Global.getStringValue(event.value(forKey: "longitude") as AnyObject)
        nextVC.naviLongitude = Global.getStringValue(event.value(forKey: "latitude") as AnyObject)
        
        nextVC.eventDetails = event
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func postDataForDelete(vaultid: String) {
        dicDeleteItem = [:]
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            
            var dictPost:[String: AnyObject]!
            dictPost = ["userid": userid as AnyObject,"vaultid": vaultid as AnyObject ]
            
            WebHelper.requestPostUrl(strURL: APIName.kkDelete_vault_content, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    if self.imagevideo == "1" {
                        self.postDataForGetVaultPhoto()
                    } else {
                        self.postDataForGetVaultVideo()
                    }
                    
                } else {
                    Global.hideActivityIndicator(self.view)
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
    
    func postDataForGetAddedEvent() {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            let roleid = UserDefaults.standard.value(forKey: "roleid") as! String
            
            var dictPost:[String: AnyObject]!
            dictPost = ["userid": userid as AnyObject,"roleid": roleid as AnyObject ]
            
            WebHelper.requestPostUrl(strURL: APIName.kkMy_events, Dictionary: dictPost, Success:{
                success in
                
                print(success)
                
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                self.my_Event = []
                
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    
                } else if resultString == "1" {
                    self.my_Event = success.object(forKey: "my_events") as! NSArray
                    
                    Global.hideActivityIndicator(self.view)
                } else {
                    Global.hideActivityIndicator(self.view)
                }
                
                self.showsTableView.reloadData()
                
                if self.my_Event.count > 0 {
                    self.noDataFound.isHidden = true
                }else {
                    self.noDataFound.isHidden = false
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
    
    func postDataForGetVaultPhoto() {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            dictPost = ["userid": userid as AnyObject]
            WebHelper.requestPostUrl(strURL: APIName.kkVault_photos, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                self.imageArray = []
                
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    
                    self.imageArray = success.object(forKey: "response") as! NSArray
                    Global.hideActivityIndicator(self.view)
                } else {
                    Global.hideActivityIndicator(self.view)
                }
                
                self.imageCollectionView.reloadData()
                
                if self.imageArray.count > 0 {
                    self.noDataFound.isHidden = true
                }else {
                    self.noDataFound.isHidden = false
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
    
    func postDataForGetVaultVideo() {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            dictPost = ["userid": userid as AnyObject]
            WebHelper.requestPostUrl(strURL: APIName.kkVault_videos, Dictionary: dictPost, Success:{
                success in
                
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                self.videosArray = []
                
                if resultString == "0" {
                    Global.hideActivityIndicator(self.view)
                    
                } else if resultString == "1" {
                    Global.hideActivityIndicator(self.view)
                    self.videosArray = success.object(forKey: "response") as! NSArray
                } else {
                    Global.hideActivityIndicator(self.view)
                }
                
                self.videosCollectionView.reloadData()
                
                if self.videosArray.count > 0 {
                    self.noDataFound.isHidden = true
                }else {
                    self.noDataFound.isHidden = false
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
    
    private func createVideoThumbnail(from url: URL) -> UIImage? {
        
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.maximumSize = CGSize(width: 60, height: 60)
        
        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            return nil
        }
    }
    
    @IBAction func didTappedReviewAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EventReviewViewController") as! EventReviewViewController
        let dic = self.my_Event[(sender as AnyObject).tag]
        nextViewController.eventDetails = dic as! NSDictionary
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func didTappedDeleteEventAction(_ sender: Any) {
    }
    
    @IBAction func didTappedDeleteButtonOption(_ sender: Any) {
        self.viewlittle.isHidden = true
        self.hideDeleteView(hide: true)
        
        if isMultipleDelete {
            postDataForMiltipleDeleteEvent()
        } else if isDelete {
            postDataForDelete(vaultid: Global.getStringValue((dicDeleteItem as AnyObject).value(forKey: "vaultid") as AnyObject))
        } else {
            let dic = self.my_Event[(sender as AnyObject).tag]
            self.postDataForDeleteEvent(tm_eventid: Global.getStringValue((dic as AnyObject).object(forKey: "tm_eventid") as AnyObject), event_id: Global.getStringValue((dic as AnyObject).object(forKey: "event_id") as AnyObject))
        }
    }
    
    func postDataForDeleteEvent(tm_eventid: String, event_id: String) {
        self.hideDeleteView(hide: true)
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            dictPost = ["userid": userid as AnyObject, "event_id": event_id as AnyObject, "tm_eventid": tm_eventid as AnyObject]
            
            let roleid = UserDefaults.standard.value(forKey: "roleid") as! String
            var apiName = ""
            if roleid == "2" {
                apiName =  APIName.kkDelete_event_by_artist
            } else {
                apiName =  APIName.kkDelete_event_by_fan
            }
            
            WebHelper.requestPostUrl(strURL: apiName , Dictionary: dictPost, Success:{
                success in
                
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                if resultString == "0" {
                    self.titleLabel.text = "Failed"
                    self.statusLabel.text = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                    
                    self.viewlittle.isHidden = false
                    self.hideDeleteView(hide: false)
                    Global.hideActivityIndicator(self.view)
                } else if resultString == "1" {
                    self.postDataForGetAddedEvent()
                    self.titleLabel.text = "Success"
                    self.statusLabel.text = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                    self.viewlittle.isHidden = false
                    self.hideDeleteView(hide: false)
                    
                    Global.hideActivityIndicator(self.view)
                    
                } else {
                    Global.hideActivityIndicator(self.view)
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
    
    func postDataForMiltipleDeleteEvent() {
        self.hideDeleteView(hide: true)
        
        let vaultIds = multiDeleteArray.compactMap { $0["vaultid"] }
        let joinedString = vaultIds.compactMap{ $0 as? String }.joined(separator: ",")
        
        multiDeleteArray.removeAll()
        viewMultiDelete.isHidden = true
        isMultipleDelete = false
        self.btnDeleteMultiple.setImage(UIImage(named: "check_box"), for: .normal)
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)
            
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            dictPost = ["userid": userid as AnyObject, "vaultid": joinedString as AnyObject]
            
            
            WebHelper.requestPostUrl(strURL: APIName.kkMultiDelete_vault_content , Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                if resultString == "0" {
                    self.titleLabel.text = "Failed"
                    self.statusLabel.text = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                    self.viewlittle.isHidden = false
                    self.hideDeleteView(hide: false)
                    Global.hideActivityIndicator(self.view)
                } else if resultString == "1" {
                    self.postDataForGetAddedEvent()
                    self.titleLabel.text = "Success"
                    self.statusLabel.text = Global.getStringValue(success.object(forKey: "message") as AnyObject)
                    self.viewlittle.isHidden = false
                    self.hideDeleteView(hide: false)
                    
                    if self.strSelectionType == "photo" {
                        self.postDataForGetVaultPhoto()
                    } else if self.strSelectionType == "video" {
                        self.postDataForGetVaultVideo()
                    }
                    
                } else {
                    Global.hideActivityIndicator(self.view)
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
}

extension VaultViewController: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 10 * 2) / 3 //some width
        let height = width * 1  //ratio
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == videosCollectionView {
            return self.videosArray.count
        } else if collectionView == imageCollectionView {
            return self.imageArray.count
        } else if collectionView == stuffCollectionView {
            return self.stuffArray.count
        } else {
            return self.videosArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == videosCollectionView {
            let cell: VideosCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideosCollectionViewCell", for: indexPath) as! VideosCollectionViewCell
            
            let video = videosArray[indexPath.row] as! NSDictionary
            cell.videoImage.downloadImage(from: Global.getStringValue(video.value(forKey: "thumbnail") as AnyObject))
            
            cell.dtlButton.tag = indexPath.row
            cell.btnSelect.tag = indexPath.row
            
            if multiDeleteArray.contains(videosArray[indexPath.row] as! NSDictionary) {
                cell.btnSelect.setImage(UIImage(named: "check_box"), for: .normal)
            } else {
                cell.btnSelect.setImage(UIImage(named: "uncheck_box"), for: .normal)
            }
            
            cell.dtlButton.isHidden = self.isMultipleDelete
            
            return cell
        } else if collectionView == imageCollectionView {
            let cell: ImageCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionView", for: indexPath) as! ImageCollectionView
            let image = imageArray[indexPath.row] as! NSDictionary
            cell.userImage.downloadImage(from: Global.getStringValue(image.value(forKey: "thumbnail") as AnyObject))
            cell.dtlButton.tag = indexPath.row
            cell.btnSelect.tag = indexPath.row
            
            if multiDeleteArray.contains(imageArray[indexPath.row] as! NSDictionary) {
                cell.btnSelect.setImage(UIImage(named: "check_box"), for: .normal)
            } else {
                cell.btnSelect.setImage(UIImage(named: "uncheck_box"), for: .normal)
            }
            
            cell.dtlButton.isHidden = self.isMultipleDelete
            
            return cell
        } else if collectionView == stuffCollectionView {
            let cell: StuffCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "StuffCollectionView", for: indexPath) as! StuffCollectionView
            cell.stuffImageView.image = stuffArray[indexPath.row]
            
            return cell
        } else {
            let cell: VideosCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideosCollectionViewCell", for: indexPath) as! VideosCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == stuffCollectionView {
            return
        }
        
        var isImage: Bool = false
        var url: URL!
        var reviewImage: String = ""
        var vaultid: String = ""
        var arrData = NSMutableArray()
        
        if self.isMultipleDelete {
            if collectionView == videosCollectionView {
                self.selectItem(selectedObj: videosArray[indexPath.row] as! NSDictionary)
            } else if collectionView == imageCollectionView {
                self.selectItem(selectedObj: imageArray[indexPath.row] as! NSDictionary)
            }
        } else {
            if collectionView == videosCollectionView {
                isImage = false
                let video = videosArray[indexPath.row] as! NSDictionary
                let imageURL = Global.getStringValue(video.value(forKey: "filename") as AnyObject)
                vaultid = Global.getStringValue(video.value(forKey: "vaultid") as AnyObject)
                url = URL(string: imageURL)!
                arrData = NSMutableArray(array: videosArray)
                
            } else if collectionView == imageCollectionView {
                isImage = true
                let image = imageArray[indexPath.row] as! NSDictionary
                reviewImage = Global.getStringValue(image.value(forKey: "filename") as AnyObject)
                vaultid = Global.getStringValue(image.value(forKey: "vaultid") as AnyObject)
                arrData = NSMutableArray(array: imageArray)
            }
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
            nextViewController.isImage = isImage
            nextViewController.reviewImage = reviewImage
            nextViewController.videoURL = url
            nextViewController.vaultid = vaultid
            nextViewController.arrValute = arrData
            nextViewController.selectindex = indexPath.row
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
}

extension VaultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.my_Event.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyShowsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyShowsTableViewCell", for: indexPath) as! MyShowsTableViewCell
        
        let event = self.my_Event[indexPath.row] as! NSDictionary
        let image = Global.getStringValue(event.value(forKey: "image_url") as AnyObject)
        cell.imgEventProfile.downloadImage(from: image)
        cell.eventLabel.text = Global.getStringValue(event.value(forKey: "event_name") as AnyObject)
        cell.labelDate.text = "\(Global.getStringValue(event.value(forKey: "event_date") as AnyObject)) \(Global.getStringValue(event.value(forKey: "event_time") as AnyObject))"
        cell.labelLocation.text = Global.getStringValue(event.value(forKey: "city_name") as AnyObject)
        
        cell.reviewButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        cell.btnEventDetail.tag = indexPath.row
        cell.detailButton.tag = indexPath.row
        
        cell.reviewButton.setImage(UIImage(named: "edit.png")!.withRenderingMode(.alwaysTemplate), for: .normal)
        cell.reviewButton.tintColor = .white
        
        cell.deleteButton.setImage(UIImage(named: "bin.png")!.withRenderingMode(.alwaysTemplate), for: .normal)
        cell.deleteButton.tintColor = .white
        
        cell.detailButton.setImage(UIImage(named: "location")!.withRenderingMode(.alwaysTemplate), for: .normal)
        cell.detailButton.tintColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
        let event = self.my_Event[indexPath.row] as! NSDictionary
        
        nextVC.naviLatitude = Global.getStringValue(event.value(forKey: "longitude") as AnyObject)
        nextVC.naviLongitude = Global.getStringValue(event.value(forKey: "latitude") as AnyObject)
        
        nextVC.eventDetails = event
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

//
//  FanCommentViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 08/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

protocol FanCommentViewControllerDelegate: AnyObject {
    func didPressedBack()
}

class FanCommentViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var fancommentTable: UITableView!
    @IBOutlet weak var txtComment: UITextView!
    
    // MARK: Veriable
    weak var delegate : FanCommentViewControllerDelegate?
    var postid: String = ""
    var arrayComment: NSArray = NSArray()
    
    // MARK: UI ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(FanCommentViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FanCommentViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }

    }

    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.didPressedBack()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         txtComment.tintColor = .black
        PostDataForGetComment()
        self.fancommentTable.reloadData()
    }
    
    @IBAction func didTappedAddCommentButton(_ sender: Any) {
        self.view.endEditing(true)
        if !txtComment.text!.isEmpty {
            PostDataForComment()
        }
    }
    
    @IBAction func didTappedLikeDislikeAction(_ sender: Any) {
        
        let dic = self.arrayComment[(sender as AnyObject).tag]
        
        let status = Global.getStringValue((dic as AnyObject).object(forKey: "like_status") as AnyObject)
        
        let comment_id = Global.getStringValue((dic as AnyObject).object(forKey: "commentid") as AnyObject)
        
        var passvalue = ""
        
        if status == "0" {
            passvalue = "1"
        } else {
            passvalue = "0"
        }
        self.PostDataForLikeDislike(status: passvalue, postid: postid, commentid: comment_id)
    }
    
    @IBAction func didTappedOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func PostDataForLikeDislike(status: String, postid: String, commentid: String) {
        
        if Global.isInternetAvailable() {
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            dictPost = ["userid": userid as AnyObject, "postid": postid as AnyObject,"status": status as AnyObject, "commentid": commentid as AnyObject]
            
            WebHelper.requestPostUrl(strURL: APIName.kkLike_unlike_on_comment, Dictionary: dictPost, Success:{
                success in
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                if resultString == "0" {
                } else if resultString == "1" {
                    DispatchQueue.main.async {
                        self.PostDataForGetComment()
                    }
                }
            }, Failure: {
                failure in
            })
        } else {
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
    
    func PostDataForGetComment() {
        
        if Global.isInternetAvailable() {
            Global.showActivityIndicator(self.view)

            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            
            dictPost = ["userid":userid as AnyObject ,"postid": postid as AnyObject]
            WebHelper.requestPostUrl(strURL: APIName.kkPost_user_comment_list, Dictionary: dictPost, Success:{
                success in
                Global.hideActivityIndicator(self.view)
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                 if resultString == "1" {
                    self.arrayComment = success.object(forKey: "comments") as! NSArray
                }
                DispatchQueue.main.async {
                    self.fancommentTable.reloadData()
                }
            }, Failure: {
                failure in
            })
        } else {
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
    
    func PostDataForComment() {
        
        if Global.isInternetAvailable() {
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            
            dictPost = ["postid": postid as AnyObject, "userid": userid as AnyObject ,"comment": txtComment.text! as AnyObject]
            WebHelper.requestPostUrl(strURL: APIName.kkPost_user_comment_onpost, Dictionary: dictPost, Success:{
                success in
                
                let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                
                 if resultString == "1" {
                    self.txtComment.text = ""
                }
                self.PostDataForGetComment()

            }, Failure: {
                failure in
            })
        } else {
            self.alert(message: "Internet is not connected!", title: "Internet")
        }
    }
}

extension FanCommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: FanCommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FanCommentTableViewCell", for: indexPath) as! FanCommentTableViewCell
        let fanComment = self.arrayComment[indexPath.row] as! NSDictionary
        
        cell.labelComment.text = Global.getStringValue(fanComment.value(forKey: "comment") as AnyObject)
        cell.labelName.text = Global.getStringValue(fanComment.value(forKey: "comment_by_username") as AnyObject)
        cell.labelDate.text = Global.getStringValue(fanComment.value(forKey: "comment_date") as AnyObject)
        
        let str = Global.getStringValue(fanComment.value(forKey: "user_profile_pic") as AnyObject)
        
        
        let like_status = Global.getStringValue(fanComment.value(forKey: "like_status") as AnyObject)
        
        if like_status == "0" {
            cell.commentButton.setImage(#imageLiteral(resourceName: "heartblank"), for: .normal)
        } else {
            cell.commentButton.setImage(#imageLiteral(resourceName: "liked"), for: .normal)
            
        }
        
        cell.profileImage.layer.cornerRadius = 20
        cell.profileImage.layer.masksToBounds = true
        cell.profileImage.clipsToBounds = true
        cell.commentButton.tag = indexPath.row
        cell.profileImage.sd_setImage(with: URL(string: str), placeholderImage: UIImage(named: "imgpsh_fullsize_anim"))
        return cell
    }
}

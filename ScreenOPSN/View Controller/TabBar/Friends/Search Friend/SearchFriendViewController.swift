//
//  SearchFriendViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 05/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SearchFriendViewController: UIViewController {

    @IBOutlet weak var searchFriendTableView: UITableView!
    @IBOutlet weak var txtKeyword: UITextField!
    @IBOutlet weak var tranparentBG: UIView!
    @IBOutlet weak var bunnyView: UIViewPropertys!
    @IBOutlet weak var popUpView: UIViewPropertys!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var noDataView: UIView!

    var searchFriendArray: NSArray = NSArray()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noDataView.isHidden = false
        self.searchFriendTableView.isHidden = true
        showAler(title: "", bool: true)
        searchFriendTableView.layer.cornerRadius = 10.0
        searchFriendTableView.layer.shadowColor = UIColor.gray.cgColor
        searchFriendTableView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        searchFriendTableView.layer.shadowRadius = 12.0
        searchFriendTableView.layer.shadowOpacity = 0.7
        // Do any additional setup after loading the view.
    }
 
    
    func showAler(title: String, bool: Bool) {
        bunnyView.isHidden = bool
        popUpView.isHidden = bool
        tranparentBG.isHidden = bool
        alertLabel.text = title
    }
    
    func postDataForGetSuggestionList(keyword: String) {
              if Global.isInternetAvailable() {
                  let userid = UserDefaults.standard.value(forKey: "userid") as! String
                  var dictPost:[String: AnyObject]!
                dictPost = ["userid": userid as AnyObject, "keyword": keyword as AnyObject]
                     
                     WebHelper.requestPostUrl(strURL: APIName.kkSearchfrnds, Dictionary: dictPost, Success:{
                             success in
                         
                         let resultString = Global.getStringValue(success.object(forKey: "status") as AnyObject)
                         let message = Global.getStringValue(success.object(forKey: "message") as AnyObject)

                         if resultString == "0" {
                            self.showAler(title: message, bool: true)
                            self.searchFriendTableView.isHidden = true
                            self.noDataView.isHidden = false
                         } else if resultString == "1" {
                            self.searchFriendTableView.isHidden = false
                            self.noDataView.isHidden = true
                          self.searchFriendArray = []
                          self.searchFriendArray = (success.object(forKey: "response") as? NSArray)!
                          print(self.searchFriendArray)
                          self.searchFriendTableView.reloadData()
                         } else {
                           }
                     }, Failure: {
                         failure in
                        self.showAler(title: failure.localizedDescription, bool: true)

                          })
                         } else {
                self.showAler(title: "Internet is not connected!", bool: true)

           }
      }
    
    @IBAction func didTappedOnBackButton(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }

}

extension SearchFriendViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let text: NSString = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        if resultString.isEmpty {
            self.searchFriendTableView.isHidden = true
            self.noDataView.isHidden = false
        } else {
            self.postDataForGetSuggestionList(keyword: resultString)
        }

        return true
    }
}


extension SearchFriendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchFriendArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchFriendTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchFriendTableViewCell", for: indexPath) as! SearchFriendTableViewCell
        let suggestionData = self.searchFriendArray[indexPath.row] as! NSDictionary

        var image = Global.getStringValue(suggestionData.value(forKey: "profile_pic") as AnyObject)
        cell.contactProfileImg.downloadImage(from: image)
        cell.labelcontactName.text = Global.getStringValue(suggestionData.value(forKey: "name") as AnyObject)
         cell.labelshortName.text = Global.getStringValue(suggestionData.value(forKey: "rolename") as AnyObject)
        
       /* cell.imgIcon.image = cell.imgIcon.image?.withRenderingMode(.alwaysTemplate)
        cell.imgIcon.tintColor = Global.hexStringToUIColor("#0166ff")

        cell.bgView.layer.cornerRadius = 17.5
        cell.bgView.layer.borderColor = Global.hexStringToUIColor("#0166ff").cgColor
        cell.bgView.layer.borderWidth = 1.0*/

         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeProfileViewController") as! HomeProfileViewController
        let suggestionData = self.searchFriendArray[indexPath.row] as! NSDictionary
        nextViewController.getDataFromSearch = suggestionData
        nextViewController.isFromHome = false
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}

//
//  ContactListViewController.swift
//  microphone
//
//  Created by Apple on 24/02/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import ContactsUI
import Contacts

import UIKit
import ContactsUI

enum ContactsFilter {
    case none
    case mail
    case message
}

class ContactListViewController: UIViewController, UISearchDisplayDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var friendTableView: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearching: Bool = false
    var filteredData = [PhoneContact]()
    
    var phoneContacts = [PhoneContact]()
    var filter: ContactsFilter = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendTableView.layer.cornerRadius = 10.0
        friendTableView.layer.shadowColor = UIColor.gray.cgColor
        friendTableView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        friendTableView.layer.shadowRadius = 12.0
        friendTableView.layer.shadowOpacity = 0.7
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //call any function
            self.SearchBar.setCustomProperty()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadContacts(filter: filter)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SearchBar.setCustomProperty()
    }
    // Calling loadContacts methods
    
    fileprivate func loadContacts(filter: ContactsFilter) {
        
        Global.showActivityIndicator(self.view)
        
        phoneContacts.removeAll()
        var allContacts = [PhoneContact]()
        for contact in PhoneContacts.getContacts(filter: filter) {
            allContacts.append(PhoneContact(contact: contact))
        }
        
        var filterdArray = [PhoneContact]()
        if self.filter == .mail {
            filterdArray = allContacts.filter({ $0.email.count > 0 }) // getting all email
        } else if self.filter == .message {
            filterdArray = allContacts.filter({ $0.phoneNumber.count > 0 })
        } else {
            filterdArray = allContacts
        }
        let shortedArray = filterdArray.sorted(by: { $0.name < $1.name } )
        phoneContacts.append(contentsOf: shortedArray)
        
        let arrayCode  = self.phoneNumberWithContryCode()
        for codes in arrayCode {
            print(codes)
        }
        DispatchQueue.main.async {
            self.friendTableView.reloadData() // update your tableView having phoneContacts array
        }
        Global.hideActivityIndicator(self.view)
    }
    
    func phoneNumberWithContryCode() -> [String] {
        
        let contacts = PhoneContacts.getContacts() // here calling the getContacts methods
        var arrPhoneNumbers = [String]()
        for contact in contacts {
            for ContctNumVar: CNLabeledValue in contact.phoneNumbers {
                if let fulMobNumVar  = ContctNumVar.value as? CNPhoneNumber {
                    //let countryCode = fulMobNumVar.value(forKey: "countryCode") get country code
                    if let MccNamVar = fulMobNumVar.value(forKey: "digits") as? String {
                        arrPhoneNumbers.append(MccNamVar)
                    }
                }
            }
        }
        return arrPhoneNumbers // here array has all contact numbers.
    }
    
    // share text
    @IBAction func shareTextButton(_ sender: UIButton) {
        // text to share
        let text = "Connected lanyards, exclusive backstage content, millions of connected fans. Something new is coming soon! www.livewirz.com"
        
        // set up activity view controller
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            view.endEditing(true)
            self.friendTableView.reloadData()
        } else {
            isSearching = true
            filteredData = phoneContacts.filter({( candy : PhoneContact) -> Bool in
                return (candy.toString() as AnyObject).lowercased.contains(searchText.lowercased())
            })
            self.friendTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        SearchBar.endEditing(true)
    }
}

extension ContactListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return self.filteredData.count
        } else {
            return self.phoneContacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: FriendTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
        
        if isSearching {
            let contact = filteredData[indexPath.row]
            if contact.phoneNumber.count != 0  {
                cell.labelshortName.text = contact.phoneNumber[0]
            }
            cell.labelcontactName.text = contact.name
            
            let str = contact.name
            cell.labelAlphabet.text = "\(str.prefix(1))"
        } else {
            
            let contact = phoneContacts[indexPath.row]
            if contact.phoneNumber.count != 0  {
                cell.labelshortName.text = contact.phoneNumber[0]
            }
            let str = contact.name
            cell.labelAlphabet.text = "\(str.prefix(1))"
            cell.labelcontactName.text = contact.name
        }
        
        cell.imgIcon.image = cell.imgIcon.image?.withRenderingMode(.alwaysTemplate)
        cell.imgIcon.tintColor = Global.hexStringToUIColor("#0166ff")

        cell.bgView.layer.cornerRadius = 17.5
        cell.bgView.layer.borderColor = Global.hexStringToUIColor("#0166ff").cgColor
        cell.bgView.layer.borderWidth = 1.0

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let cornerRadius = 10
        var corners: UIRectCorner = []

        if indexPath.row == 0
        {
            corners.update(with: .topLeft)
            corners.update(with: .topRight)
        }

        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        {
            corners.update(with: .bottomLeft)
            corners.update(with: .bottomRight)
        }

        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: cell.bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        cell.layer.mask = maskLayer
    }
}

extension String {
    
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
}

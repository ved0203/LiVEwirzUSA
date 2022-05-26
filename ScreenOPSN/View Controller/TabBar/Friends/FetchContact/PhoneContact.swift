//
//  PhoneContact.swift
//  microphone
//
//  Created by Apple on 24/02/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import ContactsUI

class PhoneContact: NSObject {
    
    var name = String()
    var avatarData: Data?
    var phoneNumber: [String] = [String]()
    var email: [String] = [String]()
    var isSelected: Bool = false
    var isInvited = false
    
    func toString()-> String{
        return "PhoneContact{name:"+name+"}"
    }
    
    init(contact: CNContact) {
        name        = contact.givenName + " " + contact.familyName
        avatarData  = contact.thumbnailImageData
        for phone in contact.phoneNumbers {
            phoneNumber.append(phone.value.stringValue)
        }
        for mail in contact.emailAddresses {
            email.append(mail.value as String)
        }
    }
    
    override init() {
        super.init()
    }
}

//
//  ProfileModel.swift
//  Drag and Drop
//
//  Created by Andrei Movila on 6/13/17.
//  Copyright © 2017 Andrei Movila. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import ContactsUI
import MobileCoreServices

class ProfileModel : NSObject, NSItemProviderReading{
    
    var title = "male avatar"
    var subtitle = "don't worry be happy"
    var imageUrlString = "https://"
    var image = #imageLiteral(resourceName: "emptyAvatar")
    var imageUrl : URL {
        return URL(string : self.imageUrlString)!
    }
    
    
    static var readableTypeIdentifiersForItemProvider =  [kUTTypeVCard as String, kUTTypeUTF8PlainText as String]
    override init()
    {
        
    }
    
    required init(itemProviderData data: Data, typeIdentifier: String) throws {
        if typeIdentifier == kUTTypeVCard as String {
            let contacts = try CNContactVCardSerialization.contacts(with: data)
            if let contact = contacts.first {
                title = contact.givenName + contact.familyName
                subtitle = (contact.phoneNumbers.first?.value.stringValue)! + "\n" + ((contact.emailAddresses.first?.value)! as String)
                if contact.imageData != nil{
                image = UIImage(data: contact.imageData!)!
                }
            }
        } else if typeIdentifier == kUTTypeUTF8PlainText as String {
            self.title = String(data: data, encoding: .utf8)!
        } else {
            //throw ContactCardError.invalidTypeIdentifier
        }
    }
    
    
}


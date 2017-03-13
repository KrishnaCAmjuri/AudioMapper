//
//  AMContactManager.swift
//  AudioMapper
//
//  Created by KrishnaChaitanya Amjuri on 12/03/17.
//  Copyright © 2017 Krishna Chaitanya. All rights reserved.
//

/*
 1. Retrieve the Phone Number,Names and Pictures from the phone book. 
 2. Show them as list on the screen.
 3. Provide a search filter on top for searching with names.
 */

import UIKit
import Contacts

struct AMContact {
    var primaryPhoneNumber: String
    var givenName: String
    var thumbImage: UIImage?
}

class AMContactManager: NSObject {

    override init() {
        super.init()
        
    }
    
    func getAllContacts(completion: @escaping ([AMContact]) -> ()) {
        
        let queue = DispatchQueue.global(qos: .background)
        queue.async {
            let keysToFetch = [CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactThumbnailImageDataKey, CNContactImageDataAvailableKey]
            
            let contactStore = CNContactStore()
            
            var allContacts:[CNContact] = [CNContact]()
            
            do {
                let containers:[CNContainer] = try contactStore.containers(matching: nil)
                for eachContainer in containers {
                    let predicate = CNContact.predicateForContactsInContainer(withIdentifier: eachContainer.identifier)
                    let contacts:[CNContact] = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
                    allContacts.append(contentsOf: contacts)
                }
            }catch let error {
                print(error.localizedDescription)
            }
            
            var contactsArray: [AMContact] = [AMContact]()
            
            for contact in allContacts {
                let givenName: String = contact.givenName
                var phoneNumber: String = ""
                var thumbImage: UIImage? = nil
                if contact.phoneNumbers.count > 0 {
                    let number:CNPhoneNumber = contact.phoneNumbers[0].value
                    phoneNumber = number.stringValue
                }
                if contact.imageDataAvailable {
                    if let thumbImgData:Data = contact.thumbnailImageData {
                        thumbImage = UIImage(data: thumbImgData)
                    }
                }
                contactsArray.append(AMContact(primaryPhoneNumber: phoneNumber, givenName: givenName, thumbImage: thumbImage))
            }
            
            DispatchQueue.main.async {
                completion(contactsArray)
            }
        }
    }
    
    func saveContactsInfoToDataBase(contacts: [CNContact]) {
        
        
    }
    
}

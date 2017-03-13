//
//  Contact+CoreDataProperties.swift
//  AudioMapper
//
//  Created by KrishnaChaitanya Amjuri on 12/03/17.
//  Copyright © 2017 Krishna Chaitanya. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact");
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNum: String?
    @NSManaged public var picture: NSData?
    @NSManaged public var recordedAudioPath: String?

}

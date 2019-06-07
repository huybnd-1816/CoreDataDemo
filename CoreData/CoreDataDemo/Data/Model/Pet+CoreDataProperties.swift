//
//  Pet+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by nguyen.duc.huyb on 6/10/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//
//

import Foundation
import CoreData


extension Pet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pet> {
        return NSFetchRequest<Pet>(entityName: "Pet")
    }

    @NSManaged public var name: String?
    @NSManaged public var owner: User?

}

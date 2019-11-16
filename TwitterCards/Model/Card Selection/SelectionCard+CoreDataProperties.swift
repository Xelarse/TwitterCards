//
//  SelectionCard+CoreDataProperties.swift
//  TwitterCards
//
//  Created by Alex Allman on 16/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//
//

import Foundation
import CoreData


extension SelectionCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SelectionCard> {
        return NSFetchRequest<SelectionCard>(entityName: "SelectionCard")
    }

    @NSManaged public var backgroundColorB: Float
    @NSManaged public var backgroundColorG: Float
    @NSManaged public var backgroundColorR: Float
    @NSManaged public var backgroundImg: String
    @NSManaged public var cardTitle: String
    @NSManaged public var handlesArray: String

}

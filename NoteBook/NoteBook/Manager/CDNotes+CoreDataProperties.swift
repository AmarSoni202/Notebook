//
//  CDNotes+CoreDataProperties.swift
//  NoteBook
//
//  Created by Amar Soni on 01/04/25.
//
//

import Foundation
import CoreData


extension CDNotes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDNotes> {
        return NSFetchRequest<CDNotes>(entityName: "CDNotes")
    }

    @NSManaged public var content: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var height: Float
    @NSManaged public var width: Float

}

extension CDNotes : Identifiable {

}

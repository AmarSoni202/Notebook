//
//  CDNotes+CoreDataProperties.swift
//  NoteBook
//
//  Created by Amar Soni on 20/03/25.
//
//

import Foundation
import CoreData


extension CDNotes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDNotes> {
        return NSFetchRequest<CDNotes>(entityName: "CDNotes")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var date: Date?

}

extension CDNotes : Identifiable {

}

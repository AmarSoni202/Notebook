//
//  CoreDataManager.swift
//  NoteBook
//
//  Created by Amar Soni on 20/03/25.
//

import CoreData

final class CoreDataManager {

    init() { }
    static let shared = CoreDataManager()
    lazy var context = persistentContainer.viewContext

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NoteBook")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

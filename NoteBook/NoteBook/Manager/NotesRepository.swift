//
//  NotesRepository.swift
//  NoteBook
//
//  Created by Amar Soni on 20/03/25.
//

import Foundation
import CoreData

protocol NotesRepositoryProtocol {
    func createNotes(Notes: NotesDataModel)
    func getAllNotes() -> [NotesDataModel]
    func updateNotes(Notes: NotesDataModel)
    func deleteNotes(id: UUID)
}

struct NotesRepository: NotesRepositoryProtocol {
  

    private let coreDataManager = CoreDataManager()

    func createNotes(Notes: NotesDataModel) {
        let notes = CDNotes(context: coreDataManager.context)
        notes.id = notes.id ?? UUID()
        notes.title = Notes.title
        notes.content = Notes.content
        notes.date = Date()
        coreDataManager.saveContext()
    }
    
    func getAllNotes() -> [NotesDataModel] {
        guard let notes = try? coreDataManager.context.fetch(CDNotes.fetchRequest()) as? [CDNotes] else {
            return []
        }
        var notesDataModel: [NotesDataModel] = []
        
        notes.forEach {
            notesDataModel.append(NotesDataModel(id: $0.id ?? UUID(),
                                                 title: $0.title ?? "",
                                                 content: $0.content ?? "",
                                                 date: $0.date ?? Date()))
        }
        print(notes)
        return notesDataModel
    }

    func updateNotes(Notes: NotesDataModel) {
        guard let noteToUpdate = getNoteByID(Notes.id) else {
            return
        }

        noteToUpdate.title = Notes.title
        noteToUpdate.content = Notes.content
        coreDataManager.saveContext()
    }

    func deleteNotes(id: UUID) {
        guard let noteToDelete = getNoteByID(id) else {
            return
        }
        coreDataManager.context.delete(noteToDelete)
        coreDataManager.saveContext()
    }

    private func getNoteByID(_ id: UUID) -> CDNotes? {
        let fetchRequest: NSFetchRequest<CDNotes> = CDNotes.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            return try coreDataManager.context.fetch(fetchRequest).first
        } catch {
            print("Fetching failed with error: \(error.localizedDescription)")
            return nil
        }
    }

}

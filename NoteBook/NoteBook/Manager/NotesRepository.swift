//
//  NotesRepository.swift
//  NoteBook
//
//  Created by Amar Soni on 20/03/25.
//

import Foundation
import CoreData

protocol NotesRepositoryProtocol {
    func createNotes(notes: NotesDataModel)
    func getAllNotes() -> [NotesDataModel]
    func updateNotes(notes: NotesDataModel)
    func deleteNotes(id: UUID)
}

struct NotesRepository: NotesRepositoryProtocol {
  

    private let coreDataManager = CoreDataManager()

    func createNotes(notes: NotesDataModel) {
        let noteObj = CDNotes(context: coreDataManager.context)
        noteObj.id = notes.id
        noteObj.title = notes.title
        noteObj.content = notes.content
        noteObj.date = Date()
        noteObj.height = Float(notes.height ?? 0.0)
        noteObj.width = Float(notes.width ?? 0.0)
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
                                                 date: $0.date ?? Date(),
                                                 height: CGFloat($0.height),
                                                 width: CGFloat($0.width)))
        }
        print(notes)
        return notesDataModel
    }

    func updateNotes(notes: NotesDataModel) {
        guard let noteToUpdate = getNoteByID(notes.id) else {
            return
        }

        noteToUpdate.title = notes.title
        noteToUpdate.content = notes.content
        noteToUpdate.height = Float(notes.height ?? 0.0)
        noteToUpdate.width = Float(notes.width ?? 0.0)
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

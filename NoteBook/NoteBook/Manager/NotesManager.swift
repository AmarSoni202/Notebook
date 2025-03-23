//
//  NotesManager.swift
//  NoteBook
//
//  Created by Amar Soni on 20/03/25.
//

import Foundation

struct NotesManager {
    private let notesRepository = NotesRepository()
    
    func createNote(note: NotesDataModel) {
        notesRepository.createNotes(Notes: note)
    }

    func getAllNotes() -> [NotesDataModel] {
        return notesRepository.getAllNotes()
    }

    func updateNote(note: NotesDataModel) {
        notesRepository.updateNotes(Notes: note)
    }

    func deleteNote(by id: UUID) {
        notesRepository.deleteNotes(id: id)
    }
}

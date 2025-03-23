//
//  NotesDataModel.swift
//  NoteBook
//
//  Created by Amar Soni on 20/03/25.
//

import Foundation

struct NotesDataModel: Identifiable {
    var id: UUID = UUID()
    var title: String?
    var content: String?
    var date: Date = Date()
}

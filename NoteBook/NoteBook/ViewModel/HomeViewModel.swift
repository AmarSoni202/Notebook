//
//  HomeViewModel.swift
//  NoteBook
//
//  Created by Amar Soni on 01/04/25.
//

import Foundation
import UIKit

typealias DataSource = UICollectionViewDiffableDataSource<Section, NotesDataModel>
typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, NotesDataModel>

enum Section: Int, CaseIterable {
    case main
}

class HomeViewModel: NSObject {
    var dataSource: DataSource?

    private var snapshot = DataSourceSnapshot()
    private var noteDataList = [NotesDataModel]()
    var notesManager = NotesManager()
    private var tempData = [NotesDataModel]()

    func loadDatafromCordata() {
        noteDataList = notesManager.getAllNotes().reversed()
        self.tempData = noteDataList
        applySnapshot()
    }

    func getNoteListCount() -> Int {
        noteDataList.count
    }

    func getNoteListData() -> [NotesDataModel] {
        noteDataList
    }

    func updateNotesOnLongPress(at index: Int) {
        self.noteDataList[index].isSelected.toggle()
    }

    func getSelectedNotes() -> (count :Int, selectedNotes: [NotesDataModel]) {
        return (noteDataList.filter({$0.isSelected}).count,
                noteDataList.filter({$0.isSelected}))
    }

    func cancelSelection() {
        self.noteDataList.enumerated().forEach { index, _ in
            self.noteDataList[index].isSelected = false
        }
    }

    func deleteSelectedNotes() {
        noteDataList.forEach { notes in
            if notes.isSelected {
                notesManager.deleteNote(by: notes.id)
            }
        }
        loadDatafromCordata()
    }

    func searchNotes(note text: String) {
        if text.isEmpty {
            noteDataList = tempData
        } else {
            noteDataList = tempData.filter({ $0.content?.lowercased().contains(text.lowercased()) ?? false })
        }
        applySnapshot()
    }

    private func applySnapshot() {
        self.snapshot.deleteAllItems()
        self.snapshot.appendSections(Section.allCases)
        self.snapshot.appendItems(noteDataList)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}


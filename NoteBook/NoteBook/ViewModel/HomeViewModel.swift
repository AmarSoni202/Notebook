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
    var notesManager = NotesManager()

    func applySnapshot() {
        let notes = notesManager.getAllNotes()
        self.snapshot.deleteAllItems()
        self.snapshot.appendSections(Section.allCases)
        self.snapshot.appendItems(notes)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}


//
//  HomeViewController.swift
//  NoteBook
//
//  Created by Amar Soni on 20/03/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak private var headerView: UIView!
    @IBOutlet weak private var addNoteView: UIView!
    @IBOutlet weak private var notesTableView: UITableView!
    
    private let notesmanager = NotesManager()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        addHeaderShadow()
        configureAddNoteViewUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notesTableView.reloadData()
    }
    
    // MARK: - @IBAction
    @IBAction private func addNoteButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addNoteVC = storyboard.instantiateViewController(withIdentifier: "AddNotesViewController") as? AddNotesViewController else { return }
        navigationController?.pushViewController(addNoteVC,
                                                 animated: true)
    }
    
}

extension HomeViewController {
    func addHeaderShadow() {
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        headerView.layer.shadowOpacity = 0.1
        headerView.layer.shadowRadius = 10
    }
    
    func configureAddNoteViewUI() {
        addNoteView.layer.cornerRadius = addNoteView.frame.height / 2
    }
    
    func registerCell() {
        notesTableView.register(UINib(nibName: "NotesTableViewCell", bundle: nil),
                                forCellReuseIdentifier: "NotesTableViewCell")
        notesTableView.delegate = self
        notesTableView.dataSource = self
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesmanager.getAllNotes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotesTableViewCell",
                                                       for: indexPath) as? NotesTableViewCell else {
            return UITableViewCell()
        }
        
        let note = notesmanager.getAllNotes()[indexPath.row]
        cell.setData(model: note)
        
        cell.editAction = { [weak self] in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let addNoteVC = storyboard.instantiateViewController(withIdentifier: "AddNotesViewController") as? AddNotesViewController else { return }
            addNoteVC.note = note
            addNoteVC.isEditNote = true
            self?.navigationController?.pushViewController(addNoteVC,
                                                           animated: true)
            
            
        }
        cell.deleteAction = { [weak self] in
            self?.notesmanager.deleteNote(by: note.id)
            self?.notesTableView.reloadData()
        }
        return cell
    }
}

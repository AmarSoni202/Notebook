//
//  AddNotesViewController.swift
//  NoteBook
//
//  Created by Amar Soni on 20/03/25.
//

import UIKit

class AddNotesViewController: UIViewController {

    // MARK: - @IBOutlet
    @IBOutlet weak private var headerView: UIView!
    @IBOutlet weak private var titleTextfield: UITextField!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var countLabel: UILabel!
    @IBOutlet weak private var contentTextView: UITextView!
    @IBOutlet weak private var saveButton: UIButton!
    
    private let notesManager = NotesManager()
    var note: NotesDataModel?
    var isEditNote: Bool = false
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataOnEdit()
        addHeaderShadow()
        configureUI()
        configureDelegate()
        setInitialUI()
    }

    // MARK: - @IBAction
    @IBAction private func backButton(_ sender: Any) {
        self.goBack()
    }

    @IBAction private func doneButton(_ sender: Any) {
        if isEditNote {
            let note = NotesDataModel(id: note?.id ?? UUID(),
                                      title: titleTextfield.text,
                                      content: contentTextView.text,
                                      date: note?.date ?? Date())
            notesManager.updateNote(note: note)
        } else {
            let note = NotesDataModel(title: titleTextfield.text,
                                      content: contentTextView.text,
                                      date: Date())
            notesManager.createNote(note: note)
        }
        self.goBack()
    }
}

extension AddNotesViewController {
    func setInitialUI() {
        dateLabel.text = dateformatter(date: isEditNote ? note?.date ?? Date() : Date())
    }
    func addHeaderShadow() {
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        headerView.layer.shadowOpacity = 0.1
        headerView.layer.shadowRadius = 10
    }

    func configureDelegate() {
        contentTextView.delegate = self
    }

    func configureUI() {
        saveButton.setTitle(self.isEditNote ? "Update" : "Save", for: .normal)
        countLabel.text = "\(contentTextView.text.count) Characters"
        toggleActiveState(isActive: contentTextView.text.isEmpty)
    }

    func toggleActiveState(isActive: Bool) {
        saveButton.isEnabled = !isActive
        saveButton.setTitleColor(!isActive ? UIColor.primaryActive : UIColor.secondaryText,
                                 for: .normal)
    }

    func setDataOnEdit() {
        guard let note = note else { return }
        titleTextfield.text = note.title
        contentTextView.text = note.content
    }

    func dateformatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy hh:mm a"
        dateFormatter.locale = .current
        dateFormatter.timeZone = TimeZone.current
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
}

extension AddNotesViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        configureUI()
    }
}

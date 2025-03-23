//
//  NotesTableViewCell.swift
//  NoteBook
//
//  Created by Amar Soni on 20/03/25.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    typealias Action = (() -> Void)
    var editAction: Action?
    var deleteAction: Action?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addShadow()
        configureCell()
    }

    @IBAction private func editButton(_ sender: Any) {
        editAction?()
    }

    @IBAction private func deleteButton(_ sender: Any) {
        deleteAction?()
    }
}

// MARK: - Data Handler
extension NotesTableViewCell {
    func setData(model: NotesDataModel) {
        titleLabel.text = model.title?.isEmpty ?? true ? "Untitled" : model.title
    }
}

// MARK: - UI Configuration
extension NotesTableViewCell {

    func addShadow() {
        cellBackgroundView.layer.shadowColor = UIColor.black.cgColor
        cellBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 6)
        cellBackgroundView.layer.shadowOpacity = 0.1
        cellBackgroundView.layer.shadowRadius = 10

        editView.layer.shadowColor = UIColor.black.cgColor
        editView.layer.shadowOffset = CGSize(width: 0, height: 6)
        editView.layer.shadowOpacity = 0.1
        editView.layer.shadowRadius = 10
    }

    func configureCell() {
        cellBackgroundView.layer.cornerRadius = 6
        cellBackgroundView.clipsToBounds = true
        cellBackgroundView.layer.borderWidth = 1
        cellBackgroundView.layer.borderColor = UIColor(named: "borderColor")?.cgColor

        editView.layer.cornerRadius = 6
        editView.clipsToBounds = true
        editView.layer.borderWidth = 1
        editView.layer.borderColor = UIColor(named: "borderColor")?.cgColor
    }
}

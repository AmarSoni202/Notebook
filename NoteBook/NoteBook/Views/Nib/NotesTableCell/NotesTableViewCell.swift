//
//  NotesTableViewCell.swift
//  NoteBook
//
//  Created by Amar Soni on 20/03/25.
//

import UIKit

typealias Action = (() -> Void)

class NotesTableViewCell: UITableViewCell {

    @IBOutlet weak private var cellBackgroundView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var contentLabel: UILabel!
    @IBOutlet weak private var selectButton: UIButton!
    
    // var editAction: Action?
    var deleteAction: Action?
    var selectCell: Action?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addShadow()
        setInitials()
        configureCell()
    }

    @IBAction private func editButton(_ sender: Any) {
        // editAction?()
    }

    @IBAction func selectButtonAction(_ sender: Any) {
        selectCell?()
    }
}

// MARK: - Data Handler
extension NotesTableViewCell {
    func setData(model: NotesDataModel, multipleSelection: Bool = false) {
        titleLabel.text = model.title?.isEmpty ?? true ? "Untitled" : model.title
        contentLabel.text = model.content
        selectButton.isHidden = !multipleSelection
        setSelectButtonImage(model: model)
    }

    func setSelectButtonImage(model: NotesDataModel) {
        selectButton.setImage(model.isSelected ? UIImage.circleCheck : UIImage.circle, for: .normal)
    }
}

// MARK: - UI Configuration
extension NotesTableViewCell {

    func setInitials() {
        selectButton.isHidden = true
    }

    func addShadow() {
        cellBackgroundView.layer.shadowColor = UIColor.black.cgColor
        cellBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 6)
        cellBackgroundView.layer.shadowOpacity = 0.1
        cellBackgroundView.layer.shadowRadius = 10
    }

    func configureCell() {
        cellBackgroundView.layer.cornerRadius = 6
        cellBackgroundView.clipsToBounds = true
        cellBackgroundView.layer.borderWidth = 1
        cellBackgroundView.layer.borderColor = UIColor(named: "borderColor")?.cgColor
    }
}

//
//  NotesCollectionViewCell.swift
//  NoteBook
//
//  Created by Amar Soni on 01/04/25.
//

import UIKit

class NotesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!

    var editAction: Action?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addShadow()
        configureCell() 
    }
    @IBAction private func tapOnCellAction(_ sender: Any) {
        editAction?()
    }

    func configureCellData(item: NotesDataModel) {
        titleLabel.text = item.title?.isEmpty ?? true ? "Untitled" : item.title
        self.noteLabel.text = item.content
    }

    func addShadow() {
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 6)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 10

    }

    func configureCell() {
        containerView.backgroundColor = UIColor.primaryWhite
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(named: "borderColor")?.cgColor
    }
}

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
    @IBOutlet weak private var notesCollectionView: UICollectionView!
    @IBOutlet weak private var layoutButton: UIButton!
    
    private let notesmanager = NotesManager()
    private var viewModel = HomeViewModel()
    
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
        setUpCollectionView()
        viewModel.applySnapshot()
    }

    // MARK: - @IBAction
    @IBAction private func addNoteButton(_ sender: Any) {
        openAddNotesViewController()
    }

    @IBAction private func layoutButtonAction(_ sender: Any) {
        changeLayout()
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
        layoutButton.setImage(UIImage.gridView, for: .normal)
    }
    
    func registerCell() {
        notesTableView.register(UINib(nibName: Constant.notesTableViewCell.rawValue, bundle: nil),
                                forCellReuseIdentifier: Constant.notesTableViewCell.rawValue)
        notesTableView.delegate = self
        notesTableView.dataSource = self
    }

    func changeLayout() {
        let gridImage = UIImage.gridView
        let listImage = UIImage.listView
        if layoutButton.currentImage == gridImage {
            layoutButton.setImage(listImage, for: .normal)
            notesTableView.isHidden = true
            notesCollectionView.isHidden = false
            setUpCollectionView()
            viewModel.applySnapshot()
        } else {
            layoutButton.setImage(gridImage, for: .normal)
            notesTableView.isHidden = false
            notesCollectionView.isHidden = true
        }
    }
}

// MARK: - UITableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesmanager.getAllNotes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constant.notesTableViewCell.rawValue,
            for: indexPath) as? NotesTableViewCell else {
            return UITableViewCell()
        }
        
        let note = notesmanager.getAllNotes()[indexPath.row]
        cell.setData(model: note)
        
        cell.editAction = { [weak self] in
            self?.openEditNoteViewController(note: note)
        }
        cell.deleteAction = { [weak self] in
            self?.notesmanager.deleteNote(by: note.id)
            self?.notesTableView.reloadData()
        }
        return cell
    }
}

// MARK: - UICollectionView
extension HomeViewController {

    func setUpCollectionView() {
        let layout = CustomCompositionalLayout.layout(
            model: notesmanager.getAllNotes(),
            contentWidth: view.frame.width
        )
        notesCollectionView.collectionViewLayout = layout
        
        // Register the cell (only if not done in Interface Builder)
        notesCollectionView.register(UINib(nibName: Constant.notesCollectionViewCell.rawValue,
                                          bundle: nil),
                                    forCellWithReuseIdentifier: Constant.notesCollectionViewCell.rawValue)
        viewModel.dataSource = DataSource(collectionView: notesCollectionView,
                                          cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = self.notesCollectionView.dequeueReusableCell(withReuseIdentifier: Constant.notesCollectionViewCell.rawValue,
                                                                    for: indexPath) as! NotesCollectionViewCell
            cell.configureCellData(item: item)
            cell.editAction = {
                self.openEditNoteViewController(note: item)
            }
            return cell
        })
    }
}

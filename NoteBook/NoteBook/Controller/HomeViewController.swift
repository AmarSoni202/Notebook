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
    @IBOutlet weak private var searchBarContainerView: UIView!
    
    @IBOutlet weak private var selectionCountContainer: UIView!
    @IBOutlet weak private var selectedCountLabel: UILabel!
    @IBOutlet weak private var searchTextField: UITextField!
    
    private let notesmanager = NotesManager()
    private var viewModel = HomeViewModel()
    var isHeaderHidden = false
    private var enableMultipleSelection = false
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadDatafromCordata()
        registerCell()
        addHeaderShadow()
        configureAddNoteViewUI()
        addGesture()
        searchBarContainerView.isHidden = true
        selectionCountContainer.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpCollectionView()
        viewModel.loadDatafromCordata()
        notesTableView.reloadData()
    }
    
    // MARK: - @IBAction
    @IBAction private func addNoteButton(_ sender: Any) {
        openAddNotesViewController()
    }
    
    @IBAction private func layoutButtonAction(_ sender: Any) {
        changeLayout()
    }
    
    @IBAction func cancelSelection(_ sender: Any) {
        viewModel.cancelSelection()
        self.enableMultipleSelection = false
        selectionCountContainer.isHidden = true
        notesTableView.reloadData()
    }
    
    @IBAction func deleteSelectedNotes(_ sender: Any) {
        viewModel.deleteSelectedNotes()
        self.enableMultipleSelection = false
        selectionCountContainer.isHidden = true
        self.notesTableView.reloadData()
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
        searchTextField.delegate = self
    }
    
    func registerCell() {
        notesTableView.register(UINib(nibName: Constant.notesTableViewCell.rawValue, bundle: nil),
                                forCellReuseIdentifier: Constant.notesTableViewCell.rawValue)
        notesTableView.delegate = self
        notesTableView.dataSource = self
        notesCollectionView.delegate = self
    }
    
    func changeLayout() {
        let gridImage = UIImage.gridView
        let listImage = UIImage.listView
        if layoutButton.currentImage == gridImage {
            layoutButton.setImage(listImage, for: .normal)
            notesTableView.isHidden = true
            notesCollectionView.isHidden = false
            setUpCollectionView()
            viewModel.loadDatafromCordata()
        } else {
            layoutButton.setImage(gridImage, for: .normal)
            notesTableView.isHidden = false
            notesCollectionView.isHidden = true
        }
    }
    
    func addGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(handleLongPress(_:)))
        self.notesTableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecoginser: UILongPressGestureRecognizer) {
        guard !self.enableMultipleSelection else {
            return
        }
        
        if gestureRecoginser.state == .began {
            let point = gestureRecoginser.location(in: notesTableView)
            if let indexPath = self.notesTableView.indexPathForRow(at: point) {
                self.enableMultipleSelection = true
                viewModel.updateNotesOnLongPress(at: indexPath.row)
                selectionCountContainer.isHidden = false
                self.updateSelectedCount()
                self.notesTableView.reloadData()
            }
        }
    }
    
    // MARK: - Scroll Behavior
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 && !isHeaderHidden {
            // Scrolling up - hide header
            hideHeader()
        } else if velocity.y < 0 {
            // Scrolling down - show header
            showHeader()
        }
    }
    
    func hideHeader() {
        UIView.animate(withDuration: 0.3) {
            self.searchBarContainerView.transform = CGAffineTransform(translationX: 0,
                                                                      y: -self.searchBarContainerView.frame.height)
        }
        isHeaderHidden = true
        self.searchBarContainerView.isHidden = isHeaderHidden
    }
    
    func showHeader() {
        UIView.animate(withDuration: 0.3) {
            self.searchBarContainerView.transform = .identity
        }
        isHeaderHidden = false
        self.searchBarContainerView.isHidden = false
    }
    
    func updateSelectedCount() {
        self.selectedCountLabel.text = "Selected \(viewModel.getSelectedNotes().count)"
    }
}

// MARK: - UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.searchNotes(note: searchTextField.text ?? "")
        if !notesTableView.isHidden { notesTableView.reloadData() }
    }
}

// MARK: - UITableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNoteListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constant.notesTableViewCell.rawValue,
            for: indexPath) as? NotesTableViewCell else {
            return UITableViewCell()
        }
        
        let note = viewModel.getNoteListData()[indexPath.row]
        cell.setData(model: note, multipleSelection: enableMultipleSelection)
        cell.selectionStyle = .none
        cell.deleteAction = { [weak self] in
            self?.notesmanager.deleteNote(by: note.id)
            self?.notesTableView.reloadData()
        }
        cell.selectCell = { [weak self] in
            self?.viewModel.updateNotesOnLongPress(at: indexPath.row)
            self?.updateSelectedCount()
            self?.notesTableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = viewModel.getNoteListData()[indexPath.row]
        openEditNoteViewController(note: note)
    }
}

// MARK: - UICollectionView
extension HomeViewController: UICollectionViewDelegate {
    
    func setUpCollectionView() {
        let layout = CustomCompositionalLayout.layout(
            model: viewModel.getNoteListData(),
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

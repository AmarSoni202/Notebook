//
//  NavigationManager+Extensions.swift
//  NoteBook
//
//  Created by Amar Soni on 01/04/25.
//

import UIKit

// MARK: - Navigation Methods
extension UIViewController {
    func openAddNotesViewController() {
        let addNotesController = AddNotesViewController.instantiate(from: .Home)
        pushController(viewController: addNotesController)
    }

    func openEditNoteViewController(note: NotesDataModel) {
        let editNoteViewController = AddNotesViewController.instantiate(from: .Home)
        editNoteViewController.note = note
        editNoteViewController.isEditNote = true
        pushController(viewController: editNoteViewController)
    }

    func goBack() {
        navigationController?.popViewController(animated: true)
    }

    func pushController(viewController scene: UIViewController,  animated: Bool = true ) {
        self.navigationController?.pushViewController(scene, animated: animated)
    }
}

extension AppStoryboard {
    var instance: UIStoryboard {
        UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }

    func viewController<T: UIViewController>(viewController: T.Type) -> T {
        let viewController = (viewController as UIViewController.Type).storyboardId
        guard let scene = instance.instantiateViewController(withIdentifier: viewController) as? T else {
            fatalError("\(viewController) not found")
        }
        return scene
    }

    func initalViewController() -> UIViewController? {
        instance.instantiateInitialViewController()
    }
}


// MARK: - Extension For instatiate viewController
extension UIViewController {
    class var storyboardId: String {
        "\(self)"
    }

    static func instantiate(from appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewController: self)
    }
}

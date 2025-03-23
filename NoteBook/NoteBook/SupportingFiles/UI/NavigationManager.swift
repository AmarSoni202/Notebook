//
//  NavigationManager.swift
//  NoteBook
//
//  Created by Amar Soni on 20/03/25.
//

import UIKit

extension UIViewController {
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

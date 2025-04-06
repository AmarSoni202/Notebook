//
//  CompositionalLayout.swift
//  NoteBook
//
//  Created by Amar Soni on 01/04/25.
//

import UIKit

final class CustomCompositionalLayout {
    static func layout(model: [NotesDataModel],
                       contentWidth: CGFloat) -> UICollectionViewCompositionalLayout {
        .init { sectionIndex, enviroment in
            guard let section = Section(rawValue: sectionIndex)
            else { return nil }
            switch section {
            case .main:
                let size = model.map({ CGSize(width: $0.width ?? 0.0,
                                              height: $0.height ?? 0.0)})
                return pinterestSection(size: size, contentWidth: contentWidth)
            }
        }
    }

    
    private static func pinterestSection(
        size: [CGSize],
        contentWidth: CGFloat
    ) -> NSCollectionLayoutSection {
        let spacing: CGFloat = 5
        let gridSection = GridLayout(
            columnsCount: 2,
            itemSizes: size,
            spacing: spacing * 2,
            contentWidth: contentWidth
        ).section
        return gridSection
    }
}

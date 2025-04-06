//
//  GridLayout.swift
//  NoteBook
//
//  Created by Amar Soni on 01/04/25.
//

import Foundation
import UIKit

final class GridLayout {
    
    var section: NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: customLayoutGroup)
        section.contentInsets = .init(top: 0, leading: padding, bottom: 0, trailing: padding)
        return section
    }

    //MARK: - Private methods

    private let numberOfColumns: Int
    private let itemSizes: [CGSize]
    private let spacing: CGFloat
    private let contentWidth: CGFloat

    private var padding: CGFloat {
        spacing / 2
    }
    
    // Padding around cells equal to the distance between cells
    private var insets: NSDirectionalEdgeInsets {
        return .init(top: padding, leading: padding, bottom: padding, trailing: padding)
    }
    
    private lazy var frames: [CGRect] = {
        calculateFrames()
    }()
    
    // Max height for section
    private lazy var sectionHeight: CGFloat = {
        (frames
            .map(\.maxY)
            .max() ?? 0
        ) + insets.bottom
    }()
    
    private lazy var customLayoutGroup: NSCollectionLayoutGroup = {
        print("sectionHeight---", sectionHeight)
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(sectionHeight)
        )
        return NSCollectionLayoutGroup.custom(layoutSize: layoutSize) { _ in
            self.frames.map { .init(frame: $0) }
        }
    }()
    
    init(
        columnsCount: Int,
        itemSizes: [CGSize],
        spacing: CGFloat,
        contentWidth: CGFloat
    ) {
        self.numberOfColumns = columnsCount
        self.itemSizes = itemSizes
        self.spacing = spacing
        self.contentWidth = contentWidth
    }
    
    private func calculateFrames() -> [CGRect] {
        var contentHeight: CGFloat = 0
        
        // Subtract the margin from the total width and divide by the number of columns
        let columnWidth = (contentWidth - insets.leading - insets.trailing) / CGFloat(numberOfColumns)
        print("columnWidth", columnWidth)
        
        // Stores x-coordinate offset for each column. Not changing
        let xOffset = (0..<numberOfColumns).map { CGFloat($0) * columnWidth }
        
        var currentColumn = 0

        // Stores y-coordinate offset for each column.
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        // Total number of frames
        var frames = [CGRect]()
        
        for index in 0..<itemSizes.count {
            let itemSize = itemSizes[index]
            
            // Сalculate the frame.
            let frame = CGRect(
                x: xOffset[currentColumn],
                y: yOffset[currentColumn],
                width: columnWidth,
                height: itemSize.height // * (columnWidth / itemSize.width)
            )
            // Total frame inset between cells and along edges
            .insetBy(dx: padding, dy: padding)
            // Additional top and left offset to account for padding
            .offsetBy(dx: 0, dy: insets.leading)
            
            frames.append(frame)
        
            // Сalculate the height
            let columnLowestPoint = frame.maxY

            contentHeight = max(contentHeight, columnLowestPoint)
            yOffset[currentColumn] = columnLowestPoint
    
            // Adding the next element to the minimum height column.
            currentColumn = yOffset.indexOfMinElement ?? 0
        }
        return frames
    }
}

private extension Array where Element: Comparable {
    // Index of min element in Array
    var indexOfMinElement: Int? {
        guard count > 0 else { return nil }
        var min = first
        var index = 0
        
        indices.forEach { i in
            let currentItem = self[i]
            if let minumum = min, currentItem < minumum {
                min = currentItem
                index = i
            }
        }
        
        return index
    }
}

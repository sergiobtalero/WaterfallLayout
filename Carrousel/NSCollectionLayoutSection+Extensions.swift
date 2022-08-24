//
//  NSCollectionLayoutSection+Extensions.swift
//  Carrousel
//
//  Created by Sergio Bravo Talero on 24/08/22.
//

import UIKit

extension NSCollectionLayoutSection {
    enum NSCollectionLayoutVerticalAlignment {
        case leading
        case trailing
    }
    
    static func makeHorizontalSection(fractionalWidth: NSCollectionLayoutDimension = .fractionalWidth(1.0),
                                      fractionalHeight: NSCollectionLayoutDimension = .fractionalHeight(1.0),
                                      cellHeight: NSCollectionLayoutDimension,
                                      contentInsets: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection {
        let smallItem = NSCollectionLayoutItem.create(fractionalWidth: fractionalWidth,
                                                      fractionalHeight: fractionalHeight,
                                                      contentInsets: contentInsets)
        
        let smallGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: cellHeight)
        let smallGroup = NSCollectionLayoutGroup.horizontal(layoutSize: smallGroupSize,
                                                            subitems: [smallItem])
        
        return NSCollectionLayoutSection(group: smallGroup)
    }
    
    static func makeHorizontalSplitWithDoubleHeightSection(fractionalWidth: NSCollectionLayoutDimension = .fractionalWidth(0.5),
                                                           fractionalHeight: NSCollectionLayoutDimension = .fractionalHeight(1.0),
                                                           cellHeight: NSCollectionLayoutDimension,
                                                           contentInsets: NSDirectionalEdgeInsets,
                                                           alignment: NSCollectionLayoutVerticalAlignment) -> NSCollectionLayoutSection {
        
        // Main Item Group
        let mainItem = NSCollectionLayoutItem.create(fractionalWidth: fractionalWidth,
                                                     fractionalHeight: fractionalHeight,
                                                     contentInsets: contentInsets)
        
        // 2x1 Group
        let pairItem = NSCollectionLayoutItem.create(fractionalWidth: .fractionalWidth(1.0),
                                                     fractionalHeight: .fractionalHeight(0.5),
                                                     contentInsets: contentInsets)
        
        let containerGroupSize = NSCollectionLayoutSize(widthDimension: fractionalWidth,
                                                       heightDimension: fractionalHeight)
        let containerGroup = NSCollectionLayoutGroup.vertical(layoutSize: containerGroupSize,
                                                             subitem: pairItem,
                                                             count: 2)
        
        // Full item
        let mainGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: cellHeight)
        let subitems = alignment == .trailing ? [containerGroup, mainItem] : [mainItem, containerGroup]
        let mainGroup = NSCollectionLayoutGroup.horizontal(layoutSize: mainGroupSize,
                                                           subitems: subitems)
        
        return NSCollectionLayoutSection(group: mainGroup)
    }
}

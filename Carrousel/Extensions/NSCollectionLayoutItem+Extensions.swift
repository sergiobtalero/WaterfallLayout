//
//  NSCollectionLayoutItem+Extensions.swift
//  Carrousel
//
//  Created by Sergio Bravo Talero on 24/08/22.
//

import UIKit

extension NSCollectionLayoutItem {
    static func create(fractionalWidth: NSCollectionLayoutDimension,
                       fractionalHeight: NSCollectionLayoutDimension,
                       contentInsets: NSDirectionalEdgeInsets? = nil) -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: fractionalWidth,
                                              heightDimension: fractionalHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        if let contentInsets = contentInsets {
            item.contentInsets = contentInsets
        }
        return item
    }
}

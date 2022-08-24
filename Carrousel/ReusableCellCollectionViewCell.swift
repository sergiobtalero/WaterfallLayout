//
//  ReusableCellCollectionViewCell.swift
//  Carrousel
//
//  Created by Sergio Bravo Talero on 23/08/22.
//

import UIKit

class ReusableCellCollectionViewCell: UICollectionViewCell {
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    public func configure() {
        contentView.backgroundColor = .red
    }
}

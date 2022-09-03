//
//  ViewController.swift
//  Carrousel
//
//  Created by Sergio Bravo Talero on 23/08/22.
//

import UIKit

final class ViewController: UIViewController {
    private lazy var collectionView: UICollectionView  = {
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.minimumLineSpacing = Constants.sectionInset
        layout.minimumInteritemSpacing = Constants.interItemSpacing
        layout.sectionInset = .init(top: Constants.cellHorizontalPadding,
                                    left: Constants.cellHorizontalPadding,
                                    bottom: Constants.cellHorizontalPadding,
                                    right: Constants.cellHorizontalPadding)
        
        let _collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: layout)
        _collectionView.register(ReusableCollectionViewCell.self,
                                forCellWithReuseIdentifier: "ReusableCell")
        _collectionView.dataSource = self
        return _collectionView
    }()
    
    private lazy var collectionCellInsets: NSDirectionalEdgeInsets = {
        .init(top: Constants.cellVerticalPadding,
              leading: Constants.cellHorizontalPadding,
              bottom: Constants.cellVerticalPadding,
              trailing: Constants.cellHorizontalPadding)
    }()
    
    private var sections: [[CollectionCellType]] { CellVariant.sampleSections }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
}

// MARK: - Constants
private extension ViewController {
    private enum Constants {
        static var cellHeight: CGFloat = 200
        static var cellHorizontalPadding: CGFloat = 4.0
        static var cellVerticalPadding: CGFloat = 2.0
        static var sectionInset: CGFloat = 10.0
        static var interItemSpacing: CGFloat = 10.0
    }
}

// MARK: - UI Configuration
private extension ViewController {
    private func setupLayout() {
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Cells Types
extension ViewController {
    private enum CollectionCellType {
        case single
        case twoColumnsOneRow
        case oneColumnTwoRows
        case twoColumnsTwoRows
    }
    
    private class CellVariant {
        fileprivate static var sampleSections: [[CollectionCellType]]  {
            var sections: [[CollectionCellType]] = []
            
            sections.append([CollectionCellType.twoColumnsOneRow])
            
            var newSection: [CollectionCellType] = []
            newSection.append(contentsOf: Array(repeating: .single, count: 6))
            newSection.append(.oneColumnTwoRows)
            newSection.append(contentsOf: Array(repeating: .single, count: 6))
            sections.append(newSection)
            
            return sections
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        sections[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCell",
                                                      for: indexPath) as! ReusableCollectionViewCell
        cell.configure()
        return cell
    }
}

// MARK: - Layout
extension ViewController: WaterfallLayoutDelegate {
    func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
        if sections[section].count == 1 {
            return .flow(column: 1)
        } else {
            return .waterfall(column: 2, distributionMethod: .balanced)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout: WaterfallLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = collectionView.contentInset
        let fullCellWidth = collectionView.bounds.size.width - insets.left - insets.right
        let halfCellWidth = fullCellWidth / 2 - Constants.interItemSpacing
        let cellHeight: CGFloat = 150
        
        switch sections[indexPath.section][indexPath.row] {
        case .single:
            return CGSize(width: halfCellWidth, height: cellHeight)
        case .oneColumnTwoRows:
            return CGSize(width: halfCellWidth, height: cellHeight * 2)
        case .twoColumnsTwoRows:
            return CGSize(width: fullCellWidth, height: cellHeight * 2)
        case .twoColumnsOneRow:
            return CGSize(width: fullCellWidth, height: cellHeight)
        }
    }
}



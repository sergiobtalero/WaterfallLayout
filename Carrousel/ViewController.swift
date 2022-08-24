//
//  ViewController.swift
//  Carrousel
//
//  Created by Sergio Bravo Talero on 23/08/22.
//

import UIKit

final class ViewController: UIViewController {
    private lazy var collectionView: UICollectionView  = {
        let _collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: createLayout())
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
    
    private var cellModels: [CollectionCellType] { CellVariant.sampleCells }
    
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
    }
}

// MARK: - UI Configuration
private extension ViewController {
    private func setupLayout() {
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch cellModels[section] {
        case let .fullWidthInline(cells),
            let .leadingLargeInline(cells),
            let .products(cells),
            let .trailingLargeInline(cells):
            return cells.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCell",
                                                      for: indexPath) as! ReusableCollectionViewCell
        cell.configure()
        return cell
    }
}

extension ViewController {
    private class CellVariant {
        fileprivate static var sampleCells: [CollectionCellType]  {
            var sections: [CollectionCellType] = []
            
            // Inline with full width
            let singleSectionCell = [CellVariant()]
            
            sections.append(.fullWidthInline(singleSectionCell))
            
            // Products
            sections.append(.products(Array(repeating: CellVariant(), count: 7)))
            
            // Inline with full width
            sections.append(.fullWidthInline(singleSectionCell))
            
            // Leading large inline
            sections.append(.trailingLargeInline(Array(repeating: CellVariant(), count: 3)))
            
            // Products
            sections.append(.products(Array(repeating: CellVariant(), count: 8)))
            
            // Leading large inline
            sections.append(.leadingLargeInline(Array(repeating: CellVariant(), count: 3)))
            
            return sections
        }
    }
}

// MARK: - Layout
private extension ViewController {
    private enum CollectionCellType {
        case fullWidthInline([CellVariant])
        case products([CellVariant])
        case leadingLargeInline([CellVariant])
        case trailingLargeInline([CellVariant])
    }
    
    private func createLayout() -> UICollectionViewLayout{
        UICollectionViewCompositionalLayout(sectionProvider: { [unowned self] index, _ in
            self.getLayout(forSection: index)
        })
    }
    
    private func getLayout(forSection section: Int) -> NSCollectionLayoutSection {
        switch cellModels[section] {
        case .fullWidthInline:
            return NSCollectionLayoutSection.makeHorizontalSection(cellHeight: .absolute(Constants.cellHeight),
                                                                   contentInsets: collectionCellInsets)
        case .products:
            return NSCollectionLayoutSection.makeHorizontalSection(fractionalWidth: .fractionalWidth(0.5),
                                                                   cellHeight: .absolute(Constants.cellHeight),
                                                                   contentInsets: collectionCellInsets)
        case .leadingLargeInline:
            return NSCollectionLayoutSection.makeHorizontalSplitWithDoubleHeightSection(cellHeight: .absolute(Constants.cellHeight * 2),
                                                                                        contentInsets: collectionCellInsets,
                                                                                        alignment: .leading)
        case .trailingLargeInline:
            return NSCollectionLayoutSection.makeHorizontalSplitWithDoubleHeightSection(cellHeight: .absolute(Constants.cellHeight * 2),
                                                                                        contentInsets: collectionCellInsets,
                                                                                        alignment: .trailing)
        }
    }
}



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
        
        return _collectionView
    }()
    
    private var cellModels: [SectionCompositionLayoutType] { CellVariant.sampleCells }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        collectionView.register(ReusableCellCollectionViewCell.self,
                                forCellWithReuseIdentifier: "ReusableCell")
        collectionView.dataSource = self
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
                                                      for: indexPath) as! ReusableCellCollectionViewCell
        cell.configure()
        return cell
    }
}

extension ViewController {
    class CellVariant {
        fileprivate static var sampleCells: [SectionCompositionLayoutType]  {
            var sections: [SectionCompositionLayoutType] = []
            
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
    enum SectionCompositionLayoutType {
        case fullWidthInline([CellVariant])
        case products([CellVariant])
        case leadingLargeInline([CellVariant])
        case trailingLargeInline([CellVariant])
    }
    
    private func createLayout() -> UICollectionViewLayout{
        UICollectionViewCompositionalLayout(sectionProvider: { [unowned self] index, environment in
            self.getLayout(forSection: index)
        })
    }
    
    private func getLayout(forSection section: Int) -> NSCollectionLayoutSection {
        switch cellModels[section] {
        case .fullWidthInline: return makeHorizontalSection(showItemAtFullWidth: true)
        case .products: return makeHorizontalSection(showItemAtFullWidth: false)
        case .leadingLargeInline: return makeHorizontalSplitWithDoubleHeightSection(alignedAtTrailing: false)
        case .trailingLargeInline: return makeHorizontalSplitWithDoubleHeightSection(alignedAtTrailing: true)
        }
    }
    
    private func makeCollectionLayoutItem(fractionalWidth: NSCollectionLayoutDimension,
                                          fractionalHeight: NSCollectionLayoutDimension,
                                          contentInsets: NSDirectionalEdgeInsets? = nil) -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: fractionalWidth,
                                              heightDimension: fractionalHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        if let contentInsets = contentInsets {
            item.contentInsets = contentInsets
        } else {
            item.contentInsets = NSDirectionalEdgeInsets(top: Constants.cellVerticalPadding,
                                                         leading: Constants.cellHorizontalPadding,
                                                         bottom: Constants.cellVerticalPadding,
                                                         trailing: Constants.cellHorizontalPadding)
        }
        
        return item
    }
    
    private func makeHorizontalSection(showItemAtFullWidth: Bool) -> NSCollectionLayoutSection {
        let smallItem = makeCollectionLayoutItem(fractionalWidth: .fractionalWidth(showItemAtFullWidth ? 1 : 0.5),
                                                 fractionalHeight: .fractionalHeight(1.0))
        
        let smallGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(Constants.cellHeight))
        let smallGroup = NSCollectionLayoutGroup.horizontal(layoutSize: smallGroupSize,
                                                            subitems: [smallItem])
        
        return NSCollectionLayoutSection(group: smallGroup)
    }
    
    private func makeHorizontalSplitWithDoubleHeightSection(alignedAtTrailing: Bool) -> NSCollectionLayoutSection {
        // MAIN ITEM AT LEFT
        let mainItem = makeCollectionLayoutItem(fractionalWidth: .fractionalWidth(0.5),
                                                fractionalHeight: .fractionalHeight(1.0))
        
        // 2x1 at Right
        let pairItem = makeCollectionLayoutItem(fractionalWidth: .fractionalWidth(1.0),
                                                fractionalHeight: .fractionalHeight(0.5))
        
        let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                       heightDimension: .fractionalHeight(1.0))
        let containerGroup = NSCollectionLayoutGroup.vertical(layoutSize: containerGroupSize,
                                                             subitem: pairItem,
                                                             count: 2)
        
        // Full item
        let mainGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(Constants.cellHeight * 2))
        let mainGroup = NSCollectionLayoutGroup.horizontal(layoutSize: mainGroupSize,
                                                           subitems: alignedAtTrailing ? [containerGroup, mainItem] : [mainItem, containerGroup])
        
        return NSCollectionLayoutSection(group: mainGroup)
    }
}

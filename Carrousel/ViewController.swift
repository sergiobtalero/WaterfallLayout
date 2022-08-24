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
    
    private var cellModels: [CellVariant] {
        CellVariant.sampleCells
    }
    
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
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCell",
                                                      for: indexPath) as! ReusableCellCollectionViewCell
        cell.configure()
        return cell
    }
}

extension Int {
    var isMultipleOf8: Bool { self % 8 == .zero }
    var isMultipleOf6: Bool { self % 7 == .zero }
}

extension ViewController {
    class CellVariant {
        enum LayoutType {
            case small
            case large
            case verticalLarge
        }
        
        static var sampleCells: [CellVariant]  {
            var cells: [CellVariant] = []
            (0...100).forEach {
                if $0.isMultipleOf8 && $0 != .zero {
                    cells.append(CellVariant(.large))
                } else if $0.isMultipleOf6 {
                    cells.append(CellVariant(.verticalLarge))
                } else {
                    cells.append(CellVariant(.small))
                }
            }
            return cells
        }
        
        let layoutType: LayoutType
        
        // MARK: - Initializer
        init(_ layoutType: LayoutType) {
            self.layoutType = layoutType
        }
    }
}

// MARK: - Layout
private extension ViewController {
    private func createLayout() -> UICollectionViewLayout{
        UICollectionViewCompositionalLayout(sectionProvider: { [unowned self] index, environment in
            self.getLayout(forSection: index)
        })
    }
    
    private func getLayout(forSection: Int) -> NSCollectionLayoutSection {
//        makeLargeSection()
//        makeHorizontalSplitWithSingleHeightSection()
        makeHorizontalSplitWithDoubleHeightSection(alignedAtTrailing: true)
    }
    
    private func makeFullWidthWithFullHeightSection() -> NSCollectionLayoutSection {
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0))
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        largeItem.contentInsets = NSDirectionalEdgeInsets(top: Constants.cellVerticalPadding,
                                                          leading: Constants.cellHorizontalPadding,
                                                          bottom: Constants.cellVerticalPadding,
                                                          trailing: Constants.cellHorizontalPadding)
        
        let largeGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(Constants.cellHeight))
        let largeGroup = NSCollectionLayoutGroup.horizontal(layoutSize: largeGroupSize,
                                                            subitems: [largeItem])
        return NSCollectionLayoutSection(group: largeGroup)
    }
    
    private func makeHorizontalSplitWithSingleHeightSection() -> NSCollectionLayoutSection {
        let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                   heightDimension: .fractionalHeight(1.0))
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
        smallItem.contentInsets = NSDirectionalEdgeInsets(top: Constants.cellVerticalPadding,
                                                          leading: Constants.cellHorizontalPadding,
                                                          bottom: Constants.cellVerticalPadding,
                                                          trailing: Constants.cellHorizontalPadding)
        
        let smallGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(Constants.cellHeight))
        let smallGroup = NSCollectionLayoutGroup.horizontal(layoutSize: smallGroupSize,
                                                            subitems: [smallItem])
        
        return NSCollectionLayoutSection(group: smallGroup)
    }
    
    private func makeHorizontalSplitWithDoubleHeightSection(alignedAtTrailing: Bool) -> NSCollectionLayoutSection {
        // MAIN ITEM AT LEFT
        let mainItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .fractionalHeight(1.0))
        let mainItem = NSCollectionLayoutItem(layoutSize: mainItemSize)
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: Constants.cellVerticalPadding,
                                                         leading: Constants.cellHorizontalPadding,
                                                         bottom: Constants.cellVerticalPadding,
                                                         trailing: Constants.cellHorizontalPadding)
        
        // 2x1 at Right
        let pairItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(0.5))
        let pairItem = NSCollectionLayoutItem(layoutSize: pairItemSize)
        pairItem.contentInsets = NSDirectionalEdgeInsets(top: Constants.cellVerticalPadding,
                                                         leading: Constants.cellHorizontalPadding,
                                                         bottom: Constants.cellVerticalPadding,
                                                         trailing: Constants.cellHorizontalPadding)
        
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

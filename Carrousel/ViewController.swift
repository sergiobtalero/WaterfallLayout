//
//  ViewController.swift
//  Carrousel
//
//  Created by Sergio Bravo Talero on 23/08/22.
//

import UIKit

final class ViewController: UIViewController {
    private lazy var collectionView: UICollectionView  = {
        let waterfallLayout = WaterfallLayout(cellPadding: Constants.cellPadding)
        let _collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: waterfallLayout)
        
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
        
        if let layout = collectionView.collectionViewLayout as? WaterfallLayout {
            layout.delegate = self
        }
    }
}

// MARK: - Constants
private extension ViewController {
    private enum Constants {
        static var cellHeight: CGFloat = 200
        static var cellPadding: CGFloat = 4.0
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

extension ViewController: WaterfallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let model = cellModels[indexPath.row]
        
        switch model.layoutType {
        case .small, .large:
            return Constants.cellHeight
        case .verticalLarge:
            return (Constants.cellHeight * 2) + (Constants.cellPadding * 2)
        }
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

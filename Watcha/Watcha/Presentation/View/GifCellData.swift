//
//  GifCellData.swift
//  Watcha
//
//  Created by hwikang on 10/12/24.
//

import UIKit

public enum Section: Hashable {
    case main
    case carousel
    case grid
    
    
    public var layoutSize: NSCollectionLayoutSection {
        switch self {
        case .main:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                heightDimension: .fractionalHeight(1)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(360))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 12, leading: 16, bottom: 12, trailing: 16)

            return section
            
        case .carousel:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100),
                                                   heightDimension: .absolute(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = .init(top: 12, leading: 16, bottom: 12, trailing: 16)
            section.orthogonalScrollingBehavior = .continuous
            return section
        case .grid:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                heightDimension: .fractionalHeight(1)))
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                   heightDimension: .estimated(160))

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
            group.interItemSpacing = .fixed(8)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = .init(top: 12, leading: 16, bottom: 12, trailing: 16)
            return section
            
        }
    }
}

protocol GifCellProtocol {
    func apply(cellData: CellData)
}
public enum CellData: Hashable {
    
    case gifCell(GIFData)
    
    var id: String {
        switch self {
        case .gifCell: GifCollectionViewCell.id
        }
    }
}

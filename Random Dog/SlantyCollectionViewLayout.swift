//
//  SlantyCollectionViewLayout.swift
//  Random Dog
//
//  Created by Alexsander Akers on 1/31/18.
//  Copyright © 2018 Alexsander Akers. All rights reserved.
//

import UIKit

class SlantyCollectionViewLayout: UICollectionViewLayout {
    @IBInspectable var cellItemHeight: CGFloat = 225

    @IBInspectable var cellSlantHeight: CGFloat = 75

    // MARK: - Private Variables

    fileprivate var numberOfItems: Int = 0

    // MARK: - Collection View

    override class var layoutAttributesClass: AnyClass {
        return SlantyCollectionViewLayoutAttributes.self
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else {
            return
        }

        assert(collectionView.numberOfSections == 1)
        numberOfItems = collectionView.numberOfItems(inSection: 0)
    }

    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }

        let height = cellSlantHeight + CGFloat(numberOfItems) * cellItemHeight
        return CGSize(width: collectionView.bounds.size.width, height: height)
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else {
            return nil
        }

        let width = collectionView.bounds.size.width
        let y = CGFloat(indexPath.item) * cellItemHeight
        let angle = atan2(cellSlantHeight, width)

        let attributes = SlantyCollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.contentViewAngle = -angle
        attributes.frame = CGRect(x: 0, y: y, width: width, height: cellSlantHeight + cellItemHeight)
        attributes.zIndex = indexPath.item

        attributes.contentViewLayerMask = {
            let path = UIBezierPath()
            if indexPath.item == 0 {
                path.move(to: CGPoint(x: 0, y: 0))
            } else {
                path.move(to: CGPoint(x: 0, y: cellSlantHeight))
            }

            path.addLine(to: CGPoint(x: width, y: 0))

            if indexPath.item == numberOfItems {
                path.addLine(to: CGPoint(x: width, y: cellItemHeight))
            } else {
                path.addLine(to: CGPoint(x: width, y: cellItemHeight + cellItemHeight))
            }

            path.addLine(to: CGPoint(x: 0, y: cellSlantHeight + cellItemHeight))
            path.close()
            return path
        }()
        
        return attributes
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let startIndex = max(0, min(numberOfItems - 1, Int(round((rect.minY - cellSlantHeight) / cellItemHeight))))
        let endIndex = max(0, min(numberOfItems - 1, Int(round((rect.maxY - cellSlantHeight) / cellItemHeight))))
        return (startIndex ... endIndex).lazy
            .map { item in IndexPath(item: item, section: 0) }
            .flatMap(layoutAttributesForItem(at:))
    }
}

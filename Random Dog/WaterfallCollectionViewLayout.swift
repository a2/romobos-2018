//
//  WaterfallCollectionViewLayout.swift
//  Random Dog
//
//  Created by Alexsander Akers on 2/16/18.
//  Copyright © 2018 Alexsander Akers. All rights reserved.
//

import UIKit

@objc protocol WaterfallCollectionViewLayoutDelegate: UICollectionViewDelegate {
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, aspectRatioForItemAt indexPath: IndexPath) -> CGFloat
}

class WaterfallCollectionViewLayout: UICollectionViewLayout {
    var numberOfColumns: Int = 2
    var sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    var columnSpacing: CGFloat = 20
    var rowSpacing: CGFloat = 20

    fileprivate var numberOfItems: Int = 0
    fileprivate var layoutAttributes = [UICollectionViewLayoutAttributes]()

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else {
            return
        }

        assert(collectionView.numberOfSections == 1)
        let numberOfItems = collectionView.numberOfItems(inSection: 0)

        let width = collectionView.bounds.size.width
        let columnWidth = (width - sectionInset.left - sectionInset.right - CGFloat(numberOfColumns - 1) * columnSpacing) / CGFloat(numberOfColumns)
        // (375 - 20 - 20 - 1 * 20) / 2 = 157.5

        var columns = [CGFloat](repeating: sectionInset.top, count: numberOfColumns)
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for item in 0 ..< numberOfItems {
            // aspect ratio = width / height
            let aspectRatio: CGFloat
            let indexPath = IndexPath(item: item, section: 0)

            if let delegate = collectionView.delegate as? WaterfallCollectionViewLayoutDelegate {
                aspectRatio = delegate.collectionView?(collectionView, layout: self, aspectRatioForItemAt: indexPath) ?? 1
            } else {
                aspectRatio = 1
            }

            var columnIndex = 0
            var columnValue = columns[0]
            for index in columns.indices {
                if columns[index] < columnValue {
                    columnIndex = index
                    columnValue = columns[index]
                }
            }

            let x = sectionInset.left + CGFloat(columnIndex) * (columnWidth + columnSpacing)
            let y = columnValue
            let height = columnWidth / aspectRatio

            let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            itemAttributes.frame = CGRect(x: x, y: y, width: columnWidth, height: height)
            layoutAttributes.append(itemAttributes)

            columns[columnIndex] += height + rowSpacing
        }

        self.layoutAttributes = layoutAttributes
    }

    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }

        let element = self.layoutAttributes.max { (attr1, attr2) -> Bool in
            return attr1.frame.maxY < attr2.frame.maxY
        }
        let height = (element?.frame.maxY ?? sectionInset.top) + sectionInset.bottom

        return CGSize(width: collectionView.bounds.size.width, height: height)
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if layoutAttributes.count > indexPath.item {
            return layoutAttributes[indexPath.item]
        } else {
            // This shoudn't happen. Famous last words.
            return nil
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.filter { (attr) -> Bool in
            return attr.frame.intersects(rect)
        }
    }
}

//
//  LayoutAttributes.swift
//  Random Dog
//
//  Created by Alexsander Akers on 1/31/18.
//  Copyright © 2018 Alexsander Akers. All rights reserved.
//

import UIKit

class SlantyCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var contentViewAngle: CGFloat = 0
    var contentViewLayerMask: UIBezierPath?

    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! SlantyCollectionViewLayoutAttributes
        copy.contentViewAngle = contentViewAngle
        copy.contentViewLayerMask = contentViewLayerMask?.copy(with: zone) as? UIBezierPath
        return copy
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? SlantyCollectionViewLayoutAttributes else {
            return false
        }

        guard object.contentViewAngle == contentViewAngle else {
            return false
        }

        guard object.contentViewLayerMask?.isEqual(contentViewLayerMask) != false else {
            return false
        }

        return super.isEqual(object)
    }
}

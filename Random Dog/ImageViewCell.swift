//
//  ImageViewCell.swift
//  Random Dog
//
//  Created by Alexsander Akers on 2/10/18.
//  Copyright © 2018 Alexsander Akers. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let layoutAttributes = layoutAttributes as? SlantyCollectionViewLayoutAttributes {
            contentView.transform = CGAffineTransform(rotationAngle: layoutAttributes.contentViewAngle)
            layer.mask = layoutAttributes.contentViewLayerMask.map { path in
                let layer = CAShapeLayer()
                layer.path = path.cgPath
                return layer
            }
        }

        super.apply(layoutAttributes)
    }
}

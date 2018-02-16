//
//  ViewController.swift
//  Random Dog
//
//  Created by Alexsander Akers on 2/10/18.
//  Copyright © 2018 Alexsander Akers. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, WaterfallCollectionViewLayoutDelegate {
    @IBOutlet var collectionView: UICollectionView!

    // MARK: - Collection View

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogCell", for: indexPath) as! ImageViewCell
        cell.imageView.image = UIImage(named: "dog\(indexPath.item + 1)")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, aspectRatioForItemAt indexPath: IndexPath) -> CGFloat {
        let image = UIImage(named: "dog\(indexPath.item + 1)")!
        if image.size.height == 0 {
            return 1
        } else {
            let aspectRatio = image.size.width / image.size.height
//            Simulate portrait images by flipping aspect ratio.
//            if indexPath.item % 3 == 0 {
//                return 1 / aspectRatio
//            } else {
                return aspectRatio
//            }
        }
    }
}

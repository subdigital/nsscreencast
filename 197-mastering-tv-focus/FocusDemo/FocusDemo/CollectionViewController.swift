//
//  CollectionViewController.swift
//  FocusDemo
//
//  Created by Ben Scheirman on 11/13/15.
//  Copyright © 2015 NSScreencast. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageCollectionViewCell
        let imageName = "Scenery \(indexPath.row + 1)"
        cell.label.text = imageName
        cell.imageView.image = UIImage(named: imageName)
        return cell
    }
}

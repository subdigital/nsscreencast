//
//  ViewController.swift
//  AdvancedCollectionView
//
//  Created by Ben Scheirman on 3/29/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    lazy var colors: [UIColor] = {
        return [
            UIColor(red:0.02, green:0.25, blue:0.49, alpha:1.00),
            UIColor(red:0.32, green:0.66, blue:0.99, alpha:1.00),
            UIColor(red:0.05, green:0.52, blue:0.98, alpha:1.00),
            UIColor(red:0.18, green:0.34, blue:0.49, alpha:1.00),
            UIColor(red:0.03, green:0.41, blue:0.79, alpha:1.00)
        ]
    }()

    var numberOfItems: Int {
        return 25;
    }
    
    static var layout: UICollectionViewLayout = {
        let flow = CustomFlowLayout()
        flow.itemSize = CGSizeMake(62, 62)
        flow.minimumInteritemSpacing = 16
        flow.minimumLineSpacing = 16
        flow.scrollDirection = .Vertical
        return flow
    }()
    
    init() {
        super.init(collectionViewLayout: ViewController.layout)
        installsStandardGestureForInteractiveMovement = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        installsStandardGestureForInteractiveMovement = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.contentInset = UIEdgeInsetsMake(44, 33, 44, 33)
        collectionView?.registerClass(IconCell.self, forCellWithReuseIdentifier: "IconCell")
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("IconCell", forIndexPath: indexPath) as! IconCell
        cell.layer.cornerRadius = 8
        cell.backgroundColor = colorForIndexPath(indexPath)
        return cell
    }

    func colorForIndexPath(indexPath: NSIndexPath) -> UIColor {
        return colors[indexPath.row % colors.count]
    }
    
    override func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
    }
}


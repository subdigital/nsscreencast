//
//  ViewController.swift
//  MagicMove
//
//  Created by Ben Scheirman on 6/2/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate {

    var lastSelectedIndexPath: NSIndexPath?
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
   
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageViewCell", forIndexPath: indexPath) as! ImageViewCell
        let w = Int(view.frame.size.width) * 2
        let url = NSURL(string: "http://lorempixel.com/\(w)/\(w)")!
        cell.imageView.fkb_setImageWithURL(url, placeholder: nil)
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = collectionView?.indexPathsForSelectedItems().first! as! NSIndexPath
        let cell = collectionView!.cellForItemAtIndexPath(indexPath) as! ImageViewCell
        let image = cell.imageView.image
        let detailVC = segue.destinationViewController as! DetailViewController
        detailVC.image = image
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        lastSelectedIndexPath = indexPath
    }
    
    func navigationController(navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
            if operation == .Push {
                let animator = Animator()
                animator.presenting = true
                return animator
            } else {
                return nil
            }
    }
    
}


//
//  CustomFlowLayout.swift
//  AdvancedCollectionView
//
//  Created by Ben Scheirman on 3/29/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class CustomFlowLayout : UICollectionViewFlowLayout {

    var longPress: UILongPressGestureRecognizer!
    var originalIndexPath: NSIndexPath?
    var draggingIndexPath: NSIndexPath?
    var draggingView: UIView?
    var dragOffset = CGPointZero

    override func prepareLayout() {
        super.prepareLayout()
        
        installGestureRecognizer()
    }
    
    func applyDraggingAttributes(attributes: UICollectionViewLayoutAttributes) {
        attributes.alpha = 0
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElementsInRect(rect)
        attributes?.forEach { a in
            if a.indexPath == draggingIndexPath {
                if a.representedElementCategory == .Cell {
                    self.applyDraggingAttributes(a)
                }
            }
        }
        return attributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItemAtIndexPath(indexPath)
        if let attributes = attributes where indexPath == draggingIndexPath {
            if attributes.representedElementCategory == .Cell {
                applyDraggingAttributes(attributes)
            }
        }
        return attributes
    }
    
    func installGestureRecognizer() {
        if longPress == nil {
            longPress = UILongPressGestureRecognizer(target: self, action: #selector(CustomFlowLayout.handleLongPress(_:)))
            longPress.minimumPressDuration = 0.2
            collectionView?.addGestureRecognizer(longPress)
        }
    }
    
    func handleLongPress(longPress: UILongPressGestureRecognizer) {
        let location = longPress.locationInView(collectionView!)
        switch longPress.state {
        case .Began: startDragAtLocation(location)
        case .Changed: updateDragAtLocation(location)
        case .Ended: endDragAtLocation(location)
        default:
            break
        }
    }
    
    func startDragAtLocation(location: CGPoint) {
        guard let cv = collectionView else { return }
        guard let indexPath = cv.indexPathForItemAtPoint(location) else { return }
        guard cv.dataSource?.collectionView?(cv, canMoveItemAtIndexPath: indexPath) == true else { return }
        guard let cell = cv.cellForItemAtIndexPath(indexPath) else { return }
        
        originalIndexPath = indexPath
    draggingIndexPath = indexPath
        draggingView = cell.snapshotViewAfterScreenUpdates(true)
        draggingView!.frame = cell.frame
        cv.addSubview(draggingView!)
        
        dragOffset = CGPointMake(draggingView!.center.x - location.x, draggingView!.center.y - location.y)
        
        draggingView?.layer.shadowPath = UIBezierPath(rect: draggingView!.bounds).CGPath
        draggingView?.layer.shadowColor = UIColor.blackColor().CGColor
        draggingView?.layer.shadowOpacity = 0.8
        draggingView?.layer.shadowRadius = 10
        
        invalidateLayout()
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
            self.draggingView?.alpha = 0.95
            self.draggingView?.transform = CGAffineTransformMakeScale(1.2, 1.2)
        }, completion: nil)
    }
    
    func updateDragAtLocation(location: CGPoint) {
        guard let view = draggingView else { return }
        guard let cv = collectionView else { return }

        view.center = CGPointMake(location.x + dragOffset.x, location.y + dragOffset.y)
        
        if let newIndexPath = cv.indexPathForItemAtPoint(location) {
            cv.moveItemAtIndexPath(draggingIndexPath!, toIndexPath: newIndexPath)
            draggingIndexPath = newIndexPath
        }
    }
    
    func endDragAtLocation(location: CGPoint) {
        guard let dragView = draggingView else { return }
        guard let indexPath = draggingIndexPath else { return }
        guard let cv = collectionView else { return }
        guard let datasource = cv.dataSource else { return }
        
        let targetCenter = datasource.collectionView(cv, cellForItemAtIndexPath: indexPath).center
        
        let shadowFade = CABasicAnimation(keyPath: "shadowOpacity")
        shadowFade.fromValue = 0.8
        shadowFade.toValue = 0
        shadowFade.duration = 0.4
        dragView.layer.addAnimation(shadowFade, forKey: "shadowFade")
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: { 
            dragView.center = targetCenter
            dragView.transform = CGAffineTransformIdentity
            
        }) { (completed) in
            
            if !indexPath.isEqual(self.originalIndexPath!) {
                datasource.collectionView?(cv, moveItemAtIndexPath: self.originalIndexPath!, toIndexPath: indexPath)
            }
            
            dragView.removeFromSuperview()
            self.draggingIndexPath = nil
            self.draggingView = nil
            self.invalidateLayout()
        }
        
        
    }
}

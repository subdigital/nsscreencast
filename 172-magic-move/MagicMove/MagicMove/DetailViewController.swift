//
//  DetailViewController.swift
//  MagicMove
//
//  Created by Ben Scheirman on 6/2/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController, UINavigationControllerDelegate {
    
    var image: UIImage?
    
    @IBOutlet var imageView: FKBRemoteImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func pop(recognizer: UIScreenEdgePanGestureRecognizer) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        edgesForExtendedLayout = UIRectEdge.None
        
        navigationController?.delegate = self
        
        if let image = image {
            imageView.image = image
        }
    }
    
    func navigationController(navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            if operation == .Pop {
                let animator = Animator()
                animator.presenting = false
                return animator
            } else {
                return nil
            }
    }
}

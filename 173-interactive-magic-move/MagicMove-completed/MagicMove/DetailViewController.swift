//
//  DetailViewController.swift
//  MagicMove
//
//  Created by Ben Scheirman on 6/2/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController, UINavigationControllerDelegate, PanInteractionControllerDelegate {
    
    var image: UIImage?
    var interactionController: PanInteractionController!
    
    @IBOutlet var imageView: FKBRemoteImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactionController = PanInteractionController()
        interactionController.attachToView(view)
        interactionController.delegate = self
    }
    
    func interactiveAnimationDidStart(controller: PanInteractionController) {
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
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}

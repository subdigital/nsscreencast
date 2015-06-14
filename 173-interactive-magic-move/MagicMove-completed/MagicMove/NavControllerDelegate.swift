//
//  NavControllerDelegate.swift
//  MagicMove
//
//  Created by Ben Scheirman on 6/2/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit

class NavController : NSObject, UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .Push {
            return Animator()
        } else {
            return nil
        }
    }
    
}

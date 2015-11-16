//
//  ViewController.swift
//  FocusDemo
//
//  Created by Ben Scheirman on 11/11/15.
//  Copyright © 2015 NSScreencast. All rights reserved.
//

import UIKit

class FocusViewController: UIViewController {

    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var focusGuide: UIFocusGuide!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        focusGuide = UIFocusGuide()
        view.addLayoutGuide(focusGuide)
        
        focusGuide.widthAnchor.constraintEqualToAnchor(buttonA.widthAnchor).active = true
        focusGuide.heightAnchor.constraintEqualToAnchor(buttonC.heightAnchor).active = true
        focusGuide.centerXAnchor.constraintEqualToAnchor(buttonA.centerXAnchor).active = true
        focusGuide.centerYAnchor.constraintEqualToAnchor(buttonC.centerYAnchor).active = true
    }
    
    @IBAction func resetFocus() {
        setNeedsFocusUpdate()
        updateFocusIfNeeded()
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        guard let nextFocusedView = context.nextFocusedView else { return }
        
        switch nextFocusedView {
        case buttonA: focusGuide.preferredFocusedView = buttonC
        case buttonC: focusGuide.preferredFocusedView = buttonA
        default: break
        }
    }
}


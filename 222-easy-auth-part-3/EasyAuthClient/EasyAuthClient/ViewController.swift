//
//  ViewController.swift
//  EasyAuthClient
//
//  Created by Ben Scheirman on 5/22/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var label: UILabel!
    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName("LoggedIn", object: nil, queue: NSOperationQueue.mainQueue()) { (notification) in
            self.label.text = "You are now logged in!"
            self.button.hidden = true
        }
    }
}


//
//  ViewController.swift
//  CoffeeTracker
//
//  Created by Ben Scheirman on 9/28/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var coffeeTracker: CoffeeTracker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        coffeeTracker.updateDisplay()
    }
    
  
}


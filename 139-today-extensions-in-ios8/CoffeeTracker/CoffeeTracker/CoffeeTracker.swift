//
//  CoffeeTracker.swift
//  CoffeeTracker
//
//  Created by Ben Scheirman on 9/29/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

import UIKit

@objc class CoffeeTracker : NSObject  {
    @IBOutlet weak var numberLabel: UILabel!
    
    var numberOfCups: Int = 0 {
        didSet {
            updateDisplay()
        }
    }
    
    func updateDisplay() {
        numberLabel.text = String(numberOfCups)
    }
    
    @IBAction func stepperChanged(stepper: UIStepper) {
        numberOfCups = Int(stepper.value)
    }

}

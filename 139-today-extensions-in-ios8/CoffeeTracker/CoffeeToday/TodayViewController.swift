//
//  TodayViewController.swift
//  CoffeeToday
//
//  Created by Ben Scheirman on 9/29/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet var coffeeTracker: CoffeeTracker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coffeeTracker.updateDisplay()
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}

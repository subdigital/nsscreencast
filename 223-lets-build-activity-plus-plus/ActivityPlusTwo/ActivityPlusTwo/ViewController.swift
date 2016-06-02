//
//  ViewController.swift
//  ActivityPlusTwo
//
//  Created by NSScreencast on 5/31/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ringView: SummaryRingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
        ringView.setAmount(CGFloat(sender.value), forRingIdentifier: "activity")
    }
}


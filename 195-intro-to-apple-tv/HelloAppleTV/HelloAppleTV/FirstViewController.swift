//
//  FirstViewController.swift
//  HelloAppleTV
//
//  Created by Ben Scheirman on 11/1/15.
//  Copyright © 2015 NSScreencast. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func launchRockets(sender: AnyObject) {
        let rocketImage = UIImage(named: "missile")!
        
        let count = 10
        let size = rocketImage.size
        for i in 0..<count {
            let rv = UIImageView(image: rocketImage)
            let x = Double(-size.width) - Double(i) * 10
            let y = 100.0 + Double(i) * 80.0
            let origin = CGPoint(x: x, y: y)
            var frame = CGRect(origin: origin, size: size)
            rv.frame = frame
            view.addSubview(rv)
            
            UIView.animateWithDuration(1.8, delay: Double(i) / 15, options: .CurveEaseIn, animations: {
                frame.origin.x = self.view.frame.size.width + 10
                rv.frame = frame
                }, completion: { completed in
                    rv.removeFromSuperview()
            })
        }
    }
    
    @IBAction func drainExhaustValve(sender: AnyObject) {
        let alert = UIAlertController(title: "Status", message: "Exhaust valve malfunctioning", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        alert.addAction(UIAlertAction(title: "System Override", style: .Destructive, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        let title = sender.titleForSegmentAtIndex(index)!
        
        switch title {
        case "Warp":
            view.backgroundColor = UIColor.orangeColor()
        case "Ludicrous":
            view.backgroundColor = UIColor(patternImage: UIImage(named: "plaid")!)
        default:
            view.backgroundColor = UIColor.clearColor()
        }
    }
}


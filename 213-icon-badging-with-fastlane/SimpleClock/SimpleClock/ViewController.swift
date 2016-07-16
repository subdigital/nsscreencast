//
//  ViewController.swift
//  SimpleClock
//
//  Created by Ben Scheirman on 3/7/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    var timer: NSTimer!
    var dateFormatter = NSDateFormatter()
    var bgColor: BackgroundColor = .Lavender
    
    enum BackgroundColor {
        case Red
        case Lavender
        
        var color: UIColor {
            switch self {
            case .Red: return UIColor(red:0.84, green:0.06, blue:0.04, alpha:1)
            case .Lavender: return UIColor(red:0.77, green:0.51, blue:0.99, alpha:1)
            }
        }
        
        var nextColor: BackgroundColor {
            switch self {
            case .Red: return .Lavender
            case .Lavender: return .Red
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "hh:mm:ss a"
        updateTime()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
        view.backgroundColor = bgColor.color
        label.textColor = UIColor.whiteColor()
        label.userInteractionEnabled = true
    }
    
    func updateTime() {
        let date = NSDate()
        label.text = dateFormatter.stringFromDate(date)
    }

    @IBAction func timeTapped(sender: AnyObject) {
        if dateFormatter.dateFormat.hasPrefix("HH") {
            dateFormatter.dateFormat = "hh:mm:ss a"
        } else {
            dateFormatter.dateFormat = "HH:mm:ss"
        }
        updateTime()
    }
    
    @IBAction func backgroundTapped(sender: AnyObject) {
        bgColor = bgColor.nextColor
        view.backgroundColor = bgColor.color
    }
    
}


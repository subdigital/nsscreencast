//
//  TimedButton.swift
//  LocalNotifications
//
//  Created by Ben Scheirman on 6/15/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit

@objc protocol TimedButtonDelegate {
    func timedButtonDidBecomeReady(timedButton: TimedButton)
}

@IBDesignable
class TimedButton : UIButton {

    @IBInspectable
    var timeoutInSeconds: Int = 10
    
    @IBOutlet
    var delegate: TimedButtonDelegate?
    
    var timeLeft: Int?
    
    var originalText: String!
    var timer: NSTimer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        originalText = titleForState(.Normal)
        addTarget(self, action: Selector("onTap:"), forControlEvents: .TouchUpInside)
    }
    
    func triggerWait() {
        enabled = false
        
        timeLeft = timeoutInSeconds
        tick()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("tick"), userInfo: nil, repeats: true)
    }
    
    func onTap(sender: UIButton) {
        triggerWait()
    }
    
    func tick() {
        if !enabled && timeLeft != nil {
            timeLeft!--
            let title: String
            if timeLeft <= 0 {
                title = originalText
                timer?.invalidate()
                timer = nil
                enabled = true
                delegate?.timedButtonDidBecomeReady(self)
            } else {
                title = "\(originalText) (\(timeLeft!))"
            }
            
            UIView.performWithoutAnimation { [weak self] in
                self?.setTitle(title, forState: .Normal)
                self?.layoutIfNeeded()
            }
        }
    }
}

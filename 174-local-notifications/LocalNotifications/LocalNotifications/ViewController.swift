//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Ben Scheirman on 6/15/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TimedButtonDelegate {

    @IBOutlet var goldLabel: UILabel!
    @IBOutlet var woodLabel: UILabel!
    @IBOutlet var mineGoldButton: TimedButton!
    @IBOutlet var chopWoodButton: TimedButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onMineNotification:"),
            name: "MineNotification",
            object: nil)
    }
    
    var gold: Int = 0 {
        didSet {
            goldLabel.text = "Gold: \(gold)"
        }
    }
    
    var wood: Int = 0 {
        didSet {
            woodLabel.text = "Wood: \(wood)"
        }
    }
    
    func onMineNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo, let resource = userInfo["resource"] as? String {
            switch resource {
            case "wood" :
                chopWood()
                chopWoodButton.triggerWait()
                
            case "gold" :
                mineGold()
                mineGoldButton.triggerWait()
                
            default:
                fatalError("Uknown resource \(resource)")
            }
        }
    }
    
    @IBAction func mineGoldTapped(sender: TimedButton) {
        mineGold()
    }
    
    @IBAction func chopWoodTapped(sender: TimedButton) {
        chopWood()
    }
    
    func mineGold() {
        mineResource("gold", message: "Gold is ready to be mined!", timeout: mineGoldButton.timeoutInSeconds)
    }
    
    func chopWood() {
        mineResource("wood", message: "Wood is ready to be chopped!", timeout: chopWoodButton.timeoutInSeconds)
    }
    
    func mineResource(resource: String, message: String, timeout: Int) {
        let reminder = UILocalNotification()
        reminder.alertBody = message
        reminder.fireDate = NSDate(timeIntervalSinceNow: NSTimeInterval(timeout))
        reminder.category = Notifications.Categories.JobCompleted.rawValue
        reminder.userInfo = [ "resource" : resource ]
        UIApplication.sharedApplication().scheduleLocalNotification(reminder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mineGoldButton.delegate = self
        chopWoodButton.delegate = self
    }

    func timedButtonDidBecomeReady(sender: TimedButton) {
        switch sender {
            
        case mineGoldButton:
            gold += 25
        
        case chopWoodButton:
            wood += 10
         
        default:
            break
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}


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
    @IBOutlet weak var activityRingView: ActivityRingView!
    @IBOutlet weak var exerciseRingView: ExerciseRingView!
    @IBOutlet weak var standRingView: StandingRingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
        ringView.setAmount(CGFloat(sender.value), forRingIdentifier: "activity")
    }
    
    @IBAction func randomizeTapped(sender: AnyObject) {
        let caloriesBurned = Int(arc4random() % 800)
        let calorieGoal = 500
        
        let exerciseMin = Int(arc4random() % 45)
        let exerciseGoal = 30
        
        let standHours = Int(arc4random() % 16)
        let standGoal = 12
        
        let log = ActivityLog(date: NSDate(),
                              caloriesBurned: caloriesBurned,
                              activityGoal: calorieGoal,
                              minutesOfExercise: exerciseMin,
                              exerciseGoal: exerciseGoal,
                              standHours: standHours,
                              standGoal: standGoal)
        
        
        for ring in [ringView, activityRingView, exerciseRingView, standRingView] {
            ring.configureForLog(log)
        }
    }
}


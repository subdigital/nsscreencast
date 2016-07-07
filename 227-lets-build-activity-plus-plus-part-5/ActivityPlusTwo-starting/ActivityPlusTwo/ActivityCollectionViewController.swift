//
//  ActivityCollectionViewController.swift
//  ActivityPlusTwo
//
//  Created by Ben Scheirman on 6/21/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ActivityCell"

class ActivityCollectionViewController: UICollectionViewController {

    var today: NSDate?
    let calendar = NSCalendar.currentCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        today = NSDate()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 365
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ActivityCell
    
        let date = calendar.dateByAddingUnit(.Day, value: -indexPath.row, toDate: today!, options: [])!
        let caloriesBurned = Int(arc4random() % 800)
        let calorieGoal = 500
        
        let exerciseMin = Int(arc4random() % 45)
        let exerciseGoal = 30
        
        let standHours = Int(arc4random() % 16)
        let standGoal = 12
        
        let log = ActivityLog(date: date,
                              caloriesBurned: caloriesBurned,
                              activityGoal: calorieGoal,
                              minutesOfExercise: exerciseMin,
                              exerciseGoal: exerciseGoal,
                              standHours: standHours,
                              standGoal: standGoal)
        
        cell.configureForLog(log)
    
        return cell
    }
}

//
//  ActivityCollectionViewController.swift
//  ActivityPlusTwo
//
//  Created by Ben Scheirman on 6/21/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit
import HealthKit

private let reuseIdentifier = "ActivityCell"

class ActivityCollectionViewController: UICollectionViewController, RequiresHealth {

    var healthStore: HKHealthStore?
    var dataSource: ActivityDataSource?
    
    var today: NSDate?
    let calendar = NSCalendar.currentCalendar()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
        NSLayoutConstraint.activateConstraints([
            indicator.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor),
            indicator.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor)
            ])
        return indicator
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkHealthAccess { (isAuthorized, error) in
            if let error = error {
                print("ERROR: \(error)")
            } else if isAuthorized {
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadHealthSamples()
                    NSNotificationCenter.defaultCenter().addObserver(self,
                        selector: #selector(ActivityCollectionViewController.loadHealthSamples),
                        name: UIApplicationDidBecomeActiveNotification,
                        object: nil)
                }
            } else {
                print("Not authorized")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        today = NSDate()
    }
    
    func checkHealthAccess(completion: (Bool, NSError?) -> Void) {
        guard let healthStore = self.healthStore else {
            completion(false, nil)
            return
        }
        
        let status = healthStore.authorizationStatusForType(HKObjectType.activitySummaryType())
        switch status {
        case .SharingAuthorized: completion(true, nil)
        case .NotDetermined: fallthrough
        case .SharingDenied:
            healthStore.requestAuthorizationToShareTypes(nil, readTypes: [HKObjectType.activitySummaryType()],
                                                         completion: completion)
    
        }
    }
    
    func loadHealthSamples() {
        activityIndicator.startAnimating()
        
        let calendar = NSCalendar.currentCalendar()
        let today = NSDate()
        
        let startDate = calendar.dateByAddingUnit(.Year, value: -1, toDate: today, options: [])!
        let unitFlags: NSCalendarUnit = [.Year, .Month, .Day]
        let startDateComponents = calendar.components(unitFlags, fromDate: startDate)
        startDateComponents.calendar = calendar
        
        let endDateComponents = calendar.components(unitFlags, fromDate: today)
        endDateComponents.calendar = calendar
        
        let summariesPastYear = HKQuery.predicateForActivitySummariesBetweenStartDateComponents(
            startDateComponents,
            endDateComponents: endDateComponents
        )
        
        let query = HKActivitySummaryQuery(predicate: summariesPastYear) { (query, summaries, error) in
            
            dispatch_async(dispatch_get_main_queue()) {
                self.activityIndicator.stopAnimating()
            }
            
            if let error = error {
                print("error fetching summaries: \(error)")
            } else {
                if let summaries = summaries {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.dataSource = ActivityDataSource(calendar: calendar, summaries: summaries)
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
        
        healthStore?.executeQuery(query)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.activities.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ActivityCell
    
        if let log = dataSource?.activities[indexPath.row] {
            cell.configureForLog(log)
        }
    
        return cell
    }
}

//
//  DetailViewController.swift
//  CompanyRoster
//
//  Created by Ben Scheirman on 10/12/15.
//  Copyright © 2015 NSScreencast. All rights reserved.
//

import UIKit
import CoreSpotlight

class DetailViewController: UIViewController, NSUserActivityDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var contact: Contact? {
        didSet {
            self.configureView()
        }
    }

    func configureView() {
        if let contact = self.contact {
            if let label = self.detailDescriptionLabel {
                label.text = contact.name
                imageView.image = UIImage(named: contact.imageName)
                
                userActivity = NSUserActivity(activityType: "com.companyroster.viewcontact")
                userActivity?.requiredUserInfoKeys = ["contactName", "contactDepartment"]
                userActivity?.title = contact.name
                userActivity?.delegate = self
                userActivity?.contentAttributeSet = contact.searchableAttributeSet()
                userActivity?.eligibleForHandoff = false
                userActivity?.eligibleForSearch = true
                userActivity?.eligibleForPublicIndexing = false

                userActivity?.becomeCurrent()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func userActivityWillSave(userActivity: NSUserActivity) {
        userActivity.addUserInfoEntriesFromDictionary([
            "contactName": contact!.name,
            "contactDepartment": contact!.department
        ])
    }
}

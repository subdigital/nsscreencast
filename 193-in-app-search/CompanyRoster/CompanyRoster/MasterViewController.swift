//
//  MasterViewController.swift
//  CompanyRoster
//
//  Created by Ben Scheirman on 10/12/15.
//  Copyright © 2015 NSScreencast. All rights reserved.
//

import UIKit
import CoreSpotlight

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var contacts = ContactsStore().getContacts()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func restoreUserActivityState(activity: NSUserActivity) {
        if activity.activityType == "com.companyroster.viewcontact" {
            if let name = activity.userInfo?["contactName"] as? String {
                restoreContactWithName(name)
            } else {
                print("Couldn't find the name in user info: \(activity.userInfo)")
            }
        } else if activity.activityType == CSSearchableItemActionType {
            if let identifier = activity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
                restoreContactWithName(identifier)
            }
        } else {
            super.restoreUserActivityState(activity)
        }
    }
    
    func restoreContactWithName(name: String) {
        if let index = contacts.indexOf({ c in c.name == name }) {
            tableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: false, scrollPosition: .Middle)
            performSegueWithIdentifier("showDetail", sender: self)
        }
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let contact = contacts[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.contact = contact
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let contact = contacts[indexPath.row]
        cell.imageView?.image = UIImage(named: contact.imageName)
        cell.textLabel!.text = contact.name
        cell.detailTextLabel!.text = contact.department
        return cell
    }
}


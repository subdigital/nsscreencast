//
//  SelectUnitViewController.swift
//  StarcraftGuide
//
//  Created by Ben Scheirman on 1/18/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class SelectUnitViewController : UITableViewController {
    var units: [Unit] = []
    var unitSelectionBlock: (Unit->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select a unit"
        tableView.backgroundColor = UIColor.blackColor()
        tableView.separatorColor = UIColor(white: 0.1, alpha: 1)
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.registerClass(UnitCell.self, forCellReuseIdentifier: UnitCell.reuseIdentifier)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return units.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let unit = units[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(UnitCell.reuseIdentifier) as! UnitCell
        cell.textLabel?.text = unit.name
        if let imgName = unit.imageName, image = UIImage(named: imgName) {
            cell.imageView?.image = image
        } else {
            cell.imageView?.image = nil
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let unit = units[indexPath.row]
        unitSelectionBlock?(unit)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // remove separator inset
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }

}

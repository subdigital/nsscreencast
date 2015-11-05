//
//  SecondViewController.swift
//  HelloAppleTV
//
//  Created by Ben Scheirman on 11/1/15.
//  Copyright © 2015 NSScreencast. All rights reserved.
//

import UIKit

class SecondViewController: UITableViewController {

    let crew = [
        "Dark Helmet",
        "Colonel Sandurz",
        "Commanderette Zircon",
        "Radio Operator",
        "Radar Technician"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 200, left: 200, bottom: 200, right: 200)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return crew.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = crew[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, canFocusRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.row % 2 == 0
    }
}

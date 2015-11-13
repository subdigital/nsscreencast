//
//  TableViewController.swift
//  FocusDemo
//
//  Created by Ben Scheirman on 11/13/15.
//  Copyright © 2015 NSScreencast. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var customRows = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.clipsToBounds = false
        tableView.remembersLastFocusedIndexPath = true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if customRows {
            let identifier = "cell\(indexPath.row % 4 + 1)"
            cell = tableView.dequeueReusableCellWithIdentifier(identifier)!
        } else {
            cell = UITableViewCell()
        }
        
        cell.textLabel?.text = "Row \(indexPath.row)"
        return cell
    }

    @IBAction func toggleCustomRows(sender: AnyObject) {
        customRows = !customRows
        tableView.reloadData()
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        guard customRows else { return }
        
        if let prevCell = context.previouslyFocusedView as? UITableViewCell {
            coordinator.addCoordinatedAnimations({
                prevCell.transform = CGAffineTransformIdentity
            }, completion:nil)
        }
        
        if let nextCell = context.nextFocusedView as? UITableViewCell {
           nextCell.clipsToBounds = false
            coordinator.addCoordinatedAnimations({
                nextCell.transform = CGAffineTransformRotate( CGAffineTransformMakeScale(1.2, 1.2), CGFloat(M_PI / 60.0))
            }, completion: {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: { () -> Void in
                    nextCell.transform = CGAffineTransformMakeScale(1.1, 1.1)
                }, completion: nil)
            })
        }
    }
}

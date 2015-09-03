//
//  ViewController.swift
//  Lister
//
//  Created by Ben Scheirman on 8/25/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var lists: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
        
    }
    
    // MARK - UITableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell") as! ListCell
        var title = "This is a cell for row \(indexPath.row). There are many cells like it, but this one is mine."
        if indexPath.row % 3 == 0 {
           title += " (This is row is divisible by 3)"
        }
        cell.titleLabel?.text = title
        return cell
    }
    
    // MARK - DZNEmptyDataSet
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty-book")
    }
    
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return UIColor(red:0.91, green:0.92, blue:0.94, alpha:1)
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "You have no Lists!"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(18),
            NSForegroundColorAttributeName: UIColor.darkGrayColor()
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Add your first list to track the things you need to remember, things to follow-up on, movies to watch, or books to read."
        
        var para = NSMutableParagraphStyle()
        para.lineBreakMode = NSLineBreakMode.ByWordWrapping
        para.alignment = NSTextAlignment.Center
        
        let attribs = [
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSParagraphStyleAttributeName: para
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let text = "Create a List"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(16),
            NSForegroundColorAttributeName: view.tintColor
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        lists = [
            "1", "2", "3", "4", "5", "6", "7", "8"
        ]
        tableView.reloadData()
    }
}


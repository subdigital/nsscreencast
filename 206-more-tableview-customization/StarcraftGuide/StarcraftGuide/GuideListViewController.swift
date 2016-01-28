//
//  MasterViewController.swift
//  StarcraftGuide
//
//  Created by Ben Scheirman on 1/17/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class GuideListViewController: UITableViewController {
    
    let guides = [
        Guide(name: "Cannon Rush", race: .Protoss),
        Guide(name: "4-gate pressure", race: .Protoss),
        Guide(name: "Mass Void Ray", race: .Protoss),
        Guide(name: "Zergling Frenzy", race: .Zerg),
        Guide(name: "Roach/Hydra", race: .Zerg),
        Guide(name: "Marine/Medvac", race: .Terran),
        Guide(name: "Turtle Power!", race: .Terran)
    ]

    let races = [Race.Protoss, Race.Terran, Race.Zerg]
    
    lazy var guidesByRace: [ Race : [Guide] ] = {
        return groupBy(self.guides) { $0.race! }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = Theme.Colors.DarkBackgroundColor.color
        tableView.backgroundColor = Theme.Colors.BackgroundColor.color
        tableView.tableFooterView = UIView()
        
        tableView.registerClass(RaceHeaderView.self, forHeaderFooterViewReuseIdentifier: RaceHeaderView.reuseIdentifier)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        performSegueWithIdentifier("newGuideSegue", sender: nil)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return races[section].rawValue
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(RaceHeaderView.reuseIdentifier) as! RaceHeaderView
        let race = self.tableView(tableView, titleForHeaderInSection: section)!
        header.label.text = race
        header.imageView.image = UIImage(named: race.lowercaseString)!
        return header
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return races.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let race = races[section]
        return guidesByRace[race]?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(GuideCell.reuseIdentifier) as! GuideCell
        let race = races[indexPath.section]
        let guide = guidesByRace[race]![indexPath.row]
        cell.nameLabel.text = guide.name
        return cell
    }    
}


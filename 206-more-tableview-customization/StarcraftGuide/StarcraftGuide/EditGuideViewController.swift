//
//  EditGuideViewController.swift
//  StarcraftGuide
//
//  Created by Ben Scheirman on 1/18/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class EditGuideViewController : UITableViewController, UITextFieldDelegate {
    var guide = Guide()
    var units: [Race: [Unit]]!
    
    enum Sections : Int {
        case Details = 0
        case BuildOrder
        case Actions
        case Count
        
        var title: String? {
            switch self {
            case .Details: return "Guide Details"
            case .BuildOrder: return "Build Order"
            default: return nil
            }
        }
    }
    
    override func viewDidLoad() {

        guide.name = "Test Guide"
        guide.race = Race.Protoss
        super.viewDidLoad()
        title = "New Guide"
        units = UnitStore.units
        tableView.backgroundColor = Theme.Colors.BackgroundColor.color
        tableView.separatorColor = Theme.Colors.BackgroundColor.color
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.tableFooterView = UIView()
        tableView.editing = true
        tableView.allowsSelectionDuringEditing = true

        tableView.registerClass(UnitCell.self, forCellReuseIdentifier: UnitCell.reuseIdentifier)
        tableView.registerClass(SectionHeader.self, forHeaderFooterViewReuseIdentifier: SectionHeader.reuseIdentifier)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Sections.Count.rawValue
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let s = Sections(rawValue: section) else { return 0 }
        
        switch s {
        case .Details: return 2
        case .BuildOrder: return guide.buildOrder.count
        case .Actions: return 1
        default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section == Sections.BuildOrder.rawValue
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section == Sections.BuildOrder.rawValue
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let unit = guide.buildOrder.removeAtIndex(sourceIndexPath.row)
        guide.buildOrder.insert(unit, atIndex: destinationIndexPath.row)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Sections(rawValue: section)?.title
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section < 2 else { return nil }
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(SectionHeader.reuseIdentifier) as! SectionHeader
        header.label.text = self.tableView(tableView, titleForHeaderInSection: section)
        return header
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section < 2 else { return 0 }
        return 24
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (Sections.Details.rawValue, 0):
            let cell = TextFieldCell()
            cell.backgroundColor = Theme.Colors.Foreground.color
            cell.label.textColor = Theme.Colors.LightTextColor.color
            cell.label.text = "Name"
            cell.textField.delegate = self
            cell.textField.textColor = Theme.Colors.LightTextColor.color
            cell.textField.text = guide.name
            return cell
            
        case (Sections.Details.rawValue, 1):
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.backgroundColor = Theme.Colors.Foreground.color
            cell.textLabel?.text = "Race"
            cell.textLabel?.textColor = Theme.Colors.LightTextColor.color
            cell.textLabel?.font = UIFont.boldSystemFontOfSize(16)
            cell.detailTextLabel?.text = guide.race?.rawValue
            cell.detailTextLabel?.textColor = Theme.Colors.LightTextColor.color
            cell.accessoryType = .DisclosureIndicator
            return cell
            
        case (Sections.BuildOrder.rawValue, let i):
            let unit = guide.buildOrder[i]
            let cell = tableView.dequeueReusableCellWithIdentifier(UnitCell.reuseIdentifier, forIndexPath: indexPath) as! UnitCell
            cell.selectionStyle = .None
            if let imgName = unit.imageName, image = UIImage(named: imgName) {
                cell.imageView?.image = image
            } else {
                cell.imageView?.image = nil
            }
            cell.textLabel?.text = unit.name
            return cell
            
        case (Sections.Actions.rawValue, _):
            let cell = UITableViewCell()
            cell.textLabel?.text = "+ Add a step"
            cell.backgroundColor = Theme.Colors.Foreground.color
            cell.textLabel?.textColor = Theme.Colors.LightTextColor.color
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView,
        targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath,
        toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
            
            if proposedDestinationIndexPath.section != sourceIndexPath.section {
                
                if proposedDestinationIndexPath.section < sourceIndexPath.section {
                    return NSIndexPath(forRow: 0, inSection: sourceIndexPath.section)
                } else {
                    let lastRow = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
                    return NSIndexPath(forRow: lastRow, inSection: sourceIndexPath.section)
                }
            }
            
            return proposedDestinationIndexPath
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (Sections.Details.rawValue, 1):
            let raceVC = storyboard!.instantiateViewControllerWithIdentifier("SelectRaceViewController") as! SelectRaceViewController
            raceVC.raceSelectionBlock = { race in
                self.guide.race = race
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                self.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(raceVC, animated: true)
        case (Sections.Actions.rawValue, _):
            selectUnit()
            break
            
        default: break
        }
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }

    func selectUnit() {
        if let race = guide.race {
            let unitVC = storyboard!.instantiateViewControllerWithIdentifier("SelectUnitViewController") as! SelectUnitViewController
            unitVC.units = units[race]!
            unitVC.unitSelectionBlock = { unit in
                self.guide.buildOrder.append(unit)
                let rowIndex = self.guide.buildOrder.count - 1
                let indexPath = NSIndexPath(forRow: rowIndex, inSection: 1)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(unitVC, animated: true)
        } else {
            let alert = UIAlertController(title: "Race not selected", message: "Please select a race first", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidEndEditing(textField: UITextField) {
        guide.name = textField.text
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
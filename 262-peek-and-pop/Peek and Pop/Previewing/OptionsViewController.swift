//
//  OptionsViewController.swift
//  Previewing
//
//  Created by Conrad Stoll on 2/27/17.
//  Copyright © 2017 Conrad Stoll. All rights reserved.
//

import Foundation
import UIKit

protocol OptionsViewControllerDelegate {
    func optionsDid(uncheck item: Item)
    func optionsDid(check item: Item)
    func optionsDid(moveDown item: Item)
    func optionsDid(moveUp item: Item)
    func optionsDid(delete item: Item)
}

class OptionCell : ItemCell {

}

// Note: If you're previewing segue starts with a navigation controller, the system will ask that
// view controller for its preview action items. So, you may need a custom UINavigationController
// can ask its top view controller for its preview action items, depending on your view configuration
class OptionsNavigationController : UINavigationController {
//    override var previewActionItems: [UIPreviewActionItem] {
//        get {
//            return self.topViewController?.previewActionItems ?? [UIPreviewActionItem]()
//        }
//    }
}

class OptionsViewController : UITableViewController {
    @IBOutlet weak var label : UILabel!
    @IBOutlet weak var containerView : UIView!
    
    var item : Item?
    var delegate : OptionsViewControllerDelegate?

    // Haptic Feedback
    var feedbackGenerator : UISelectionFeedbackGenerator?
    
    // Touch Handling State
    var selectedAction : UIPreviewAction?
    var firstLocation : CGPoint?
    var firstIndex : Int?
    var requiresMovement : Bool = false
    var previewingEnded : Bool = false
    
    // UIKit Property to Override
    override var previewActionItems: [UIPreviewActionItem] {
        get {
            // Part 1
            return [UIPreviewActionItem]()
            
            // Part 2a
            //return self.actions
            
            // Part 2b
            //return [UIPreviewActionItem]()
        }
    }
    
    // MARK: View Lifecycle Methods
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        commitAction()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let labelHeight = label.frame.size.height
        let containerHeight = labelHeight + 40.0
        self.containerView.frame = CGRect(x: containerView.frame.origin.x, y: containerView.frame.origin.y, width: containerView.frame.size.width, height: containerHeight)
        
        // Part 1
        self.preferredContentSize = CGSize(width: self.view.frame.size.height, height: containerHeight)
        
        // Part 2
        self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: 120 + (5 * 60))
        
        // Hack to avoid issues with frame math in updating the selections
        firstLocation = nil
    }
    
    // MARK: UI Update Methods
    
    public func updateUI(for preview: UIPreviewInteraction) {
        updateButtonSelectionState(for: preview)
    }
    
    public func finishedPreviewing() {
        previewingEnded = true
    }
    
    public func updateUI(with gesture: UIGestureRecognizer) {
        if previewingEnded {
            updateButtonSelectionState(for: gesture)
        }
    }
    
    public func updateToCommittedUI() {
        selectedAction = nil
        
        for i in 0...actions.count - 1 {
            let indexPath = IndexPath(row: i, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! OptionCell
            cell.setHighlighted(false, animated: true)
        }
    }
    
    // MARK: Action Methods

    func commitAction() {
        if let action = selectedAction {
            action.handler(action, self)
            selectedAction = nil
        }
    }
}





// MARK: Touch Location and Selection Update Methods

protocol TouchLocatable {
    func touchLocation(in view : UIView) -> CGPoint
}

extension UIGestureRecognizer : TouchLocatable {
    func touchLocation(in view: UIView) -> CGPoint {
        return self.location(in: view)
    }
}

extension UIPreviewInteraction : TouchLocatable {
    func touchLocation(in view: UIView) -> CGPoint {
        return self.location(in: view)
    }
}

extension OptionsViewController {
    fileprivate func updateButtonSelectionState(for event: TouchLocatable) {
        var actionSelected = false
        let firstIteration = (firstLocation == nil)
        
        if firstIteration {
            configureMovementRequiredStateForInitialTouchLocation(for: event)
        } else {
            if requiresMovement {
                removeMovementRequirementIfMovedFarEnoughFromFirstLocation(for: event)
            }
            
            actionSelected = setSelectedActionByTouchLocation(for: event)
        }
        
        if actionSelected == false {
            selectedAction = nil
        }
    }
    
    fileprivate func setSelectedActionByTouchLocation(for event: TouchLocatable) -> Bool {
        var actionSelected = false

        for cell in tableView.visibleCells {
            let indexPath = tableView.indexPath(for: cell)!
            let location = event.touchLocation(in: cell)
            
            let inside = (location.y > 0 && location.y < cell.frame.size.height)

            if requiresMovement == false {
                cell.setHighlighted(inside, animated: false)
                
                if inside {
                    playSelectionChangedHaptic(for: indexPath)
                    selectedAction = actions[indexPath.row]
                    
                    actionSelected = true
                }
            }
        }
        
        return actionSelected
    }
    
    fileprivate func configureMovementRequiredStateForInitialTouchLocation(for event: TouchLocatable) {
        for cell in tableView.visibleCells {
            let indexPath = tableView.indexPath(for: cell)!
            let location = event.touchLocation(in: cell)
            
            let inside = (location.y > 0 && location.y < cell.frame.size.height)
            
            if firstLocation == nil {
                firstLocation = location
                firstIndex = indexPath.row
                
                if inside {
                    requiresMovement = true
                    return
                }
            }
            
            if inside == false && requiresMovement == false {
                firstLocation = nil
                firstIndex = nil
            }
        }
    }
    
    fileprivate func removeMovementRequirementIfMovedFarEnoughFromFirstLocation(for event: TouchLocatable) {
        for cell in tableView.visibleCells {
            let indexPath = tableView.indexPath(for: cell)!
            let location = event.touchLocation(in: cell)
            
            if firstIndex! == indexPath.row && requiresMovement {
                let distanceX = abs(firstLocation!.x - location.x)
                let distanceY = abs(firstLocation!.y - location.y)
                
                if distanceX >= 35 || distanceY >= 35 {
                    requiresMovement = false
                }
            }
        }
    }
}




// MARK: Haptic Feedback Methods

extension OptionsViewController {
    func playSelectionChangedHaptic(for indexPath: IndexPath) {
        if let currentAction = selectedAction, currentAction.title != actions[indexPath.row].title {
            feedbackGenerator?.selectionChanged()
            feedbackGenerator?.prepare()
        }
    }
}

// MARK: Internal Property for Configuring Action Objects and Basic Setup

extension OptionsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
        
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.prepare()
        
        self.feedbackGenerator = feedbackGenerator
        
        self.label.text = item?.title
    }
    
    var actions: [UIPreviewAction] {
        get {
            let uncheck = UIPreviewAction(title: "Uncheck", style: .default) { (_, viewController : UIViewController) in
                if let vc = viewController as? OptionsViewController, let item = vc.item {
                    vc.delegate?.optionsDid(uncheck: item)
                }
            }
            
            let check = UIPreviewAction(title: "Check", style: .default) { (_, viewController : UIViewController) in
                if let vc = viewController as? OptionsViewController, let item = vc.item {
                    vc.delegate?.optionsDid(check: item)
                }
            }
            
            let moveUp = UIPreviewAction(title: "Move to Top", style: .default) { (_, viewController : UIViewController) in
                if let vc = viewController as? OptionsViewController, let item = vc.item {
                    vc.delegate?.optionsDid(moveUp: item)
                }
            }
            
            let moveDown = UIPreviewAction(title: "Move to Bottom", style: .default) { (_, viewController : UIViewController) in
                if let vc = viewController as? OptionsViewController, let item = vc.item {
                    vc.delegate?.optionsDid(moveDown: item)
                }
            }
            
            let delete = UIPreviewAction(title: "Delete", style: .destructive) { (_, viewController : UIViewController) in
                if let vc = viewController as? OptionsViewController, let item = vc.item {
                    vc.delegate?.optionsDid(delete: item)
                }
            }
            
            return [uncheck, check, moveUp, moveDown, delete]
        }
    }
}

// MARK: Table View Delegate and Data Source Methods

extension OptionsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        action.handler(action, self)
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
}

//
//  ViewController.swift
//  Previewing
//
//  Created by Conrad Stoll on 2/27/17.
//  Copyright © 2017 Conrad Stoll. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIViewControllerPreviewingDelegate, UIPreviewInteractionDelegate {
    
    var collection = ItemCollection()
    
    var previewInteraction : UIPreviewInteraction?
    var presentedOptionsController : OptionsViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Part 1
        registerForPreviewing(with: self, sourceView: tableView)
        
        // Part 2
        previewInteraction = UIPreviewInteraction(view: tableView)
        previewInteraction?.delegate = self
    }
    
    // MARK: Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let optionsViewController = segue.destination as? OptionsViewController,
        let cell = sender as? ItemCell,
        let indexPath = tableView.indexPath(for: cell) {
            
            optionsViewController.delegate = self
            optionsViewController.item = collection.items[indexPath.row]
            
            presentedOptionsController = optionsViewController
        }
    }
    
    // Part 1
    // MARK: UIViewControllerPreviewingDelegate Methods
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        // Part 2
        // Hack to avoid lost touch events after the interaction updates to a commit transition
        previewingContext.previewingGestureRecognizerForFailureRelationship.addTarget(self, action: #selector(handleTouches))
        
        // Part 1
        if let indexPath = tableView.indexPathForRow(at: location) {
            previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let optionsViewController = storyboard.instantiateViewController(withIdentifier: "OptionsViewController") as! OptionsViewController
            let item = collection.items[indexPath.row]

            optionsViewController.delegate = self
            optionsViewController.item = item
            
            presentedOptionsController = optionsViewController
            
            return optionsViewController
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
        
        if let vc = viewControllerToCommit as? OptionsViewController {
            vc.updateToCommittedUI()
        }
    }
    
    // Part 2
    func handleTouches(sender : UIGestureRecognizer) {
        presentedOptionsController?.updateUI(with: sender)
    }
    
    // Part 2
    // MARK: UIPreviewInteractionDelegate Methods
    
    func previewInteraction(_ previewInteraction: UIPreviewInteraction, didUpdatePreviewTransition transitionProgress: CGFloat, ended: Bool) {
        presentedOptionsController?.updateUI(for: previewInteraction)
    }
    
    func previewInteractionDidCancel(_ previewInteraction: UIPreviewInteraction) {
        presentedOptionsController?.commitAction()
        
        presentedOptionsController = nil
    }
    
    func previewInteractionShouldBegin(_ previewInteraction: UIPreviewInteraction) -> Bool {
        return true
    }
    
    func previewInteraction(_ previewInteraction: UIPreviewInteraction, didUpdateCommitTransition transitionProgress: CGFloat, ended: Bool) {
        presentedOptionsController?.updateUI(for: previewInteraction)
        
        if ended {
            presentedOptionsController?.finishedPreviewing()
        }
    }
}



// MARK: Options Delegate Methods

extension ViewController : OptionsViewControllerDelegate {
    func optionsDid(uncheck item: Item) {
        collection.uncheck(item)
        tableView.reloadData()
    }
    
    func optionsDid(check item: Item) {
        collection.check(item)
        tableView.reloadData()
    }
    
    func optionsDid(moveDown item: Item) {
        if let result = collection.moveDown(item) {
            tableView.moveRow(at: IndexPath(row: result.from, section: 0), to: IndexPath(row: result.to, section: 0))
        }
    }
    
    func optionsDid(moveUp item: Item) {
        if let result = collection.moveUp(item) {
            tableView.moveRow(at: IndexPath(row: result.from, section: 0), to: IndexPath(row: result.to, section: 0))
        }
    }
    
    func optionsDid(delete item: Item) {
        if let result = collection.delete(item) {
            tableView.deleteRows(at: [IndexPath(row: result, section: 0)], with: .fade)
        }
    }
}

// MARK: Table View Methods
extension ViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collection.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        let item = collection.items[indexPath.row]
        
        cell.accessoryType = item.type == .none ? .none : .checkmark
        cell.label.text = item.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = collection.items[indexPath.row]
        
        if item.type == .none {
            collection.check(item)
        } else {
            collection.uncheck(item)
        }
        
        tableView.reloadData()
    }
}


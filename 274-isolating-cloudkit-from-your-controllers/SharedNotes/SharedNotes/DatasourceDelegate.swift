//
//  DatasourceDelegate.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 6/1/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit

protocol DatasourceDelegate : class {
    func objectChanged(at indexPath: IndexPath)
    func objectAdded(at indexPath: IndexPath)
    func objectRemoved(at indexPath: IndexPath)
    func objectMoved(from fromIndexPath: IndexPath, to toIndexPath: IndexPath)
}

extension DatasourceDelegate where Self : UITableViewController {
    func objectAdded(at indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func objectChanged(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func objectRemoved(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func objectMoved(from fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        tableView.moveRow(at: fromIndexPath, to: toIndexPath)
    }
}



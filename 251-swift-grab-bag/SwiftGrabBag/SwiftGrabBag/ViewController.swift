//
//  ViewController.swift
//  SwiftGrabBag
//
//  Created by Ben Scheirman on 1/11/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        save(value: "night", forKey: "theme")
        
        UINavigationController().popViewController(animated: true)
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @discardableResult func save(value: String, forKey key: String) -> Bool {
        // ...
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if indexPath.section == 0 {
            return
        }
        
        // push a vc
    }
}


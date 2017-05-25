//
//  NoteListViewController.swift
//  MyNotes
//
//  Created by Ben Scheirman on 5/23/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit

final class NoteListViewController : UITableViewController, StoryboardInitializable {
    
    let cellIdentifier = "cell"
    
    let notes = [
        "Buy Eggs",
        "Get batteries",
        "Renew Passport",
        "Passcode to garage: xxxx",
        "Dimensions of table: 81\" x 34.5\""
    ]
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = notes[indexPath.row]
        return cell
    }
}

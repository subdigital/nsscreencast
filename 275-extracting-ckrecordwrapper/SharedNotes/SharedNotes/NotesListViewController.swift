//
//  NotesListViewController.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/16/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit

protocol NoteListCoordinationDelegate : class {
    func didSelect(note: Note, from: NotesListViewController)
    func newNoteTapped(from: NotesListViewController)
}

final class NotesListViewController : UITableViewController, StoryboardInitializable, DataSourceDelegate {
    
    weak var coordinationDelegate: NoteListCoordinationDelegate?
    
    var notesDatasource: NotesDatasource! {
        didSet {
            notesDatasource.delegate = self
        }
    }
    
    let NoteCell = "NoteCell"
 
    var folder: Folder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = folder.name
        fetchNotes()
    }
    
    private func fetchNotes() {
        notesDatasource.fetchNotes { result in
            switch result {
            case .success(_):
                self.tableView.reloadData()
            case .error(let e):
                print(e)
                self.displayError(message: "Notes could not be loaded.")
            }
        }
    }
    
    @IBAction func newNote(_ sender: Any) {
        coordinationDelegate?.newNoteTapped(from: self)
    }
    
    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesDatasource.notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell, for: indexPath)
        let note = notesDatasource.object(at: indexPath)
        cell.textLabel?.text = note.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notesDatasource.object(at: indexPath)
        coordinationDelegate?.didSelect(note: note, from: self)
    }
}

//extension NotesListViewController : DataSourceDelegate {
//    
//}

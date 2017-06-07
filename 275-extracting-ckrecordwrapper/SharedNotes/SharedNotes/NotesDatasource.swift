//
//  NotesDatasource.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/31/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation
import UIKit

protocol DataSourceDelegate : class {
    func objectChanged(at indexPath: IndexPath)
    func objectAdded(at indexPath: IndexPath)
    func objectRemoved(at indexPath: IndexPath)
    func objectMoved(from fromIndexPath: IndexPath, to toIndexPath: IndexPath)
}

extension DataSourceDelegate where Self : UITableViewController {
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

class NotesDatasource {
    let noteManager: NotesManager
    let folder: Folder
    
    var notes: [Note] = []
    
    weak var delegate: DataSourceDelegate?
    
    init(parent: Folder, noteManager: NotesManager) {
        self.folder = parent
        self.noteManager = noteManager
        NotificationCenter.default.addObserver(self, selector: #selector(noteUpdated(notification:)), name: .NoteWasUpdated, object: nil)
    }
    
    @discardableResult
    func insert(note: Note, at index: Int) -> IndexPath {
        notes.insert(note, at: index)
        let indexPath = IndexPath(item: index, section: 0)
        delegate?.objectAdded(at: indexPath)
        return indexPath
    }
    
    @objc func noteUpdated(notification: NSNotification) {
        
        if let note = notification.object as? Note {
            if let index = notes.index(where: { n in
                n.identifier == note.identifier
            }) {
                
                notes[index] = note
                let indexPath = IndexPath(row: index, section: 0)
                DispatchQueue.main.async {
                    self.delegate?.objectChanged(at: indexPath)
                }
            }
        }
    }
    
    func fetchNotes(completion: @escaping (Result<[Note]>) -> Void) {
        noteManager.fetchNotes(for: folder) { result in
            switch result {
            case .success(let notes):
                self.notes = notes
                DispatchQueue.main.async {
                    completion(.success(notes))
                }
            default:
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    func object(at indexPath: IndexPath) -> Note {
        return notes[indexPath.row]
    }
}

//
//  NotesDatasource.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/31/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation
import UIKit

class NotesDatasource : ArrayDatasource<Note> {
    let noteManager: NotesManager
    let folder: Folder
    
    init(parent: Folder, noteManager: NotesManager) {
        self.folder = parent
        self.noteManager = noteManager
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(noteUpdated(notification:)), name: .NoteWasUpdated, object: nil)
    }
    
    @objc func noteUpdated(notification: NSNotification) {
        if let note = notification.object as? Note {
            if let index = objects.index(where: { n in
                n.identifier == note.identifier
            }) {
                
                objects[index] = note
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
                self.objects = notes
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
}

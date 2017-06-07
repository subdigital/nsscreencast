//
//  FoldersDatasource.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/31/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation

class FoldersDatasource {
    let noteManager: NotesManager
    
    init(noteManager: NotesManager) {
        self.noteManager = noteManager
    }
    
    func fetchFolders(completion: @escaping (Result<[Folder]>) -> Void) {
        noteManager.fetchFolders { result in
            switch result {
            case .success(let folders):
                DispatchQueue.main.async {
                    completion(.success(folders))
                }
            default:
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
}

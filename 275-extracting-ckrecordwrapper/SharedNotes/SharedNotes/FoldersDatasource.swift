//
//  FoldersDatasource.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/31/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation

class FoldersDatasource {
    let cache = DiskCache(name: "folders")
    let noteManager: NotesManager
    
    init(noteManager: NotesManager) {
        self.noteManager = noteManager
    }
    
    func fetchFolders(completion: @escaping (Result<[Folder]>) -> Void) {
        let cachedFolders: [Folder]? = cache.fetch()
        if let folders = cachedFolders {
            DispatchQueue.main.async {
                print("Returning cached folders...")
                completion(.success(folders))
            }
        }
        
        noteManager.fetchFolders { result in
            switch result {
            case .success(let folders):
                let codableFolders = folders.map { $0.codable() }
                print("Caching updated results...")
                self.cache.save(object: codableFolders)
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

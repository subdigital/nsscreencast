//
//  InMemoryNotesManager.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/31/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation

class InMemoryNotesManager : NotesManager {
    static var hasCreatedDefaultFolder = false
    
    static var sharedInstance: NotesManager = InMemoryNotesManager()
    
    private var folders: [String : Folder] = [:]
    private var notes: [String : Note] = [:]
    
    private init() {
    }
    
    // MARK: - Folders
    
    public func createDefaultFolder(completion: @escaping (Result<Folder>) -> Void) {
        let folder = InMemoryFolder(name: "My Notes")
        folder.identifier = "default"
        save(folder: folder, completion: completion)
    }
    
    public func fetchFolders(completion: @escaping OperationCompletionBlock<[Folder]>) {
        let sortedFolders = folders.values.sorted { (a, b) in
            guard let createdA = a.createdAt, let createdB = b.createdAt else {
                fatalError("Saved folders must have non-nil createdAt dates.")
            }
            
            return createdA < createdB
        }
        completion(.success(sortedFolders))
    }
    
    public func save(folder: Folder, completion: @escaping OperationCompletionBlock<Folder>) {
        guard let folder = folder as? InMemoryFolder else { return }
        
        folder.identifier ??= UUID().uuidString
        folder.createdAt ??= Date()
        
        folders[folder.identifier!] = folder
        
        completion(.success(folder))
    }
    
    public func delete(folder: Folder, completion: @escaping OperationCompletionBlock<Bool>) {
        if let id = folder.identifier {
            folders.removeValue(forKey: id)
        }
        
        completion(.success(true))
    }
    
    public func newFolder(name: String) -> Folder {
        return InMemoryFolder(name: name)
    }
    
    // MARK: - Notes
    
    public func newNote(in folder: Folder) -> Note {
        let note = InMemoryNote()
        note.folderIdentifier = folder.identifier
        return note
    }
    
    public func fetchNotes(for folder: Folder, completion: @escaping OperationCompletionBlock<[Note]>) {
        
        let folderNotes = notes.values
            .filter { $0.folderIdentifier == folder.identifier }
            .sorted { a, b in
                guard let modifiedA = a.modifiedAt, let modifiedB = b.modifiedAt else {
                    fatalError("Saved notes must have a non-nil modified date.")
                }
                
                return modifiedA < modifiedB
            }
        
        completion(.success(folderNotes))
    }
    
    public func save(note: Note, completion: @escaping OperationCompletionBlock<Note>) {
        let savedNote = InMemoryNote(note: note)
        savedNote.identifier ??= UUID().uuidString
        savedNote.createdAt ??= Date()
        savedNote.content = note.content
        savedNote.modifiedAt = Date()
        
        notes[savedNote.identifier!] = savedNote
        
        completion(.success(savedNote))
        NotificationCenter.default.post(name: .NoteWasUpdated, object: note)
    }
}

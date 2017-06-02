//
//  NotesManager.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/16/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let NoteWasUpdated = Notification.Name("NoteWasUpdated")
}

protocol NotesManager {
    
    typealias OperationCompletionBlock<T> = (Result<T>) -> Void
    
    static var hasCreatedDefaultFolder: Bool { get }
    static var sharedInstance: NotesManager { get }
    
    func newFolder(name: String) -> Folder
    func newNote(in folder: Folder) -> Note
    
    func createDefaultFolder(completion: @escaping OperationCompletionBlock<Folder>)
    
    func fetchFolders(completion: @escaping OperationCompletionBlock<[Folder]>)
    func save(folder: Folder, completion: @escaping OperationCompletionBlock<Folder>)
    func delete(folder: Folder, completion: @escaping OperationCompletionBlock<Bool>)
    func fetchNotes(for: Folder, completion: @escaping OperationCompletionBlock<[Note]>)
    func save(note: Note, completion: @escaping OperationCompletionBlock<Note>)
}


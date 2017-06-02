//
//  CloudKitNotesManager.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 6/1/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitNotesManager : NotesManager {
    
    static var sharedInstance: NotesManager = CloudKitNotesManager(database: CKContainer.default().privateCloudDatabase)
    
    private static let HasCreatedDefaultFolderKey = "HasCreatedDefaultFolder"
    static var hasCreatedDefaultFolder: Bool {
        get {
            return UserDefaults.standard.bool(forKey: HasCreatedDefaultFolderKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: HasCreatedDefaultFolderKey)
        }
    }
    
    
    private let database: CKDatabase
    private let zoneID: CKRecordZoneID
    
    init(database: CKDatabase) {
        self.database = database
        zoneID = CKRecordZone.default().zoneID
    }
    
    func createDefaultFolder(completion: @escaping (Result<Folder>) -> Void) {
        let folder = CloudKitFolder.defaultFolder(inZone: zoneID)
        database.save(folder.record) { record, error in
            if let e = error as? CKError {
                if e.code == CKError.Code.serverRecordChanged {
                    // silently fail, record already exists
                    let serverFolder = CloudKitFolder(record: e.serverRecord!)
                    completion(.success(serverFolder))
                } else {
                    completion(.error(e))
                }
            } else if let e = error {
                completion(.error(e))
            } else if let record = record {
                let serverFolder = CloudKitFolder(record: record)
                completion(.success(serverFolder))
            }
        }
    }
    
    func fetchFolders(completion: @escaping (Result<[Folder]>) -> Void) {
        let all = NSPredicate(value: true)
        let sort = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        query(predicate: all,
              sortDescriptors: sort,
              conversion: { (folder: CloudKitFolder) in folder },
              completion: completion)
    }
    
    func newFolder(name: String) -> Folder {
        return CloudKitFolder(name: name)
    }
    
    func save(folder: Folder, completion: @escaping (Result<Folder>) -> Void) {
        guard let folder = folder as? CloudKitFolder else { fatalError("Only works with CloudKit models") }
        save(record: folder, conversion: { $0 }, completion: completion)
    }
    
    func delete(folder: Folder, completion: @escaping (Result<Bool>) -> Void) {
        guard let folder = folder as? CloudKitFolder else { fatalError("must pass in a CloudKitFolder") }
        delete(folder: folder, completion: completion)
    }
    
    func newNote(in folder: Folder) -> Note {
        let note = CloudKitNote(zoneID: zoneID)
        note.folderIdentifier = folder.identifier
        return note
    }
    
    func fetchNotes(for folder: Folder, completion: @escaping (Result<[Note]>) -> Void) {
        guard let folder = folder as? CloudKitFolder else { fatalError("must pass in a CloudKitFolder") }
        
        let inFolderPredicate = NSPredicate(format: "folder == %@", CKReference(recordID: folder.record.recordID, action: .deleteSelf))
        let sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        
        query(predicate: inFolderPredicate,
              sortDescriptors: sortDescriptors,
              conversion: { (note: CloudKitNote) -> Note in note },
              completion: completion)
    }

    func save(note: Note, completion: @escaping (Result<Note>) -> Void) {
        guard let note = note as? CloudKitNote else { fatalError("must pass in a CloudKitNote") }
        save(record: note, conversion: { $0 }) { result in
            
            switch result {
            case .success(let savedNote):
                NotificationCenter.default.post(name: .NoteWasUpdated, object: savedNote)
                completion(.success(savedNote))
            case .error(let e):
                completion(.error(e))
            }
        }
    }
    

    
    private func save<R : CKRecordWrapper, T>(record: R,
                      conversion: @escaping (R) -> T,
                      completion: @escaping OperationCompletionBlock<T>) {
        
        let modifyOp = CKModifyRecordsOperation(recordsToSave: [record.record],
                                                recordIDsToDelete: nil)
        modifyOp.modifyRecordsCompletionBlock = { saved, deleted, error in
            if let e = error {
                print("Error saving: \(record)")
                completion(.error(e))
            } else if let savedRecord = saved?.first {
                let result = R(record: savedRecord)
                completion(.success(conversion(result)))
            }
        }
        database.add(modifyOp)
    }
    
    private func delete<R : CKRecordWrapper>(record: R,
                      completion: @escaping OperationCompletionBlock<Bool>) {
        
        let modifyOp = CKModifyRecordsOperation(recordsToSave: nil,
                                                recordIDsToDelete: [record.record.recordID])
        modifyOp.modifyRecordsCompletionBlock = { saved, deleted, error in
            if let e = error {
                print("Error saving: \(record)")
                completion(.error(e))
            } else {
                let deleteCount = (deleted?.count ?? 0)
                completion(.success(deleteCount > 0))
            }
        }
        database.add(modifyOp)
    }
    
    private func query<R : CKRecordWrapper, T>(predicate: NSPredicate,
                       sortDescriptors: [NSSortDescriptor],
                       conversion: @escaping (R) -> T,
                       completion: @escaping OperationCompletionBlock<[T]>) {
        let query = CKQuery(recordType: R.RecordType, predicate: predicate)
        query.sortDescriptors = sortDescriptors
        
        let queryOperation = CKQueryOperation(query: query)
        var results: [R] = []
        queryOperation.recordFetchedBlock = { record in
            results.append(R(record: record))
        }
        queryOperation.queryCompletionBlock = { cursor, error in
            // ignore cursor for now
            
            if let e = error as? CKError, e.code == CKError.Code.unknownItem {
                // pretend success
                completion(.success([]))
            } else if let e = error {
                completion(.error(e))
            } else {
                completion(.success(results.map(conversion)))
            }
        }
        database.add(queryOperation)
    }
}

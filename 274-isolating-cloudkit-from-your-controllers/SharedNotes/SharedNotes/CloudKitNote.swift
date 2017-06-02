//
//  CloudKitNote.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 6/1/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitNote : Note, CKRecordWrapper {
    static let RecordType = "Note"
    
    let record: CKRecord
    
    enum FieldKey : String {
        case content
        case folder
    }
    
    var content: String {
        get {
            return getField(.content) ?? ""
        }
        set {
            setField(.content, value: newValue)
        }
    }
    
    var folderIdentifier: String? {
        get {
            return getReference(.folder)
        }
        set {
            setReference(.folder, referenceIdentifier: newValue)
        }
    }
    
    convenience init(zoneID: CKRecordZoneID? = nil) {
        let recordID = CKRecordID(recordName: UUID().uuidString, zoneID: zoneID ?? CKRecordZone.default().zoneID)
        let record = CKRecord(recordType: CloudKitNote.RecordType, recordID: recordID)
        self.init(record: record)
    }
    
    init(note: Note) {
        record = CKRecord(recordType: CloudKitNote.RecordType)
        content = note.content
        folderIdentifier = note.folderIdentifier
    }
    
    required init(record: CKRecord) {
        self.record = record
    }
}

extension CloudKitNote {
    func codable() -> NSCoding {
        return record
    }
    
    static func fromCoding(decoder: NSCoder) -> AnyObject? {
        if let record = CKRecord(coder: decoder) {
            return CloudKitNote(record: record)
        }
        
        return nil
    }
}

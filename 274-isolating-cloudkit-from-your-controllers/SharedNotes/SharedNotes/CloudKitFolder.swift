//
//  CloudKitFolder.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 6/1/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitFolder : Folder, CKRecordWrapper {
    static let RecordType = "Folder"
    
    let record: CKRecord
    
    enum FieldKey : String {
        case name
    }
    
    var name: String {
        get { return getField(.name) ?? "" }
        set { setField(.name, value: newValue) }
    }
    
    required init(name: String) {
        self.record = CKRecord(recordType: CloudKitFolder.RecordType)
        self.name = name
    }
    
    required init(record: CKRecord) {
        self.record = record
    }
}

extension CloudKitFolder {
    static func defaultFolder(inZone zoneID: CKRecordZoneID) -> CloudKitFolder {
        let recordID = CKRecordID(recordName: "DEFAULT_FOLDER", zoneID: zoneID)
        let record = CKRecord(recordType: CloudKitFolder.RecordType, recordID: recordID)
        let folder = CloudKitFolder(record: record)
        folder.name = "My Notes"
        return folder
    }
}


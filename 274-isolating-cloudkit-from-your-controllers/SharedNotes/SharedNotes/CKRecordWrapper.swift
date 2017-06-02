//
//  CKRecordWrapper.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 6/1/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation
import CloudKit

protocol CKRecordWrapper {
    static var RecordType: String { get }
    var record: CKRecord { get }
    
    associatedtype FieldKey : RawRepresentable
    
    var identifier: String? { get }
    var createdAt: Date? { get }
    var modifiedAt: Date? { get }
    
    init(record: CKRecord)
}

extension CKRecordWrapper {
    var identifier: String? {
        get {
            return record.recordID.recordName
        }
    }
    
    var createdAt: Date? {
        return record.creationDate
    }
    
    var modifiedAt: Date? {
        return record.modificationDate
    }
}

extension CKRecordWrapper where FieldKey.RawValue == String {
    func getField<T>(_ key: FieldKey) -> T? {
        return record[key.rawValue] as? T
    }
    
    func setField<T>(_ key: FieldKey, value: T?) {
        record[key.rawValue] = value as? CKRecordValue
    }
    
    func getReference(_ key: FieldKey) -> String? {
        let ref: CKReference? = getField(key)
        return ref?.recordID.recordName
    }
    
    func setReference(_ key: FieldKey, referenceIdentifier: String?) {
        let ref = referenceIdentifier.flatMap { id -> CKReference in
            let rid = CKRecordID(recordName: id)
            return CKReference(recordID: rid, action: .deleteSelf)
        }
        setField(key, value: ref)
    }
}


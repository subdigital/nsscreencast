//
//  InMemoryNote.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/31/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation

class InMemoryNote : Note, NSCoding, VendsCoding {
    var identifier: String?
    var content: String = ""
    var createdAt: Date?
    var modifiedAt: Date?
    var folderIdentifier: String?
    
    init() {
    }
    
    init(note: Note) {
        identifier = note.identifier
        content = note.content
        createdAt = note.createdAt
        modifiedAt = note.modifiedAt
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let content = aDecoder.decodeObject(forKey: "content") as? String,
            let folderIdentifier = aDecoder.decodeObject(forKey: "folderIdentifier") as? String
        else {
            return nil
        }
        
        self.content = content
        self.folderIdentifier = folderIdentifier
        
        identifier = aDecoder.decodeObject(forKey: "identifier") as? String
        
        let createdAtInterval = aDecoder.decodeDouble(forKey: "createdAtInterval")
        if createdAtInterval > 0 {
            createdAt = Date(timeIntervalSince1970: createdAtInterval)
        }
        
        let modifiedAtInterval = aDecoder.decodeDouble(forKey: "modifiedAtInterval")
        if modifiedAtInterval > 0 {
            modifiedAt = Date(timeIntervalSince1970: modifiedAtInterval)
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(content, forKey: "content")
        aCoder.encode(folderIdentifier, forKey: "folderIdentifier")
        
        if let identifier = self.identifier {
            aCoder.encode(identifier, forKey: "identifier")
        }
        
        aCoder.encode(createdAt?.timeIntervalSince1970 ?? 0, forKey: "createdAtInterval")
        aCoder.encode(createdAt?.timeIntervalSince1970 ?? 0, forKey: "modifiedAtInterval")
    }
    
    func codable() -> NSCoding {
        return self
    }
    
    static func fromCoding(decoder: NSCoder) -> Folder? {
        return InMemoryFolder(coder: decoder)
    }

}

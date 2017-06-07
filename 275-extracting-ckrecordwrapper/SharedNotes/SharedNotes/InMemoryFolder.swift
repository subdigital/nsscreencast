//
//  InMemoryFolder.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/31/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation

class InMemoryFolder : Folder, NSCoding, VendsCoding {
    var identifier: String?
    var name: String
    var createdAt: Date?
    var modifiedAt: Date?
    
    required init(name: String) {
        self.name = name
    }
    
    init(folder: Folder) {
        self.identifier = folder.identifier
        self.name = folder.name
        self.createdAt = folder.createdAt
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String else {
            return nil
        }
     
        self.name = name
        
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
        aCoder.encode(name, forKey: "name")
        
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

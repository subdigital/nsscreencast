//
//  Folder.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/16/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation

protocol VendsCoding {
    func codable() -> NSCoding
    static func fromCoding(decoder: NSCoder) -> Folder?
}

protocol Folder : VendsCoding {
    var identifier: String? { get }
    var name: String { get set }
    var createdAt: Date? { get }
    var modifiedAt: Date? { get }
    
    init(name: String)
    
}

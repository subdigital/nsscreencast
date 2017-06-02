//
//  Note.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/16/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation

protocol Note : VendsCoding {
    var identifier: String? { get }
    
    var title: String { get }
    var content: String { get set }
    
    var createdAt: Date? { get }
    var modifiedAt: Date? { get }
    var folderIdentifier: String? { get set }
}

extension Note {
    var title: String {
        let length = content.lengthOfBytes(using: .utf8)
        if length == 0 {
            return "New Note"
        } else {
            let previewLength = 20
            
            // if it's short enough, just use the entire content
            if length < previewLength {
                return content
            }
            
            var index = content.index(content.startIndex, offsetBy: previewLength)
            
            var foundTitle = false
            if let firstNewLine = content.range(of: "\n") {
                if firstNewLine.upperBound < index {
                    index = firstNewLine.upperBound
                    foundTitle = true
                }
            }
            
            var preview = content.substring(to: index)
            
            if content.lengthOfBytes(using: .utf8) > previewLength && !foundTitle {
                preview.append("...")
            }
            
            return preview
        }
    }
}

//
//  Contact.swift
//  CompanyRoster
//
//  Created by Ben Scheirman on 10/12/15.
//  Copyright © 2015 NSScreencast. All rights reserved.
//

import Foundation
import CoreSpotlight
import UIKit

struct Contact {
    var name: String
    var department: String
    var imageName: String
}

extension Contact {
    func searchableAttributeSet() -> CSSearchableItemAttributeSet {
        let attr = CSSearchableItemAttributeSet(itemContentType: "com.companyroster.contact")
        attr.title = name
        attr.keywords = ["nsscreencast", department]
        attr.contentDescription = "In department: \(department)"
        attr.thumbnailData = UIImageJPEGRepresentation(UIImage(named: imageName)!, 1.0)
        return attr
    }
}

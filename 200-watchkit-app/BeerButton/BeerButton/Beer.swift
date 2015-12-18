//
//  Beer.swift
//  BeerButton
//
//  Created by Conrad Stoll on 11/1/15.
//  Copyright © 2015 Conrad Stoll. All rights reserved.
//

import Foundation
import UIKit

struct Beer {
    var title = ""
    var image : UIImage?
    
    init(title : String, image : UIImage) {
        self.title = title
        self.image = image
    }
    
    init(dictionary: [String : AnyObject]) {
        if let title = dictionary["title"] as? String {
            self.title = title
        }
        
        if let image = dictionary["image"] as? NSData {
            self.image = UIImage(data: image)
        }
    }
    
    func toDictionary() -> [String : AnyObject] {
        return ["title" : title, "image" : UIImagePNGRepresentation(image!)!]
    }
}


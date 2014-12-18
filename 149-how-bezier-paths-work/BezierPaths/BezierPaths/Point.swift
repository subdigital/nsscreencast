//
//  Point.swift
//  BezierPaths
//
//  Created by Ben Scheirman on 12/14/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

import UIKit

class Point : NSObject {
    
    var x: CGFloat = 0
    var y: CGFloat = 0
    var dragging: Bool = false
    
    convenience init(x: CGFloat, y: CGFloat) {
        self.init()
        self.x = x
        self.y = y
    }
    
}

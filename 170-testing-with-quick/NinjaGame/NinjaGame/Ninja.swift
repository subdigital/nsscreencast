//
//  Ninja.swift
//  NinjaGame
//
//  Created by Ben Scheirman on 5/19/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import Foundation

public class Enemy {
    public var hitPoints = 100
    public init() {
        
    }
}

public class Ninja {
    public var name: String
    
    public init(name: String) {
        self.name = name
    }
    
    public func encounter(enemy: Enemy) {
        let ms = arc4random_uniform(100)
        let delta = UInt64(ms) * NSEC_PER_MSEC
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delta))
        dispatch_after(time, dispatch_get_main_queue()) {
            enemy.hitPoints -= 10
        }
    }
}


extension Ninja : Equatable {}

public func ==(lhs: Ninja, rhs: Ninja) -> Bool {
    return lhs.name == rhs.name
}
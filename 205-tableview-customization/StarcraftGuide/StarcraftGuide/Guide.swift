//
//  BuildOrder.swift
//  StarcraftGuide
//
//  Created by Ben Scheirman on 1/18/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

class Guide {
    var name: String?
    var race: Race?
    var buildOrder: [Unit] = []
    
    init() {
    }
    
    init(name: String, race: Race) {
        self.name = name
        self.race = race
    }
}

//
//  UnitStore.swift
//  StarcraftGuide
//
//  Created by Ben Scheirman on 1/18/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation

struct UnitStore {
    static var units: [Race: [Unit]] = {
        let units = UnitStore.loadUnits()
        return groupBy(units) { $0.race }
    }()
    
    private static func loadUnits() -> [Unit] {
        guard let path = NSBundle.mainBundle().pathForResource("units", ofType: "plist") else {
            print("ERROR: couldn't find info.plist!")
            return []
        }
        
        var units = [Unit]()
        
        let plistArray = NSArray(contentsOfFile: path)!
        for obj in plistArray {
            if let dict = obj as? NSDictionary {
                if let race = Race(rawValue: dict["race"] as! String) {
                    let name = dict["name"] as! String
                    let type = dict["type"] as! String
                    let imageName = dict["image"] as? String
                    let unit = Unit(name: name, type: type, imageName: imageName, race: race)
                    units.append(unit)
                }
            }
        }

        return units
    }
}
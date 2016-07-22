//
//  RequiresHealth.swift
//  ActivityPlusTwo
//
//  Created by Ben Scheirman on 7/5/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation
import HealthKit
import UIKit

protocol RequiresHealth {
    var healthStore: HKHealthStore? { get set }
}

extension UINavigationController : RequiresHealth {
    var healthStore: HKHealthStore? {
        get {
            if let vc = topViewController as? RequiresHealth {
                return vc.healthStore
            }
            return nil
        }
        set {
            if var vc = topViewController as? RequiresHealth {
                vc.healthStore = newValue
            }
        }
    }
}


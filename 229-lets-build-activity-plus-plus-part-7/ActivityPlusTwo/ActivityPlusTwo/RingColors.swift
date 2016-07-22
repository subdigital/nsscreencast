//
//  Theme.swift
//  ActivityPlusTwo
//
//  Created by Ben Scheirman on 6/6/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

enum RingColors {
    case Exercise
    case Standing
    case Activity
    case Summary
    
    var baseColor: UIColor {
        switch self {
        case .Activity: return UIColor(red:0.49, green:0.09, blue:0.03, alpha:1.00)
        case .Exercise: return UIColor(red:0.11, green:0.49, blue:0.07, alpha:1.00)
        case .Standing: return UIColor(red:0.04, green:0.34, blue:0.49, alpha:1.00)
        case .Summary: return UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.00)
        }
    }
    
    var highlightedColor: UIColor {
        switch self {
        case .Activity: return UIColor(red:0.78, green:0.15, blue:0.08, alpha:1.00)
        case .Exercise: return UIColor(red:0.18, green:0.74, blue:0.13, alpha:1.00)
        case .Standing: return UIColor(red:0.12, green:0.67, blue:0.99, alpha:1.00)
        case .Summary: return UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.00)
        }
    }
    
    var mutedColor: UIColor {
        switch self {
        case .Activity: return UIColor(red:0.29, green:0.05, blue:0.01, alpha:1.00)
        case .Exercise: return UIColor(red:0.05, green:0.29, blue:0.03, alpha:1.00)
        case .Standing: return UIColor(red:0.02, green:0.20, blue:0.30, alpha:1.00)
        case .Summary: return UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.00)
        }
    }
    
    var strokeColor: UIColor {
        switch self {
        case .Activity: return UIColor(red:0.44, green:0.02, blue:0.00, alpha:1.00)
        case .Exercise: return UIColor(red:0.04, green:0.50, blue:0.04, alpha:1.00)
        case .Standing: return UIColor(red:0.01, green:0.15, blue:0.26, alpha:1.00)
        case .Summary: return UIColor.blackColor()
        }
    }
}


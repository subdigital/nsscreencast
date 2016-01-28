//
//  UIColor+Extensions.swift
//  StarcraftGuide
//
//  Created by Ben Scheirman on 1/20/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

extension UIColor {
    func colorByApplyingFactor(factor: Float) -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let f = CGFloat(factor)
        return UIColor(red: r*f, green: g*f, blue: b*f, alpha: a)
    }
    
    func colorByLightening(pct: Float) -> UIColor {
        return colorByApplyingFactor(pct)
    }
    
    func colorByDarkening(pct: Float) -> UIColor {
        return colorByApplyingFactor(1-pct)
    }
}

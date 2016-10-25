//
//  CircularProgressLayer.swift
//  FileDownloads
//
//  Created by Ben Scheirman on 10/25/16.
//  Copyright © 2016 Fickle Bits, LLC. All rights reserved.
//

import UIKit

class CircularProgressLayer : CAShapeLayer {
    
    var color: UIColor = .lightGray {
        didSet {
            strokeColor = color.cgColor
        }
    }
    
    var fillLayer: CAShapeLayer!
    
    var progress: CGFloat = 0 {
        didSet {
            update()
        }
    }
    
    override init() {
        super.init()
        _setupLayer()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        _setupLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setupLayer()
    }
    
    private func _setupLayer() {
        isOpaque = false
        lineWidth = 2
        fillColor = UIColor.clear.cgColor
        strokeColor = color.cgColor
    }
    
    func update() {
        path = UIBezierPath(ovalIn: bounds).cgPath
        
        let fillPath = UIBezierPath()
        let radius = frame.size.width / 2
        
        let center = CGPoint(x: frame.origin.x + frame.size.width/2, y: frame.origin.y + frame.size.height/2)
        fillPath.move(to: center)
        
        //   |
        //   O -
        //
        
        let startAngle: CGFloat = -.pi/2
    }
}

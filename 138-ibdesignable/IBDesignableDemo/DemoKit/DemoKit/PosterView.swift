//
//  PosterView.swift
//  DemoKit
//
//  Created by Ben Scheirman on 9/21/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

import UIKit

@IBDesignable class PosterView : UIView {
    
    var label: UILabel!
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }
    
    @IBInspectable var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    @IBInspectable var text: NSString? {
        didSet {
            label.text = text
        }
    }
    
    func createSubviews() {
        imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.Bottom
        self.addSubview(imageView)
        
        label = UILabel()
        label.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6);
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(20)
        label.textAlignment = NSTextAlignment.Center
        self.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        clipsToBounds = true
        
        ;        layer.borderColor = UIColor.blackColor().CGColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 42
        
        imageView.frame = self.bounds

        let labelHeight: CGFloat = 30.0
        label.frame = CGRectMake(0, bounds.size.height - labelHeight,
            bounds.size.width, labelHeight)
        bringSubviewToFront(label)
    }
}
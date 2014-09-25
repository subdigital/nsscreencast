//
//  PosterView.swift
//  DesignableKit
//
//  Created by Ben Scheirman on 9/21/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

import UIKit

@IBDesignable class PosterView : UIView {
    
    var label: UILabel!
    var imageView: UIImageView!
    
    @IBInspectable var text: NSString? {
        didSet {
            label.text = text
        }
    }
    
    @IBInspectable var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }
    
    func createSubviews() {
        imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        addSubview(imageView)
        
        label = UILabel()
        label.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(20)
        label.textAlignment = NSTextAlignment.Center
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.blackColor().CGColor
        layer.cornerRadius = 24
        clipsToBounds = true
        
        imageView.frame = self.bounds
        
        let labelHeight: CGFloat = 40
        label.frame = CGRectMake(0, bounds.size.height - labelHeight,
            bounds.size.width, labelHeight)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        text = "Test Title"
        
    }
}

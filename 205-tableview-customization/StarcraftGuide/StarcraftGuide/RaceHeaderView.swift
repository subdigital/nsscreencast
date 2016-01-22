//
//  RaceHeaderView.swift
//  StarcraftGuide
//
//  Created by Ben Scheirman on 1/20/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class RaceHeaderView : UIView {
    var imageView: UIImageView!
    var label: UILabel!
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    func setupSubviews() {
        backgroundColor = Theme.Colors.SectionHeader.color
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIViewContentMode.Center
        addSubview(imageView)
        
        imageView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        imageView.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: 20).active = true
        
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Fonts.BoldTitleFont.font
        label.textColor = Theme.Colors.TintColor.color
        addSubview(label)
        label.leftAnchor.constraintEqualToAnchor(imageView.rightAnchor, constant: 20).active = true
        label.centerYAnchor.constraintEqualToAnchor(imageView.centerYAnchor).active = true
    }
}

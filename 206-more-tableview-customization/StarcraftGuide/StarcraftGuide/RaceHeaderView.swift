//
//  RaceHeaderView.swift
//  StarcraftGuide
//
//  Created by Ben Scheirman on 1/20/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class RaceHeaderView : UITableViewHeaderFooterView {
    static let reuseIdentifier = "RaceHeaderView"
    
    var imageView: UIImageView!
    var label: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: RaceHeaderView.reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    func setupSubviews() {
        textLabel?.hidden = true
        detailTextLabel?.hidden = true
        
        contentView.backgroundColor = Theme.Colors.SectionHeader.color
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIViewContentMode.Center
        contentView.addSubview(imageView)
        
        imageView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        imageView.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: 20).active = true
        
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Fonts.BoldTitleFont.font
        label.textColor = Theme.Colors.TintColor.color
        contentView.addSubview(label)

        label.leftAnchor.constraintEqualToAnchor(imageView.rightAnchor, constant: 20).active = true
        label.centerYAnchor.constraintEqualToAnchor(imageView.centerYAnchor).active = true
    }
}

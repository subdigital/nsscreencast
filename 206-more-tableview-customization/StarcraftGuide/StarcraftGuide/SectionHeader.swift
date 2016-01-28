//
//  SectionHeader.swift
//  StarcraftGuide
//
//  Created by Ben Scheirman on 1/19/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class SectionHeader : UITableViewHeaderFooterView {
    static let reuseIdentifier = "SectionHeader"
    var label: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: SectionHeader.reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    func setupSubviews() {
        label = UILabel()
        label.font = Theme.Fonts.TitleFont.font
        label.textColor = Theme.Colors.LightTextColor.color
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        label.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        label.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        label.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: 20).active = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRectZero
        detailTextLabel?.frame = CGRectZero

    }
}

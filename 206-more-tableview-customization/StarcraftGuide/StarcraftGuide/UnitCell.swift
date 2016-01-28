//
//  UnitCell.swift
//  StarcraftGuide
//
//  Created by Ben Scheirman on 1/18/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class UnitCell : UITableViewCell {
    static let reuseIdentifier = "UnitCell"
    
    init() {
        super.init(style: .Default, reuseIdentifier: UnitCell.reuseIdentifier)
        commonSetup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    private func commonSetup() {
        backgroundColor = UIColor.blackColor()
        textLabel?.textColor = Theme.Colors.Foreground.color
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor.blackColor()
    }
    
    override func prepareForReuse() {
        self.imageView?.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        print("setHighlighted(\(highlighted), animated: \(animated))")
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            textLabel?.textColor = Theme.Colors.TintColor.color
        } else {
            textLabel?.textColor = Theme.Colors.Foreground.color
        }
    }
}

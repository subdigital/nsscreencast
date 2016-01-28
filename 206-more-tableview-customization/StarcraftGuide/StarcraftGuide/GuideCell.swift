//
//  GuideCell.swift
//  StarcraftGuide
//
//  Created by Ben Scheirman on 1/18/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class GuideCell : UITableViewCell {
    static let reuseIdentifier = "GuideCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Theme.Colors.Foreground.color
        nameLabel.font = Theme.Fonts.TitleFont.font
        nameLabel.textColor = Theme.Colors.LightTextColor.color
        
        separatorInset = UIEdgeInsetsZero
        layoutMargins = UIEdgeInsetsZero
    }
}

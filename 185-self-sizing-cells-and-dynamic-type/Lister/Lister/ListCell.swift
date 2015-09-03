//
//  ListCell.swift
//  Lister
//
//  Created by Ben Scheirman on 8/30/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit

class ListCell : UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var numberOfItemsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForDynamicType()
        NSNotificationCenter.defaultCenter().addObserverForName(UIContentSizeCategoryDidChangeNotification, object: nil, queue: NSOperationQueue.mainQueue()) { _ in
            self.prepareForDynamicType()
        }
    }
    
    func prepareForDynamicType() {
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        numberOfItemsLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
    }
}

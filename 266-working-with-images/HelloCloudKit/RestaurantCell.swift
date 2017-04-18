//
//  RestaurantCell.swift
//  HelloCloudKit
//
//  Created by Ben Scheirman on 3/28/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit

class RestaurantCell : UITableViewCell {
    
    let ImageViewWidth: CGFloat = 84
    let LabelPadding: CGFloat = 10
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let imageView = self.imageView,
              let textLabel = self.textLabel
            else { return }
        
        var frame = imageView.frame
        frame.size.width = ImageViewWidth
        imageView.frame = frame
        
        textLabel.frame.origin.x = imageView.frame.origin.x + imageView.frame.size.width + LabelPadding
        detailTextLabel?.frame.origin.x = textLabel.frame.origin.x
    }
    
    
}

//
//  ReviewCell.swift
//  HelloCloudKit
//
//  Created by Ben Scheirman on 3/29/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit
import HCSStarRatingView

class ReviewCell : UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.bounds.size.width / 2
        userImageView.clipsToBounds = true
        userImageView.layer.borderColor = UIColor(white: 0.86, alpha: 1.0).cgColor
        userImageView.layer.borderWidth = 1
    }
}

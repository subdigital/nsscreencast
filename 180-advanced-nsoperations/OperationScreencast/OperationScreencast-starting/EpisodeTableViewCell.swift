//
//  EpisodeTableViewCell.swift
//  OperationScreencast
//
//  Created by Ben Scheirman on 7/21/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit

class EpisodeTableViewCell : UITableViewCell {
 
    @IBOutlet var artworkImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artworkImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
}

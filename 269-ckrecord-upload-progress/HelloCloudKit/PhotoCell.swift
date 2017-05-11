//
//  PhotoCell.swift
//  HelloCloudKit
//
//  Created by Ben Scheirman on 4/19/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit

class PhotoCell : UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}


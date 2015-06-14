//
//  ImageCell.swift
//  MagicMove
//
//  Created by Ben Scheirman on 6/2/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit

class ImageViewCell : UICollectionViewCell {
    @IBOutlet var imageView: FKBRemoteImageView!

    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.fkb_cancelImageLoad()
        imageView.image = nil
    }
}

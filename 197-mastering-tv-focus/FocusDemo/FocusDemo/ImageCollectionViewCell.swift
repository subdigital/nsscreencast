//
//  ImageCollectionViewCell.swift
//  FocusDemo
//
//  Created by Ben Scheirman on 11/13/15.
//  Copyright © 2015 NSScreencast. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.adjustsImageWhenAncestorFocused = true
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        var color: UIColor!
        var transform: CGAffineTransform!
        var font: UIFont!
        
        if context.previouslyFocusedView == self {
            color = UIColor.blackColor()
            transform = CGAffineTransformIdentity
            font = UIFont.systemFontOfSize(16)
        } else {
            color = UIColor.whiteColor()
            transform = CGAffineTransformMakeTranslation(0, 40)
            font = UIFont.boldSystemFontOfSize(24)
        }
        
        coordinator.addCoordinatedAnimations({
            self.label.transform = transform
            self.label.textColor = color
            self.label.font = font
        }, completion: nil)
    }
}

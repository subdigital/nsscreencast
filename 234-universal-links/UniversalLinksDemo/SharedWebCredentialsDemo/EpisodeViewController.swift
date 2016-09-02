//
//  EpisodeViewController.swift
//  SharedWebCredentialsDemo
//
//  Created by Ben Scheirman on 8/31/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class EpisodeViewController : UIViewController {
    let episode: Episode
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        return imageView
    }()
    
    lazy var descriptionLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(descLabel)
        return descLabel
    }()
    
    init(episode: Episode) {
        self.episode = episode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteColor()
        
        title = episode.title
        
        
        NSLayoutConstraint.activateConstraints([
            imageView.widthAnchor.constraintEqualToConstant(200),
            imageView.heightAnchor.constraintEqualToConstant(120),
            imageView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 100),
            imageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
            ])
        
        descriptionLabel.font = UIFont.systemFontOfSize(16)
        descriptionLabel.textColor = .lightGrayColor()
        descriptionLabel.textAlignment = .Center
        descriptionLabel.numberOfLines = 0
        
        NSLayoutConstraint.activateConstraints([
            descriptionLabel.topAnchor.constraintEqualToAnchor(imageView.bottomAnchor, constant: 40),
            descriptionLabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 40),
            descriptionLabel.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -40)
        ])
        
        imageView.sd_setImageWithURL(episode.imageURL)
        descriptionLabel.text = episode.desc
    }
}

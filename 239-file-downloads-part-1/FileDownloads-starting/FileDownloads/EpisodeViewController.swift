//
//  EpisodeViewController.swift
//  FileDownloads
//
//  Created by Ben Scheirman on 10/5/16.
//  Copyright © 2016 Fickle Bits, LLC. All rights reserved.
//

import UIKit

class EpisodeViewController : UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var episode: Episode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = episode.title
        
        if let imageURL = episode.thumbnailURL {
            if let image = ImageCache.shared.image(forURL: imageURL) {
                imageView.image = image
            } else {
                URLSession.shared.dataTask(with: imageURL) {
                    data, response, error in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }
}

//
//  EpisodeCell.swift
//  FileDownloads
//
//  Created by Ben Scheirman on 10/5/16.
//  Copyright © 2016 Fickle Bits, LLC. All rights reserved.
//

import UIKit

class EpisodeCell : UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    var session: URLSession {
        return URLSession.shared
    }
    var imageTask: URLSessionDataTask?
    
    func loadImage(url: URL) {
        imageTask?.cancel()
        
        if let image = ImageCache.shared.image(forURL: url) {
            self.artworkImageView.image = image
        } else {
            imageTask = session.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    let image = UIImage(data: data)!
                    DispatchQueue.main.async {
                        ImageCache.shared.set(image: image, url: url)
                        self.artworkImageView.image = image
                    }
                }
            }
            imageTask?.resume()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        artworkImageView.image = nil
        label.text = nil
    }
}


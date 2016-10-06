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
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var episode: Episode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.isHidden = true
        progressLabel.isHidden = true
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(EpisodeViewController.onDownloadProgress(notification:)), name: .downloadProgress, object: nil)
    }
    
    func onDownloadProgress(notification: Notification) {
        
        guard let progress = notification.userInfo?["progress"] as? Float,
            let id = notification.userInfo?["episodeID"] as? Int,
            id == Int(episode.id)
            else {
            return
        }
        
        let formattedProgress = String(format: "%.1f%%", progress * 100.0)
        progressLabel.text = formattedProgress
        progressView.progress = progress
    }
    
    @IBAction func downloadTapped(_ sender: AnyObject) {
        DownloadController.shared.download(episode: episode)
        
        progressView.progress = 0
        progressView.isHidden = false
        progressLabel.text = ""
        progressLabel.isHidden = false
        
        downloadButton.isEnabled = false
    }
}

//
//  EpisodesViewController.swift
//  SharedWebCredentialsDemo
//
//  Created by Ben Scheirman on 8/30/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit
import SDWebImage

class EpisodesViewController : UITableViewController {
    
    let episodes: [Episode] = SampleEpisodes
    let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episodes"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 60
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        let episode = episodes[indexPath.row]
        cell.textLabel?.text = episode.title
        cell.imageView?.sd_setImageWithURL(episode.imageURL, completed: { (img, error, cacheType, url) in
            cell.imageView?.image = img
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        })
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let episode = episodes[indexPath.row]
        
        let episodeVC = EpisodeViewController(episode: episode)
        navigationController?.pushViewController(episodeVC, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

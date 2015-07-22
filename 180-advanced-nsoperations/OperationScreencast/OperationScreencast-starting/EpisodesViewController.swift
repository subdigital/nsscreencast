//
//  EpisodesViewController.swift
//  OperationScreencast
//
//  Created by Ben Scheirman on 7/21/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit
import CoreData
import JMImageCache

class EpisodesViewController : UITableViewController, NSFetchedResultsControllerDelegate {
    
    var context: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController?
    let operationQueue = NSOperationQueue()
    var loadModelOperation: LoadDataModelOperation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        
        loadModel()
    }
    
    func loadModel() {
        // TODO
    }
    
    func login() {
        // TODO
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionInfo = fetchedResultsController?.sections?[section] as? NSFetchedResultsSectionInfo {
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EpisodeTableViewCell") as! EpisodeTableViewCell
        
        let episode = fetchedResultsController!.objectAtIndexPath(indexPath) as! Episode
        cell.titleLabel.text = episode.title
        cell.subtitleLabel.text = "\(episode.episodeNumber)"
        cell.artworkImageView.setImageWithURL(NSURL(string: episode.artworkUrl)!)
        
        return cell
    }
    
    private func loadEpisodes() {
        println("Fetching episodes from local store...")
        let fetchRequest = NSFetchRequest(entityName: "Episode")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "episodeNumber", ascending: false)]
        fetchRequest.fetchBatchSize = 100
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController!.delegate = self
        if !fetchedResultsController!.performFetch(nil) {
            println("Error fetching episodes")
        }
        tableView.reloadData()
    }
    
    func refresh() {
        refreshControl?.beginRefreshing()
        let cachesDir = NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: nil)!
        
        let path = cachesDir.URLByAppendingPathComponent("episodes.json").path!
        let downloadEpisodesOperation = DownloadEpisodesOperation(path: path, context: context!)
        downloadEpisodesOperation.completionBlock = { [weak self] in
            dispatch_async(dispatch_get_main_queue()) {
                self?.refreshControl?.endRefreshing()
                if let error = downloadEpisodesOperation.error {
                    let alert = UIAlertController(title: "Error downloading episodes", message: error.localizedDescription, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Abort", style: .Cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Retry", style: .Default, handler: { action in
                        self?.refresh()
                    }))
                } else {
                    self?.loadEpisodes()
                }
            }
        }
        operationQueue.addOperation(downloadEpisodesOperation)
    }
    
    @IBAction func destroyState(sender: AnyObject) {
        AuthStore.instance.logout()
        fetchedResultsController = nil
        context = nil
        tableView.reloadData()
        
        if let storeURL = loadModelOperation?.storeURL {
            NSFileManager.defaultManager().removeItemAtURL(storeURL, error: nil)
        }
        
        loadModel()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
}

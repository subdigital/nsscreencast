//
//  ViewController.swift
//  CoreData10
//
//  Created by Ben Scheirman on 9/27/16.
//  Copyright © 2016 Fickle Bits, LLC. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

    var container: NSPersistentContainer?
    var fetchedResultsController: NSFetchedResultsController<Episode>?
    
    var progressValues: [Episode : Float] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Episodes"
        addObserver(self, forKeyPath: #keyPath(ViewController.container), options: [.initial, .new], context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.onDownloadProgress(notification:)), name: .downloadProgress, object: nil)
    }
    
    func onDownloadProgress(notification: NSNotification) {
        guard let episodeID = notification.userInfo?["episodeID"] as? Int,
            let progress = notification.userInfo?["progress"] as? Float else {
                return
        }
        
        guard let episode = getEpisode(byID: episodeID), let indexPath = indexPath(for: episode) else {
            return
        }
    
        progressValues[episode] = progress
        
        if tableView.indexPathsForVisibleRows?.contains(indexPath) == true {
            tableView.reloadRows(at: [indexPath], with: .none)
        } else {
            print("Row not visible")
        }
        
    }
    
    private func getEpisode(byID episodeID: Int) -> Episode? {
        return fetchedResultsController?.fetchedObjects?.filter({
            return $0.id == Int32(episodeID)
        }).first
    }
    
    private func indexPath(for episode: Episode) -> IndexPath? {
        return fetchedResultsController?.indexPath(forObject: episode)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(ViewController.container) {
            if container != nil {
                fetchEpisodes()
                loadFromCoreData()
            }
        }
    }

    func loadFromCoreData() {
        guard let context = container?.viewContext else { return }
        let fetchRequest: NSFetchRequest<Episode> = Episode.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "episodeType == %@", "free")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController?.delegate = self
        try? fetchedResultsController?.performFetch()
        tableView.reloadData()
    }

    func fetchEpisodes() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let apiClient = APIClient()
        apiClient.fetchEpisodes { result in

            switch result {
            case .error(let e):
                self.showAlert(title: "Error", message: e.localizedDescription)
            case .unexpectedResponse:
                self.showAlert(title: "Invalid response", message: "The server returned an invalid response")
            case .success(let episodes):
                self.importEpisodes(episodes)
            }

            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    func importEpisodes(_ episodes: [EpisodeResponse]) {

        print("importing \(episodes.count) episodes...")

        container!.performBackgroundTask { moc in
            
            let fetchRequest: NSFetchRequest<Episode> = Episode.fetchRequest()
            let existingEpisodes = try! fetchRequest.execute()
            
            let existingEpisodeLookup = existingEpisodes.reduce([:], { (lookup, episode) -> [Int:Episode] in
                var mutableLookup = lookup
                mutableLookup[Int(episode.id)] = episode
                return mutableLookup
            })
            
            episodes.forEach { jsonEpisode in
                let model = existingEpisodeLookup[jsonEpisode.id] ?? Episode(context: moc)
                model.id = Int32(jsonEpisode.id)
                model.title = jsonEpisode.title
                model.summary = jsonEpisode.summary
                model.thumbnailURLValue = jsonEpisode.thumbnailURLValue
                model.videoURLValue = jsonEpisode.videoURLValue
                model.episodeType = jsonEpisode.episodeType
            }
            print("saving context...")
            try! moc.save()
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell") as! EpisodeCell
        let episode = fetchedResultsController!.object(at: indexPath)
        cell.label.text = episode.title
        cell.loadImage(url: episode.thumbnailURL! as URL)
        cell.downloadStatusLabel.text = downloadStatus(for: episode)
        
        return cell
    }
    
    private func downloadStatus(for episode: Episode) -> String {
        guard let downloadInfo = episode.downloadInfo, let status = downloadInfo.status else { return "" }
        
        switch status {
        case .Downloading:
            let progress = progressValues[episode] ?? episode.downloadInfo?.progress ?? 0
            let formattedProgress = String(format: "%.1f%%", progress * 100.0)
            return "Downloading... \(formattedProgress)"
        case .Failed:
            return "Download failed"
        case .Paused:
            return "Download paused"
        case .Pending:
            return "Download pending"
        case .Completed:
            let formattedSize = ByteCountFormatter().string(fromByteCount: downloadInfo.sizeInBytes)
            return "📲 \(formattedSize)"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "episodeSegue" {
            let destination = segue.destination as! EpisodeViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destination.episode = fetchedResultsController?.object(at: indexPath)
            }
        }
    }
}

extension ViewController : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        loadFromCoreData()
    }
}


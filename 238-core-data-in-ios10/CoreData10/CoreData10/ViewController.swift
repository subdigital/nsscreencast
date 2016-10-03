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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Episodes"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        addObserver(self, forKeyPath: #keyPath(ViewController.container), options: [.initial, .new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(ViewController.container) {
        
            if container != nil {
                fetchEpisodes()
                loadFromCoreData()
            }
            
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func loadFromCoreData() {
        guard let context = container?.viewContext else { return }
        let fetchRequest : NSFetchRequest<Episode> = Episode.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController?.delegate = self
        try! fetchedResultsController?.performFetch()
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
        print("importing \(episodes.count) records")
        container?.performBackgroundTask { moc in
            
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
            }
            
            print("Saving context...")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let episode = fetchedResultsController!.object(at: indexPath)
        cell.textLabel?.text = episode.title
        return cell
    }
}


extension ViewController : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        loadFromCoreData()
    }
}


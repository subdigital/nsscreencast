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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Episodes"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
        // return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
//        let episode = fetchedResultsController!.object(at: indexPath)
//        cell.textLabel?.text = episode.title
        return cell
    }
}




//extension ViewController : NSFetchedResultsControllerDelegate {
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        loadFromCoreData()
//    }
//}


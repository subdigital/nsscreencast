//
//  ViewController.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/15/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit

protocol FoldersCoordinationDelegate : class {
    func addTapped(from: FoldersViewController)
    func didSelect(folder: Folder, from: FoldersViewController)
    func didDelete(folder: Folder, at indexPath: IndexPath, from: FoldersViewController)
}

final class FoldersViewController: UITableViewController, StoryboardInitializable, DatasourceDelegate {

    weak var coordinationDelegate: FoldersCoordinationDelegate?
    var foldersDatasource: FoldersDatasource! {
        didSet {
            foldersDatasource.delegate = self
        }
    }
    
    let FolderCell = "FolderCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFolders()
    }
    
    private func fetchFolders() {
        foldersDatasource.fetchFolders { result in
            switch result {
            case .success(_):
                self.tableView.reloadData()
                
            case .error(let e):
                print(e)
                self.displayError(message: "Could not load folders.")
            }
        }
    }

    @IBAction func addTapped(_ sender: Any) {
        coordinationDelegate?.addTapped(from: self)
    }
    
    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foldersDatasource.objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FolderCell, for: indexPath)
        let folder = foldersDatasource.object(at: indexPath)
        cell.textLabel?.text = folder.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let folder = foldersDatasource.object(at: indexPath)
        
        switch editingStyle {
        case .delete:
            coordinationDelegate?.didDelete(folder: folder, at: indexPath, from: self)
            
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folder = foldersDatasource.object(at: indexPath)
        coordinationDelegate?.didSelect(folder: folder, from: self)
    }
}

    

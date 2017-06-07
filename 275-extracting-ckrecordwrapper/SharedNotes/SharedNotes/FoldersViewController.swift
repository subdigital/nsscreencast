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
}

final class FoldersViewController: UITableViewController, StoryboardInitializable {

    weak var coordinationDelegate: FoldersCoordinationDelegate?
    var foldersDatasource: FoldersDatasource!
    var notesManager: NotesManager!
    
    let FolderCell = "FolderCell"
    let FolderSegue = "folderSegue"
    
    var folders: [Folder] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFolders()
    }
    
    private func fetchFolders() {
        foldersDatasource.fetchFolders { result in
            switch result {
            case .success(let folders):
                self.folders = folders
                self.tableView.reloadData()
                
            case .error(let e):
                print(e)
                self.displayError(message: "Could not load folders.")
            }
        }
    }

    @IBAction func addTapped(_ sender: Any) {
        promptForValue(title: "New Folder", message: nil, placeholder: "Name", buttonTitle: "Add") { (name) in
            let folder = self.notesManager.newFolder(name: name ?? "<unnamed>")
            self.save(folder)
        }
    }
    
    private func save(_ folder: Folder) {
        notesManager.save(folder: folder) { (result) in
            switch result {
            case .success(let folder):
                self.folders.insert(folder, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            case .error(let e):
                print(e)
                self.displayError(message: "Folder could not be added.")
            }
        }
    }
    
    // MARK: - Segues
    
    private func prepareFolderSegue(destination: NotesListViewController) {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("No folder selected")
        }
        let folder = folders[indexPath.row]
        destination.folder = folder
    }
    
    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FolderCell, for: indexPath)
        let folder = folders[indexPath.row]
        cell.textLabel?.text = folder.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let folder = folders[indexPath.row]
        switch editingStyle {
        case .delete:
            notesManager.delete(folder: folder) { result in
                switch result {
                    
                case .success(_):
                    
                    self.folders.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    
                case .error(let e):
                    
                    print(e)
                    self.displayError(message: "Error deleting folder.")
                    
                }
            }
            
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folder = folders[indexPath.row]
        coordinationDelegate?.didSelect(folder: folder, from: self)
    }
}

    

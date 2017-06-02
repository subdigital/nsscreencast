//
//  AppCoordinator.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/23/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator {
    
    let window: UIWindow
    var root: UINavigationController!
    
    let notesManager: NotesManager
    
    init(window: UIWindow, defaults: UserDefaults = .standard) {
        self.window = window
        notesManager = CloudKitNotesManager.sharedInstance
    }
    
    func createDefaultFolderIfNeeded(completion: @escaping () -> Void) {
        guard !type(of: notesManager).hasCreatedDefaultFolder else {
            completion()
            return
        }
        
        window.rootViewController = InitialSetupViewController()
        notesManager.createDefaultFolder { result in
            DispatchQueue.main.async {
                if case let .error(e) = result {
                    print(e)
                    self.window.rootViewController?.displayError(message: "Could not create default folder.")
                } else {
                    completion()
                }
            }
        }
    }
    
    func transitionRoot(to vc: UIViewController) {
        guard window.rootViewController != nil else {
            window.rootViewController = vc
            return
        }
        
        let overlayView = UIScreen.main.snapshotView(afterScreenUpdates: false)
        vc.view.addSubview(overlayView)
        window.rootViewController = vc
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .transitionCrossDissolve, animations: {
            overlayView.alpha = 0
        }, completion: { finished in
            overlayView.removeFromSuperview()
        })
    }
    
    func start() {
        let foldersVC = FoldersViewController.makeFromStoryboard()
        foldersVC.foldersDatasource = FoldersDatasource(noteManager: notesManager)
        foldersVC.coordinationDelegate = self
        root = foldersVC.wrapWithNavigationController()
        
        createDefaultFolderIfNeeded {
            self.transitionRoot(to: self.root)
        }
        
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator : FoldersCoordinationDelegate {
    func didSelect(folder: Folder, from: FoldersViewController) {
        print("didSelect(folder: \(folder.name))")
        
        let noteListVC = NotesListViewController.makeFromStoryboard()
        noteListVC.coordinationDelegate = self
        noteListVC.notesDatasource = NotesDatasource(parent: folder, noteManager: notesManager)
        noteListVC.folder = folder
        
        root.pushViewController(noteListVC, animated: true)
    }
    
    func addTapped(from vc: FoldersViewController) {
        vc.promptForValue(title: "New Folder", message: nil, placeholder: "Name", buttonTitle: "Add") { (name) in
            let folder = self.notesManager.newFolder(name: name ?? "<unnamed>")
            self.notesManager.save(folder: folder) { (result) in
                switch result {
                case .success(let folder):
                    vc.foldersDatasource.add(object: folder)
                case .error(let e):
                    print(e)
                    vc.displayError(message: "Folder could not be added.")
                }
            }
        }
    }
    
    func didDelete(folder: Folder, at indexPath: IndexPath, from vc: FoldersViewController) {
        notesManager.delete(folder: folder) { result in
            switch result {
            case .success(_):
                vc.foldersDatasource.delete(at: indexPath.row)
            case .error(let e):
                print(e)
                DispatchQueue.main.async {
                    vc.displayError(message: "Error deleting folder.")
                }
            }
        }
    }
}

extension AppCoordinator : NoteListCoordinationDelegate {
    func didSelect(note: Note, from: NotesListViewController) {
        let noteVC = NoteViewController.makeFromStoryboard()
        noteVC.notesManager = notesManager
        noteVC.note = note
        
        root.pushViewController(noteVC, animated: true)
    }
    
    func newNoteTapped(from noteListVC: NotesListViewController) {
        let folder = noteListVC.folder!
        let note = notesManager.newNote(in: folder)
        
        self.notesManager.save(note: note) { (result) in
            switch result {
            case .success(let note):
                DispatchQueue.main.async {
                    let indexPath = noteListVC.notesDatasource.insert(object: note, at: 0)
                    noteListVC.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
                    self.didSelect(note: note, from: noteListVC)
                }
                
            case .error(let e):
                print(e)
                DispatchQueue.main.async {
                    noteListVC.displayError(message: "Folder could not be added.")
                }
            }
        }
    }
}

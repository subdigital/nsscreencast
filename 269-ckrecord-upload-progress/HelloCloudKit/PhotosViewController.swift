//
//  PhotosViewController.swift
//  HelloCloudKit
//
//  Created by Ben Scheirman on 4/5/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit
import CloudKit

class PhotosViewController : UICollectionViewController {
    
    var restaurantID: CKRecordID!
    let database = CKContainer.default().publicCloudDatabase
    
    static func makeFromStoryboard() -> PhotosViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! PhotosViewController
    }
    
    var photos: [CKRecord] = []
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
        return spinner
    }()

    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 150),
            progressView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            progressView.topAnchor.constraint(equalTo: self.spinner.bottomAnchor, constant: 30)
        ])
        return progressView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionViewLayout()
        
        loadPhotos()
    }

    private func setupCollectionViewLayout() {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let sectionPadding: CGFloat = 10
        let interItemSpacing = layout.minimumInteritemSpacing
        let screenWidth = view.frame.size.width
        let itemsPerRow: CGFloat = 3
        let itemSize = (screenWidth - 2*sectionPadding -
            (itemsPerRow-1)*interItemSpacing) / itemsPerRow
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
    }
    
    private func loadPhotos(cursor: CKQueryCursor? = nil) {
        spinner.startAnimating()
        
        let operation: CKQueryOperation
        
        if let c = cursor {
            operation = CKQueryOperation(cursor: c)
        } else {
        
            let predicate = NSPredicate(format: "restaurant == %@", CKReference(recordID: restaurantID, action: .deleteSelf))
            let query = CKQuery(recordType: Photo.recordType, predicate: predicate)
            query.sortDescriptors = [
                NSSortDescriptor(key: "creationDate", ascending: false)
            ]
        
            operation = CKQueryOperation(query: query)
        }
        
        operation.desiredKeys = ["thumbnail"]
        operation.resultsLimit = 12
        
        operation.recordFetchedBlock = { record in
            self.photos.append(record)
            DispatchQueue.main.sync {
                let indexPath = IndexPath(item: self.photos.count - 1, section: 0)
                self.collectionView?.insertItems(at: [indexPath])
            }
        }
        
        let database = CKContainer.default().publicCloudDatabase
        operation.queryCompletionBlock = { cursor, error in
            if let e = error {
                print("Error fetching photos: \(e)")
            } else if let c = cursor {
                
                self.loadPhotos(cursor: c)
                
                print("Fetch more results...")
            } else {
                print("Done!")
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                }
            }
        }
        
        
        database.add(operation)
    }
    
    @IBAction func uploadPhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .savedPhotosAlbum
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let record = photos[indexPath.item]
        let asset = record["thumbnail"] as! CKAsset
        photoCell.imageView.image = asset.image
        return photoCell
    }
}

extension PhotosViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        dismiss(animated: true, completion: {
            self.spinner.startAnimating()
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.createPhoto(image: originalImage)
            }
        })
    }
    
    private func createPhoto(image: UIImage) {
        let thumbnail = ImageHelper.createThumbnail(from: image, fillingSize: CGSize(width: 200, height: 200))
        let photo = Photo(fullsizeImage: image, thumbnail: thumbnail, restaurantID: restaurantID)
        savePhoto(photo)
    }
    
    private func savePhoto(_ photo: Photo) {
        let modifyOp = CKModifyRecordsOperation(recordsToSave: [photo.record],
                                                recordIDsToDelete: nil)
        
        DispatchQueue.main.async {
            self.progressView.progress = 0
            UIView.animate(withDuration: 0.3) {
                self.progressView.alpha = 1
            }
        }
        
        modifyOp.perRecordProgressBlock = { record, progress in
            
            DispatchQueue.main.async {
                self.progressView.setProgress(Float(progress), animated: true)
            }
            
        }
        
        modifyOp.modifyRecordsCompletionBlock = { records, _, error in
            
            if let e = error {
                print("Error saving photo: \(e)")
            } else {
                self.prepend(photo: photo)
            }
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: [], animations: { 
                    self.progressView.alpha = 0
                }, completion: nil)
                self.spinner.stopAnimating()
            }
        }
        
        database.add(modifyOp)
    }
    
    private func prepend(photo: Photo) {
        photos.insert(photo.record, at: 0)
        DispatchQueue.main.async {
            self.collectionView?.insertItems(at: [IndexPath(item: 0, section: 0)])
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

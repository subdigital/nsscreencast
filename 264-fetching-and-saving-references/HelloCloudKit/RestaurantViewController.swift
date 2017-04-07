//
//  RestaurantViewController.swift
//  HelloCloudKit
//
//  Created by Ben Scheirman on 3/28/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit
import CloudKit

class RestaurantViewController : UITableViewController {
    
    enum Sections : Int {
        case info
        case reviews
        case count
    }
    
    var restaurant: Restaurant?
    var reviews: [Review] = []
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 64
        
        configureUI()
        loadReviews()
    }
    
    private func loadReviews() {
        Restaurants.reviews(for: restaurant!) { (reviews, error) in
            if let e = error {
                print("Error fetching reviews: \(e.localizedDescription)")
            } else {
                self.reviews = reviews
                self.tableView.reloadSections([Sections.reviews.rawValue], with: .none)
            }
        }
    }
    
    private func configureUI() {
        guard let restaurant = self.restaurant else { return }
        title = restaurant.name
        if let imageURL = restaurant.imageFileURL {
            let data = try! Data(contentsOf: imageURL)
            imageView.image = UIImage(data: data)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let restaurantID = restaurant?.recordID else { return }
        
        if segue.identifier == "addReviewSegue" {
            let destinationNav = segue.destination as! UINavigationController
            let destination = destinationNav.viewControllers.first as! ReviewViewController
            destination.addReviewBlock = { [weak self] vc in
                let review = Review(author: vc.nameTextField.text ?? "",
                                    comment: vc.commentTextView.text,
                                    rating: Float(vc.ratingView.value),
                                    restaurantID: restaurantID)
                Restaurants.add(review: review)
                self?.dismiss(animated: true, completion: {
                    self?.insertReview(review)
                })
            }
        }
    }
    
    private func insertReview(_ review: Review) {
        reviews.insert(review, at: 0)
        let indexPath = IndexPath(row: 0, section: Sections.reviews.rawValue)
        tableView.insertRows(at: [indexPath], with: .top)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.info.rawValue {
            return restaurant?.address == nil ? 0 : 1
        } else if section == Sections.reviews.rawValue {
            return reviews.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Sections.info.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell") as! AddressCell
            cell.addressLabel.text = restaurant?.address ?? ""
            return cell
        } else {
            let review = reviews[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
            cell.commentLabel.text = review.comment
            cell.authorLabel.text = review.authorName
            cell.ratingView.value = CGFloat(review.stars)
            return cell
        }
    }
}

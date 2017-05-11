//
//  AppCoordinator.swift
//  HelloCloudKit
//
//  Created by Ben Scheirman on 4/18/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit

class AppCoordinator : RestaurantsViewControllerDelegate, RestaurantViewControllerDelegate {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let restaurantsVC = navigationController.topViewController as! RestaurantsViewController
        restaurantsVC.delegate = self
    }
    
    func didSelect(restaurant: Restaurant) {
        let restaurantDetail = RestaurantViewController.makeFromStoryboard()
        restaurantDetail.restaurantDelegate = self
        restaurantDetail.restaurant = restaurant
        navigationController.pushViewController(restaurantDetail, animated: true)
    }
    
    func addReviewTapped(_ vc: RestaurantViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "AddReviewNavigationController") as! UINavigationController
        let reviewVC = nav.topViewController as! ReviewViewController
        reviewVC.addReviewBlock = { [weak self] rvc in
            let review = Review(author: rvc.nameTextField.text ?? "",
                                comment: rvc.commentTextView.text,
                                rating: Float(rvc.ratingView.value),
                                restaurantID: vc.restaurantID)
            Restaurants.add(review: review)
            self?.navigationController.dismiss(animated: true) {
                vc.insertReview(review)
            }
        }
    
        navigationController.present(nav, animated: true)
    }
    
    func photosTapped(_ vc: RestaurantViewController) {
        let photosVC = PhotosViewController.makeFromStoryboard()
        photosVC.restaurantID = vc.restaurantID
        navigationController.pushViewController(photosVC, animated: true)
    }
}

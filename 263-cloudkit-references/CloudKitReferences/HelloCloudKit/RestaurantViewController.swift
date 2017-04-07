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
        case count
    }
    
    var restaurant: Restaurant?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 64
        
        configureUI()
    }
    
    private func configureUI() {
        guard let restaurant = self.restaurant else { return }
        title = restaurant.name
        if let imageURL = restaurant.imageFileURL {
            let data = try! Data(contentsOf: imageURL)
            imageView.image = UIImage(data: data)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.info.rawValue {
            return restaurant?.address == nil ? 0 : 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Sections.info.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell") as! AddressCell
            cell.addressLabel.text = restaurant?.address ?? ""
            return cell
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
}

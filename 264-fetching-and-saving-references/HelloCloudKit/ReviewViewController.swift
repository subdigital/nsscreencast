//
//  ReviewViewController.swift
//  HelloCloudKit
//
//  Created by Ben Scheirman on 3/29/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit
import HCSStarRatingView

class ReviewViewController : UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var commentTextView: UITextView!
    
    var addReviewBlock: (ReviewViewController) -> () = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done() {
        addReviewBlock(self)
    }
}

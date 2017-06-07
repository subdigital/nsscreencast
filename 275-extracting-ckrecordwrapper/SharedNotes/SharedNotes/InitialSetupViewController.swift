//
//  InitialSetupViewController.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/31/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit

class InitialSetupViewController : UIViewController {
    
    var label: UILabel!
    var activityIndicator: UIActivityIndicatorView!
    
    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        
        label = UILabel(frame: view.frame)
        label.text = "Please wait"
        label.textAlignment = .center
        view.addSubview(label)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20)
        ])
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
    }
}

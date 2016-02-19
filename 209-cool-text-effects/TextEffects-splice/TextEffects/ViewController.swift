//
//  ViewController.swift
//  TextEffects
//
//  Created by Ben Scheirman on 2/15/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textEffectView: TextEffectView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textEffectView.font = UIFont(name: "SnellRoundhand-Black", size: 40)
        textEffectView.text = "Hello, CoreText!"
    }
}


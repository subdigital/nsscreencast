//
//  ViewController.swift
//  Ocean
//
//  Created by Sam Soffes on 7/1/15.
//  Copyright (c) 2015 Sam Soffes. All rights reserved.
//

import UIKit
import GradientView

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let gradient = GradientView()
		gradient.frame = view.bounds
		gradient.colors = [.cyanColor(), .blueColor()]
		view.addSubview(gradient)
	}
}


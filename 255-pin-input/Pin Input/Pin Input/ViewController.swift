//
//  ViewController.swift
//  Pin Input
//
//  Created by Sam Soffes on 1/22/17.
//  Copyright © 2017 Sam Soffes. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

	// MARK: - Properties

	let pinInput: PinInput = {
		let view = PinInput()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()


	// MARK: - UIViewController

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Pin Input"
		view.backgroundColor = .white

		pinInput.addTarget(self, action: #selector(pinFilled), for: .primaryActionTriggered)
		view.addSubview(pinInput)

		NSLayoutConstraint.activate([
			pinInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			pinInput.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		pinInput.becomeFirstResponder()
	}


	// MARK: - Actions

	@objc private func pinFilled() {
		print("Pin: \(pinInput.value)")
	}
}

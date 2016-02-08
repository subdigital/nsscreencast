//
//  ViewController.swift
//  TextExample
//
//  Created by Sam Soffes on 2/5/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	let textView: UITextView = {
		let textContainer = NSTextContainer()

		let layoutManager = NSLayoutManager()
		layoutManager.addTextContainer(textContainer)

		let textStorage = NSTextStorage()
		textStorage.addLayoutManager(layoutManager)

		let view = UITextView(frame: .zero, textContainer: textContainer)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(textView)

		NSLayoutConstraint.activateConstraints([
			textView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
			textView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
			textView.topAnchor.constraintEqualToAnchor(view.topAnchor),
			textView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
		])
	}
}

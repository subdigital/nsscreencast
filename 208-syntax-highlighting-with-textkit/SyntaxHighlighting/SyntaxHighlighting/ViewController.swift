//
//  ViewController.swift
//  SyntaxHighlighting
//
//  Created by Sam Soffes on 2/8/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	// MARK: - Properties

	let textView: UITextView = {
		let textStorage = SyntaxTextStorage()

		let layoutManager = NSLayoutManager()
		textStorage.addLayoutManager(layoutManager)

		let textContainer = NSTextContainer()
		layoutManager.addTextContainer(textContainer)

		let view = UITextView(frame: .zero, textContainer: textContainer)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()


	// MARK: - UIViewController

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Syntax Highlighting"

		view.addSubview(textView)

		NSLayoutConstraint.activateConstraints([
			textView.topAnchor.constraintEqualToAnchor(view.topAnchor),
			textView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
			textView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
			textView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
		])
	}
}

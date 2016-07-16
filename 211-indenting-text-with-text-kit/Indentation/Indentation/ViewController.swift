//
//  ViewController.swift
//  Indentation
//
//  Created by Sam Soffes on 2/17/16.
//  Copyright © 2016 Nothing Magical, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	// MARK: - Properties

	let textView: UITextView = {
		let textStorage = IndentationTextStorage()

		let layoutManager = NSLayoutManager()
		textStorage.addLayoutManager(layoutManager)

		let textContainer = IndentationTextContainer()
		layoutManager.addTextContainer(textContainer)

		let view = UITextView(frame: .zero, textContainer: textContainer)
		view.font = .systemFontOfSize(18)
		return view
	}()


	// MARK: - UIViewController

	override func loadView() {
		view = textView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Indentation"
	}
}

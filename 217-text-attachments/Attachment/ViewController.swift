//
//  ViewController.swift
//  Attachment
//
//  Created by Sam Soffes on 4/4/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	// MARK: - Properties

	let textView = UITextView()


	// MARK: - UIViewController

	override func loadView() {
		view = textView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Attachment"

		let attachmentCharacter = String(Character(UnicodeScalar(NSAttachmentCharacter)))
		let text = NSMutableAttributedString(string: "This is our image:\n\n\(attachmentCharacter)\n\nAfter the image.", attributes: [
			NSFontAttributeName: UIFont.systemFontOfSize(18)
		])

		let attachment = NSTextAttachment()
		attachment.image = UIImage(named: "Photo")
		text.addAttribute(NSAttachmentAttributeName, value: attachment, range: NSRange(location: 20, length: 1))

		textView.attributedText = text
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		let textRange = NSRange(location: 0, length: textView.attributedText.length)
		textView.attributedText.enumerateAttribute(NSAttachmentAttributeName, inRange: textRange, options: []) { [weak self] value, range, _ in
			guard let attachment = value as? NSTextAttachment else { return }

			if let bounds = self?.boundsForAttachment(attachment), layoutManger = self?.textView.layoutManager {
				attachment.bounds = bounds

				let invalidRange = NSRange(location: range.location, length: textRange.length - range.location)
				layoutManger.invalidateLayoutForCharacterRange(invalidRange, actualCharacterRange: nil)
			}
		}
	}


	// MARK: - Private

	private func boundsForAttachment(attachment: NSTextAttachment) -> CGRect? {
		guard let image = attachment.image else { return nil }

		// Assuming landscape
		let width = textView.textContainer.size.width - (textView.textContainer.lineFragmentPadding * 2)
		return CGRect(x: 0, y: 0, width: width, height: image.size.height / image.size.width * width)
	}
}

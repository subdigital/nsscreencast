//
//  SyntaxTextStorage.swift
//  SyntaxHighlighting
//
//  Created by Sam Soffes on 2/8/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import UIKit

class SyntaxTextStorage: BaseTextStorage {
	override func processEditing() {
		let text = string as NSString

		setAttributes([
			NSFontAttributeName: UIFont.systemFontOfSize(18)
		], range: NSRange(location: 0, length: length))

		text.enumerateSubstringsInRange(NSRange(location: 0, length: length), options: .ByWords) { [weak self] string, range, _, _ in
			guard let string = string else { return }
			if string.lowercaseString == "red" {
				self?.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: range)
			} else if string.lowercaseString == "bold" {
				self?.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(18), range: range)
			}
		}

		super.processEditing()
	}
}

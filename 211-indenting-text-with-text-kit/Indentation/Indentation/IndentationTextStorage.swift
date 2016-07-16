//
//  IndentationTextStorage.swift
//  Indentation
//
//  Created by Sam Soffes on 2/17/16.
//  Copyright © 2016 Nothing Magical, Inc. All rights reserved.
//

import UIKit

class IndentationTextStorage: BaseTextStorage {

	static let indentationAttributeName = "IndentationTextStorage.indentationAttribute"

	override func processEditing() {
		super.processEditing()

		let text = string as NSString
		let bounds = NSRange(location: 0, length: text.length)

		let attributeName = self.dynamicType.indentationAttributeName

		// Reset
		removeAttribute(attributeName, range: bounds)

		// Loop through lines
		text.enumerateSubstringsInRange(bounds, options: .ByLines) { [weak self] substring, range, _, _ in
			guard let line = substring else { return }

			// Add custom attribute
			if line.hasPrefix("- ") {
				self?.addAttribute(attributeName, value: 1, range: range)
			}
		}

		dispatch_async(dispatch_get_main_queue()) { [weak self] in
			self?.layoutManagers.forEach { $0.invalidateLayoutForCharacterRange(bounds, actualCharacterRange: nil) }
		}
	}
}

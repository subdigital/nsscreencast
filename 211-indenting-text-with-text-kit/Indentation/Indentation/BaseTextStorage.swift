//
//  BaseTextStorage.swift
//  Indentation
//
//  Created by Sam Soffes on 2/17/16.
//  Copyright © 2016 Nothing Magical, Inc. All rights reserved.
//

import UIKit

class BaseTextStorage: NSTextStorage {

	// MARK: - Properties

	private let storage = NSMutableAttributedString()


	// MARK: - NSTextStorage

	override var string: String {
		return storage.string
	}

	override func attributesAtIndex(location: Int, effectiveRange: NSRangePointer) -> [String : AnyObject] {
		return storage.attributesAtIndex(location, effectiveRange: effectiveRange)
	}

	override func replaceCharactersInRange(range: NSRange, withString string: String) {
		let beforeLength = length
		storage.replaceCharactersInRange(range, withString: string)
		edited(.EditedCharacters, range: range, changeInLength: length - beforeLength)

	}

	override func setAttributes(attributes: [String : AnyObject]?, range: NSRange) {
		storage.setAttributes(attributes, range: range)
		edited(.EditedAttributes, range: range, changeInLength: 0)
	}
}

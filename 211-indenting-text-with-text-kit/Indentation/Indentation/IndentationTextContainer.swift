//
//  IndentationTextContainer.swift
//  Indentation
//
//  Created by Sam Soffes on 2/17/16.
//  Copyright © 2016 Nothing Magical, Inc. All rights reserved.
//

import UIKit

class IndentationTextContainer: NSTextContainer {
	override func lineFragmentRectForProposedRect(proposedRect: CGRect, atIndex characterIndex: Int, writingDirection: NSWritingDirection, remainingRect: UnsafeMutablePointer<CGRect>) -> CGRect {
		var rect = proposedRect

		if let textStorage = layoutManager?.textStorage where characterIndex < textStorage.length {
			let attributeName = IndentationTextStorage.indentationAttributeName

			if let value = textStorage.attribute(attributeName, atIndex: characterIndex, effectiveRange: nil) as? Int where value == 1 {
				rect.origin.x += 40
				rect.size.width -= 40
			}
		}

		return super.lineFragmentRectForProposedRect(rect, atIndex: characterIndex, writingDirection: writingDirection, remainingRect: remainingRect)
	}
}

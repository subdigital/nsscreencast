//
//  GradientView.swift
//  Gradient View
//
//  Created by Sam Soffes on 10/27/09.
//  Copyright (c) 2009-2014 Sam Soffes. All rights reserved.
//

import UIKit

/// Simple view for drawing gradients and borders.
public class GradientView: UIView {

	// MARK: - Types

	/// The mode of the gradient.
	public enum Type {
		/// A linear gradient.
		case Linear

		/// A radial gradient.
		case Radial
	}


	/// The direction of the gradient.
	public enum Direction {
		/// The gradient is vertical.
		case Vertical

		/// The gradient is horizontal
		case Horizontal
	}


	// MARK: - Properties

	/// An optional array of `UIColor` objects used to draw the gradient. If the value is `nil`, the `backgroundColor`
	/// will be drawn instead of a gradient. The default is `nil`.
	public var colors: [UIColor]? {
		didSet {
			updateGradient()
		}
	}

	/// An array of `UIColor` objects used to draw the dimmed gradient. If the value is `nil`, `colors` will be
	/// converted to grayscale. This will use the same `locations` as `colors`. If length of arrays don't match, bad
	/// things will happen. You must make sure the number of dimmed colors equals the number of regular colors.
	///
	/// The default is `nil`.
	public var dimmedColors: [UIColor]? {
		didSet {
			updateGradient()
		}
	}

	/// Automatically dim gradient colors when prompted by the system (i.e. when an alert is shown).
	///
	/// The default is `true`.
	public var automaticallyDims: Bool = true

	/// An optional array of `CGFloat`s defining the location of each gradient stop.
	///
	/// The gradient stops are specified as values between `0` and `1`. The values must be monotonically increasing. If
	/// `nil`, the stops are spread uniformly across the range.
	///
	/// Defaults to `nil`.
	public var locations: [CGFloat]? {
		didSet {
			updateGradient()
		}
	}

	/// The mode of the gradient. The default is `.Linear`.
	public var mode: Type = .Linear {
		didSet {
			setNeedsDisplay()
		}
	}

	/// The direction of the gradient. Only valid for the `Mode.Linear` mode. The default is `.Vertical`.
	public var direction: Direction = .Vertical {
		didSet {
			setNeedsDisplay()
		}
	}

	/// 1px borders will be drawn instead of 1pt borders. The default is `true`.
	public var drawsThinBorders: Bool = true {
		didSet {
			setNeedsDisplay()
		}
	}

	/// The top border color. The default is `nil`.
	public var topBorderColor: UIColor? {
		didSet {
			setNeedsDisplay()
		}
	}

	/// The right border color. The default is `nil`.
	public var rightBorderColor: UIColor? {
		didSet {
			setNeedsDisplay()
		}
	}

	///  The bottom border color. The default is `nil`.
	public var bottomBorderColor: UIColor? {
		didSet {
			setNeedsDisplay()
		}
	}

	/// The left border color. The default is `nil`.
	public var leftBorderColor: UIColor? {
		didSet {
			setNeedsDisplay()
		}
	}


	// MARK: - UIView

	override public func drawRect(rect: CGRect) {
		let context = UIGraphicsGetCurrentContext()
		let size = bounds.size

		// Gradient
		if let gradient = gradient {
			let options = CGGradientDrawingOptions(kCGGradientDrawsAfterEndLocation)

			if mode == .Linear {
				let startPoint = CGPointZero
				let endPoint = direction == .Vertical ? CGPoint(x: 0, y: size.height) : CGPoint(x: size.width, y: 0)
				CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, options)
			} else {
				let center = CGPoint(x: bounds.midX, y: bounds.midY)
				CGContextDrawRadialGradient(context, gradient, center, 0, center, min(size.width, size.height) / 2, options)
			}
		}

		let screen: UIScreen = window?.screen ?? UIScreen.mainScreen()
		let borderWidth: CGFloat = drawsThinBorders ? 1.0 / screen.scale : 1.0

		// Top border
		if let color = topBorderColor {
			CGContextSetFillColorWithColor(context, color.CGColor);
			CGContextFillRect(context, CGRect(x: 0, y: 0, width: size.width, height: borderWidth))
		}

		let sideY: CGFloat = topBorderColor != nil ? borderWidth : 0
		let sideHeight: CGFloat = size.height - sideY - (bottomBorderColor != nil ? borderWidth : 0)

		// Right border
		if let color = rightBorderColor {
			CGContextSetFillColorWithColor(context, color.CGColor);
			CGContextFillRect(context, CGRect(x: size.width - borderWidth, y: sideY, width: borderWidth, height: sideHeight))
		}

		// Bottom border
		if let color = bottomBorderColor {
			CGContextSetFillColorWithColor(context, color.CGColor);
			CGContextFillRect(context, CGRect(x: 0, y: size.height - borderWidth, width: size.width, height: borderWidth))
		}

		// Left border
		if let color = leftBorderColor {
			CGContextSetFillColorWithColor(context, color.CGColor);
			CGContextFillRect(context, CGRect(x: 0, y: sideY, width: borderWidth, height: sideHeight))
		}
	}

	override public func tintColorDidChange() {
		super.tintColorDidChange()

		if automaticallyDims {
			updateGradient()
		}
	}

	override public func didMoveToWindow() {
		super.didMoveToWindow()
		contentMode = .Redraw
	}


	// MARK: - Private

	private var gradient: CGGradientRef?

	private func updateGradient() {
		gradient = nil
		setNeedsDisplay()

		let colors = gradientColors()
		if let colors = colors {
			let colorSpace = CGColorSpaceCreateDeviceRGB()
			let colorSpaceModel = CGColorSpaceGetModel(colorSpace)

			let gradientColors: NSArray = colors.map { (color: UIColor) -> AnyObject! in
				let cgColor = color.CGColor
				let cgColorSpace = CGColorGetColorSpace(cgColor)

				// The color's color space is RGB, simply add it.
				if CGColorSpaceGetModel(cgColorSpace).value == colorSpaceModel.value {
					return cgColor as AnyObject!
				}

				// Convert to RGB. There may be a more efficient way to do this.
				var red: CGFloat = 0
				var blue: CGFloat = 0
				var green: CGFloat = 0
				var alpha: CGFloat = 0
				color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
				return UIColor(red: red, green: green, blue: blue, alpha: alpha).CGColor as AnyObject!
			}

			// TODO: This is ugly. Surely there is a way to make this more concise.
			if let locations = locations {
				gradient = CGGradientCreateWithColors(colorSpace, gradientColors, locations)
			} else {
				gradient = CGGradientCreateWithColors(colorSpace, gradientColors, nil)
			}
		}
	}

	private func gradientColors() -> [UIColor]? {
		if tintAdjustmentMode == .Dimmed {
			if let dimmedColors = dimmedColors {
				return dimmedColors
			}

			if automaticallyDims {
				if let colors = colors {
					return colors.map {
						var hue: CGFloat = 0
						var brightness: CGFloat = 0
						var alpha: CGFloat = 0

						$0.getHue(&hue, saturation: nil, brightness: &brightness, alpha: &alpha)

						return UIColor(hue: hue, saturation: 0, brightness: brightness, alpha: alpha)
					}
				}
			}
		}

		return colors
	}
}

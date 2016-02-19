//
//  TextEffectView.swift
//  TextEffects
//
//  Created by Ben Scheirman on 2/15/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit
import CoreText

public class TextEffectView: UIView {
    
    // MARK: Public properties
    
    public var font: UIFont! {
        didSet {
            createGlyphLayers()
            setNeedsDisplay()
        }
    }
    
    public var text: String?{
        didSet {
            createGlyphLayers()
            setNeedsDisplay()
        }
    }
        
    public var textColor: UIColor! {
        didSet {
            createGlyphLayers()
            setNeedsDisplay()
        }
    }
    
    // MARK: Private properties
    private var lineRects: [CGRect]!
    private var letterPaths: [UIBezierPath]!
    private var letterPositions: [CGPoint]!

    
    // MARK: Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
        
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDefaults()
    }
    
    func setupDefaults() {
        font = UIFont.systemFontOfSize(14)
        textColor = UIColor.blackColor()
    }
    
    // MARK: Drawing
    
    func createGlyphLayers() {
        assert(NSThread.isMainThread())
        guard let text = self.text else { return }
        
        if let sublayers = self.layer.sublayers {
            for sublayer in sublayers {
                sublayer.removeAllAnimations()
                sublayer.removeFromSuperlayer()
            }
        }
        
        let ctFont = CTFontCreateWithName(font.fontName, font.pointSize, nil)
        let attributedString = NSAttributedString(string: text,
            attributes: [
                (kCTFontAttributeName as String): ctFont
            ])
        computeLetterPaths(attributedString)
    }
    
    func computeLetterPaths(attributedString: NSAttributedString) {
        letterPaths = []
        letterPositions = []
        lineRects = []
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)
        let textPath = CGPathCreateWithRect(bounds, nil)
        let textFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), textPath, nil)
        
        let lines = CTFrameGetLines(textFrame)
        var origins = [CGPoint](count: CFArrayGetCount(lines), repeatedValue: CGPointZero)
        CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), &origins)
        
        for (var lineIndex = 0; lineIndex < CFArrayGetCount(lines); lineIndex++) {
            let unmanagedLine: UnsafePointer<Void> = CFArrayGetValueAtIndex(lines, lineIndex)
            let line: CTLineRef = unsafeBitCast(unmanagedLine, CTLineRef.self)
        }
    }
}

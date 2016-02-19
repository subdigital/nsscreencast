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
        
        let containerLayer = CALayer()
        containerLayer.geometryFlipped = true
        layer.addSublayer(containerLayer)
        
        for (index, path) in letterPaths.enumerate() {
            let pos = letterPositions[index]
            
            // create shape layer for this glyph
            let glyphLayer = CAShapeLayer()
            glyphLayer.path = path.CGPath
            glyphLayer.fillColor = textColor.CGColor
            glyphLayer.strokeColor = UIColor.redColor().CGColor
            
            let jitter = (CGFloat(arc4random_uniform(10)) - 5.0) / 10.0 + 1.0
            glyphLayer.transform = CATransform3DMakeScale(jitter, jitter, 1.0)
            
            var glyphFrame = glyphLayer.bounds
            glyphFrame.origin = pos
            glyphLayer.frame = glyphFrame
            containerLayer.addSublayer(glyphLayer)
        }
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
            var lineOrigin = origins[lineIndex]
            let lineBounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.UseGlyphPathBounds)
            lineRects.append(lineBounds)
            
            // adjust origin for flipped coordinate system
            lineOrigin.y = -CGRectGetHeight(lineBounds)
            
            let runs = CTLineGetGlyphRuns(line)
            for (var runIndex = 0; runIndex < CFArrayGetCount(runs); runIndex++) {
                let runPointer = CFArrayGetValueAtIndex(runs, runIndex)
                let run = unsafeBitCast(runPointer, CTRunRef.self)
                let attribs = CTRunGetAttributes(run)
                let fontPointer = CFDictionaryGetValue(attribs, unsafeAddressOf(kCTFontAttributeName))
                let font = unsafeBitCast(fontPointer, CTFontRef.self)
                
                let glyphCount = CTRunGetGlyphCount(run)
                var ascents = [CGFloat](count: glyphCount, repeatedValue: 0)
                var descents = [CGFloat](count: glyphCount, repeatedValue: 0)
                var leading = [CGFloat](count: glyphCount, repeatedValue: 0)
                CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascents, &descents, &leading)
                
                for (var glyphIndex = 0; glyphIndex < glyphCount; glyphIndex++) {
                    let glyphRange = CFRangeMake(glyphIndex, 1)
                    var glyph = CGGlyph()
                    var position = CGPointZero
                    CTRunGetGlyphs(run, glyphRange, &glyph)
                    CTRunGetPositions(run, glyphRange, &position)
                    position.y = lineOrigin.y
                    
                    if let path = CTFontCreatePathForGlyph(font, glyph, nil) {
                        letterPaths.append(UIBezierPath(CGPath: path))
                        letterPositions.append(position)
                    }
                }
            }
        }
    }
}

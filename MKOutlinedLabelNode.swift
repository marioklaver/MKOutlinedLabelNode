//
//  MKOutlinedLabelNode.swift
//
//  Created by Mario Klaver on 13-8-2015.
//  Copyright (c) 2015 Endpoint ICT. All rights reserved.
//

import UIKit
import SpriteKit

class MKOutlinedLabelNode: SKLabelNode {
    
    var borderColor: UIColor = UIColor.blackColor()
    
    var outlinedText: String! {
        didSet { drawText() }
    }
    
    private var border: SKShapeNode?
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    override init() {
        super.init()
    }
    
    init(fontNamed fontName: String!, fontSize: CGFloat) {
        super.init(fontNamed: fontName)
        self.fontSize = fontSize
    }
    
    func drawText() {
        if let borderNode = border {
            borderNode.removeFromParent()
            border = nil
        }
        
        if let text = outlinedText {
            self.text = text
            if let path = createBorderPathForText() {
                let border = SKShapeNode()

                border.strokeColor = borderColor
                border.lineWidth = 7;
                border.path = path
                border.position = positionBorder(border)
                addChild(border)
                
                self.border = border
            }
        }
    }
    
    private func getTextAsCharArray() -> [UniChar] {
        var chars = [UniChar]()
        
        for codeUnit in text.utf16 {
            chars.append(codeUnit)
        }
        return chars
    }
    
    private func createBorderPathForText() -> CGPathRef? {
        let chars = getTextAsCharArray()
        let borderFont = CTFontCreateWithName(self.fontName, self.fontSize, nil)
        
        var glyphs = Array<CGGlyph>(count: chars.count, repeatedValue: 0)
        let gotGlyphs = CTFontGetGlyphsForCharacters(borderFont, chars, &glyphs, chars.count)
        
        if gotGlyphs {
            var advances = Array<CGSize>(count: chars.count, repeatedValue: CGSize())
            CTFontGetAdvancesForGlyphs(borderFont, CTFontOrientation.OrientationHorizontal, glyphs, &advances, chars.count);
            
            let letters = CGPathCreateMutable()
            var xPosition = 0 as CGFloat
            for index in 0...(chars.count - 1) {
                let letter = CTFontCreatePathForGlyph(borderFont, glyphs[index], nil)
                var t = CGAffineTransformMakeTranslation(xPosition , 0)
                CGPathAddPath(letters, &t, letter)
                xPosition = xPosition + advances[index].width
            }
            
            return letters
        } else {
            return nil
        }
    }
    
    private func positionBorder(border: SKShapeNode) -> CGPoint {
        let sizeText = self.calculateAccumulatedFrame()
        let sizeBorder = border.calculateAccumulatedFrame()
        let offsetX = (sizeBorder.width - sizeText.width) / 2
        
        return CGPointMake(-(sizeBorder.width / 2) + offsetX, 1)
    }
}

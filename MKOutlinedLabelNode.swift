//
//  MKOutlinedLabelNode.swift
//
//  Created by Mario Klaver on 13-8-2015.
//  Copyright (c) 2015 Endpoint ICT. All rights reserved.
//

import UIKit
import SpriteKit

class MKOutlinedLabelNode: SKLabelNode {
    
    var borderColor: UIColor = UIColor.black
    var borderWidth: CGFloat = 7.0
    var borderOffset : CGPoint = CGPoint(x: 0, y: 0)
    enum borderStyleType {
        case over
        case under
    }
    var borderStyle = borderStyleType.under
    
    var shadowEnabled = false
    var shadowColor: UIColor = UIColor.black
    var shadowOffset: CGPoint = CGPoint(x: 4, y: 4)
    var shadowAlpha: CGFloat = 0.5
    
    var outlinedText: String! {
        didSet { drawText() }
    }
    
    private var border: SKShapeNode?
    private(set) var shadow: SKShapeNode?
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    override init() { super.init() }
    
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
                border.lineWidth = borderWidth;
                border.path = path
                border.position = positionShape(shapeNode: border)
                switch self.borderStyle {
                case borderStyleType.over:
                    border.zPosition = self.zPosition + 1
                    break
                default:
                    border.zPosition = self.zPosition - 1
                }
                
                self.addChild(border)
                self.border = border
                
                
                let shadow = SKShapeNode()
                shadow.fillColor = self.shadowColor
                shadow.path = path
                var shadowPosition = positionShape(shapeNode: shadow)
                shadowPosition = CGPoint(x: shadowPosition.x + self.shadowOffset.x, y: shadowPosition.y + self.shadowOffset.y)
                shadow.position = shadowPosition
                shadow.alpha = self.shadowAlpha
                
                self.addChild(shadow)
                self.shadow = shadow
            }
        }
    }
    
    private func getTextAsCharArray() -> [UniChar] {
        var chars = [UniChar]()
        
        for codeUnit in (text?.utf16)! {
            chars.append(codeUnit)
        }
        return chars
    }
    
    private func createBorderPathForText() -> CGPath? {
        let chars = getTextAsCharArray()
        let borderFont = CTFontCreateWithName(self.fontName as CFString?, self.fontSize, nil)
        
        var glyphs = Array<CGGlyph>(repeating: 0, count: chars.count)
        let gotGlyphs = CTFontGetGlyphsForCharacters(borderFont, chars, &glyphs, chars.count)
        
        if gotGlyphs {
            var advances = Array<CGSize>(repeating: CGSize(), count: chars.count)
            CTFontGetAdvancesForGlyphs(borderFont, CTFontOrientation.horizontal, glyphs, &advances, chars.count);
            
            let letters = CGMutablePath()
            var xPosition = 0 as CGFloat
            for index in 0...(chars.count - 1) {
                let letter = CTFontCreatePathForGlyph(borderFont, glyphs[index], nil)
                let t = CGAffineTransform(translationX: xPosition , y: 0)
                
                if let l = letter {
                    letters.addPath(l, transform: t)
                }
                xPosition = xPosition + advances[index].width
            }
            
            return letters
        } else {
            return nil
        }
    }
    
    private func positionShape(shapeNode: SKShapeNode) -> CGPoint {
        let sizeText = self.calculateAccumulatedFrame()
        let sizeBorder = shapeNode.calculateAccumulatedFrame()
        let offsetX = sizeBorder.width - sizeText.width
        
        switch self.horizontalAlignmentMode {
        case SKLabelHorizontalAlignmentMode.center:
            return CGPoint(x: -(sizeBorder.width / 2) + offsetX/2.0 + self.borderOffset.x, y: 1 + self.borderOffset.y)
        case SKLabelHorizontalAlignmentMode.left:
            return CGPoint(x: sizeBorder.origin.x - self.borderWidth*2 + offsetX + self.borderOffset.x, y: 1 + self.borderOffset.y)
        default:
            return CGPoint(x: sizeBorder.origin.x - sizeText.width - self.borderWidth*2 + offsetX + self.borderOffset.x, y: 1 + self.borderOffset.y)
        }
    }
}

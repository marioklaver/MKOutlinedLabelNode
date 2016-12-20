# MKOutlinedLabelNode
Draw outlined text in SpriteKit.

On this fork I've added support for drawing an extra SKShapeNode to give a basic shadow effect to the label

Usage
-----
```swift
let textNode = MKOutlinedLabelNode(fontNamed: "Helvetica", fontSize: 32)
textNode.borderColor = UIColor.blackColor()
textNode.fontColor = UIColor.blueColor()

//Add a shadow
textNode.shadowEnabled = true
textNode.shadowColor = UIColor.blackColor()
textNode.shadowAlpha = 0.5
textNode.shadowOffset = CGPoint(x: -5, y: -5)

textNode.outlinedText = "Test"
```

Screenshot
----------

![Screenshot](https://raw.githubusercontent.com/marioklaver/MKOutlinedLabelNode/master/OutlinedText.png)

License
-------
[MIT](https://github.com/marioklaver/MKOutlinedLabelNode/blob/master/LICENSE)

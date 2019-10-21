//
//  ARSliderToolTipView.swift
//  ARCustomSlider
//
//  Created by AbdulRehman Warraich on 10/21/19.
//

import Foundation

class ARSliderToolTipView: UIView {
    
    // MARK: properties
    var font: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var text: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var value: Float {
        get {
            if let text = text {
                return Float(text) ?? 0
            }
            return 0.0
        }
        set {
            text = "\(Int(roundf(newValue)))"
        }
    }
    
    var fillColor = UIColor.gray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var textColor = UIColor.darkGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override open func draw(_ rect: CGRect) {
        fillColor.setFill()
        
        let roundedRect = CGRect(x:bounds.origin.x,
                                 y:bounds.origin.y,
                                 width:bounds.size.width,
                                 height:bounds.size.height * 0.8)
        
        let roundedRectPath = UIBezierPath(roundedRect: roundedRect, cornerRadius: 6.0)
        
        // create arrow
        let arrowPath = UIBezierPath()
        
        let p0 = CGPoint(x: bounds.midX, y: bounds.maxY - 2.0 )
        arrowPath.move(to: p0)
        arrowPath.addLine(to: CGPoint(x:bounds.midX - 6.0, y: roundedRect.maxY))
        arrowPath.addLine(to: CGPoint(x:bounds.midX + 6.0, y: roundedRect.maxY))
        
        roundedRectPath.append(arrowPath)
        roundedRectPath.fill()
        
        // draw text
        if let text = self.text {
            
            let size = text.size(withAttributes: [NSAttributedString.Key.font: font])
            let yOffset = (roundedRect.size.height - size.height) / 2.0
            let textRect = CGRect(x:roundedRect.origin.x, y: yOffset, width: roundedRect.size.width, height: size.height)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs = [NSAttributedString.Key.font: font,
                         NSAttributedString.Key.paragraphStyle: paragraphStyle,
                         NSAttributedString.Key.foregroundColor: textColor]
            text.draw(in:textRect, withAttributes: attrs)
        }
    }
}

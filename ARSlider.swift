//
//  AFSlider.swift
//  ARCustomSlider
//
//  Created by AbdulRehman Warraich on 10/21/19.
//

import UIKit

open class ARSlider: UISlider {

    // MARK:- Properties
    private var toolTipView: ARSliderToolTipView!
    open weak var delegate: ARSliderDelegate?

    @IBInspectable open var handlerImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }

    var thumbRect: CGRect {
        let rect = trackRect(forBounds: bounds)
        return thumbRect(forBounds: bounds, trackRect: rect, value: value)
    }

    // MARK:- view life circle
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame);
        setup()
    }

    // MARK:- local functions
    func setup() {
        if (toolTipView == nil) {
            toolTipView = ARSliderToolTipView(frame: CGRect.zero)
            toolTipView.backgroundColor = UIColor.clear
            self.addSubview(toolTipView)
        }
        setSlider()
    }
    ///Set Slider
    func setSlider() {
        if let image = handlerImage {
            setThumbImage(image, for: .normal)
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ARSlider.gestureAction(_:)))

        self.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK:- UIControl touch event tracking

    /**
     Check wheter touch should begin or not.

     - parameter touch: UITocuh.
     - parameter with event: Touch event.

     - returns: Bool.
     */
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {

        delegate?.startDragging(slider: self)
        // Fade in and update the popup view
        let touchPoint = touch.location(in: self)
        // Check if the knob is touched. Only in this case show the popup-view
        checkAndShowPopupView(touchPoint)
        return super.beginTracking(touch, with: event)
    }

    /**
     Check wheter continue slider tracking or not.

     - parameter touch: UITocuh.
     - parameter with event: Touch event.

     - returns: Bool.
     */
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {

        if toolTipView.alpha != 1.0 {
            // Fade in and update the popup view
            let touchPoint = touch.location(in: self)
            // Check if the knob is touched. Only in this case show the popup-view
            checkAndShowPopupView(touchPoint)

        } else {
            // Update the popup view as slider knob is being moved
            positionAndUpdatePopupView()
        }

        return super.continueTracking(touch, with: event)
    }

    /**
     Cancel slider tracking.

     - parameter with event: Touch event.

     - returns: Void.
     */
    open override func cancelTracking(with event: UIEvent?) {
        delegate?.endDragging(slider: self)
        super.cancelTracking(with: event)
    }

    /**
     End slider tracking.

     - parameter touch: UITocuh.
     - parameter with event: Touch event.

     - returns: Void.
     */
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        // Fade out the popoup view
        delegate?.endDragging(slider: self)
        delegate?.markSlider(slider: self, dragged: value)
        fadePopupViewInAndOut(fadeIn: false)
        super.endTracking(touch, with: event)
    }

    /**
    set slider value.

    - parameter value: Float.
    - parameter animated: Bool.

    - returns: Void.
    */
    open override func setValue(_ value: Float, animated: Bool) {
           super.setValue(value, animated: animated)
           delegate?.markSlider(slider: self, dragged: value)
           positionAndUpdatePopupView()
           fadePopupViewInAndOutWith(duration: 0.5)
       }

    private func positionAndUpdatePopupView() {

        let tRect = thumbRect
        let popupRect = tRect.offsetBy(dx: 0, dy: -(tRect.size.height * 1.5))
        toolTipView.frame = popupRect.insetBy(dx: -28, dy: -10)
        toolTipView.value = value
    }

    /**
     Fade in/out popupview.

     - parameter fadeIn: Should fade in or not.


     - returns: Void.
     */
    private func fadePopupViewInAndOut(fadeIn: Bool) {

        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        if fadeIn {
            toolTipView.alpha = 1.0
        } else {
            toolTipView.alpha = 0.0
        }
        UIView.commitAnimations()
    }

    /**
     Fade in/out popupview.

     - parameter fadeIn: Should fade in or not.


     - returns: Void.
     */
    private func fadePopupViewInAndOutWith(duration: Double) {

        UIView.animate(withDuration: duration, animations: {

            self.toolTipView.alpha = 1.0

        }, completion: { (isCompleted) in
            if isCompleted {
                UIView.animate(withDuration: duration/2) {
                    self.toolTipView.alpha = 0.0
                }
            }
        })
    }

    /**
     Show popup view for point.

     - parameter touchPoint: touch point.

     - returns: Void.
     */
    private func checkAndShowPopupView(_ touchPoint : CGPoint){
        // Check if the knob is touched. Only in this case show the popup-view
        if thumbRect.contains(touchPoint) && toolTipView.alpha != 1.0 {
            fadePopupViewInAndOut(fadeIn: true)
        }
        positionAndUpdatePopupView()
    }

    /**
     Respond to the user action

     - parameter gestureRecognizer: The gesture recognizer responsible for the action
     */
    @objc func gestureAction(_ gestureRecognizer: UIGestureRecognizer) {

        if self.isTracking == false &&
            ( (gestureRecognizer.state == UIGestureRecognizer.State.ended ||
                gestureRecognizer.state == UIGestureRecognizer.State.changed) ) {

            let touchPoint = gestureRecognizer.location(in: self)

            let positionOfSlider: CGPoint = self.frame.origin
            let widthOfSlider: CGFloat = self.frame.size.width
            let newValue = ((touchPoint.x - positionOfSlider.x) * CGFloat(self.maximumValue) / widthOfSlider)

            self.setValue(Float(newValue), animated: true)

        }
    }
}

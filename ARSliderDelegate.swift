//
//  ARSliderDelegate.swift
//  ARCustomSlider
//
//  Created by AbdulRehman Warraich on 10/21/19.
//

import Foundation

public protocol ARSliderDelegate: class {

    func startDragging(slider: ARSlider)
    func endDragging(slider: ARSlider)
    func markSlider(slider: ARSlider, dragged to: Float)
}

//
//  ViewController.swift
//  ARCustomSlider
//
//  Created by ar.warraich@outlook.com on 10/21/2019.
//  Copyright (c) 2019 ar.warraich@outlook.com. All rights reserved.
//

import UIKit
import ARCustomSlider

class ViewController: UIViewController {

    @IBOutlet var slider: ARSlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.minimumTrackTintColor = .cyan
        slider.delegate = self
        slider.handlerImage = UIImage(named: "")
    }
}

extension ViewController: ARSliderDelegate {
    func startDragging(slider: ARSlider) {
        print("Strat Dragging")
    }

    func endDragging(slider: ARSlider) {
        print("End Dragging")
    }

    func markSlider(slider: ARSlider, dragged to: Float) {
        print("markSlider")
    }


}


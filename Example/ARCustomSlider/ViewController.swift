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
        slider.minimumTrackTintColor = .green
        slider.delegate = self
        slider.toolTipView.font = UIFont.boldSystemFont(ofSize: 20)
        slider.toolTipView.textColor = UIColor.blue

        /* If you need to set image to handler
         slider.handlerImage = UIImage(named: "name")
         */

        /*
         Enable and disable Tab Gesture movement
         slider.addTabGesture = true
         */
    }
}

extension ViewController: ARSliderDelegate {
    func startDragging(slider: ARSlider) {
        print("Strat Dragging")
    }

    func endDragging(slider: ARSlider) {
        print("End Dragging")
    }
}

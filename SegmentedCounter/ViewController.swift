//
//  ViewController.swift
//  SegmentedCounter
//
//  Created by Christopher Olsen on 3/31/16.
//  Copyright © 2016 caolsen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  let segmentedCounter = SegmentedCounter(frame: CGRect.zero)
  let segmentedCounterTwo = SegmentedCounter(frame: CGRect.zero, withNumberOfSegments: 7)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    segmentedCounterTwo.currentValue = 2
    segmentedCounterTwo.segmentBackgroundColor = UIColor.red.cgColor
    segmentedCounterTwo.segmentBorderColor = UIColor.red.cgColor
    
    view.addSubview(segmentedCounter)
    view.addSubview(segmentedCounterTwo)
  }
  
  override func viewDidLayoutSubviews() {
    let margin: CGFloat = 20.0
    let width = view.bounds.width - 2.0 * margin
    segmentedCounter.frame = CGRect(x: margin, y: margin + topLayoutGuide.length, width: width, height: 31.0)
    
    segmentedCounterTwo.frame = CGRect(x: margin, y: margin + topLayoutGuide.length + 50.0, width: width, height: 31.0)
  }
}


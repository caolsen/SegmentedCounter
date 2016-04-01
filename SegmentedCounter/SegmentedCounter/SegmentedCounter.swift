//
//  SegmentedPicker.swift
//  SegmentedPicker
//
//  Created by Christopher Olsen on 3/30/16.
//  Copyright © 2016 caolsen. All rights reserved.
//

import UIKit
import QuartzCore

class SegmentedCounter: UIControl {
  
  // MARK: - Public Variables
  
  // total number of segments
  // things could get wierd if the control is narrow and this is a high number
  // this should at least be 2, otherwise what's the point
  var numberOfSegments = 5 {
    didSet {
      assert(numberOfSegments > 1)
      updateLayerFrames()
    }
  }
  
  // padding between segments
  // is not used before the first segment or after the last segment
  var segmentPadding: CGFloat = 5.0 {
    didSet {
      updateLayerFrames()
    }
  }
  
  // border color for inactive segments
  var segmentBorderColor = UIColor.blueColor().CGColor {
    didSet {
      resetDisplayPropertiesForAllSegments()
    }
  }
  
  // width for all segment borders
  var segmentBorderWidth: CGFloat = 1.0 {
    didSet {
      resetDisplayPropertiesForAllSegments()
    }
  }
  
  // corner radius for all corners on all segments
  var segmentCornerRadius: CGFloat = 5.0 {
    didSet {
      resetDisplayPropertiesForAllSegments()
    }
  }
  
  // used for active segment fill
  var segmentBackgroundColor = UIColor.blueColor().CGColor {
    didSet {
      resetDisplayPropertiesForAllSegments()
    }
  }
  
  // if value is set programatically force frame update
  var currentValue = 0 {
    didSet {
      assert(currentValue <= numberOfSegments)
      if segmentLayers.count > 0 {
        fillInSegments(currentValue)
      }
    }
  }
  
  // ensure the control is updated when frame changes
  override var frame: CGRect {
    didSet {
      if segmentLayers.count > 0 {
        updateLayerFrames()
      }
    }
  }
  
  // MARK: - Private Variables
  
  // segment height is equal to the control height
  private var segmentHeight: CGFloat {
    return CGFloat(bounds.height)
  }
  
  /* 
     The width of each segment is determined by the
     total width of the control minus the segment padding.
   */
  private var segmentWidth: CGFloat {
    return CGFloat((bounds.width - (segmentPadding * CGFloat(numberOfSegments - 1))) / CGFloat(numberOfSegments))
  }
  
  private var segmentLayers = [SegmentLayer]()
  
  // MARK: - Inits
  
  init(frame: CGRect, withNumberOfSegments numberOfSegments: Int) {
    super.init(frame: frame)
    self.numberOfSegments = numberOfSegments
    setupSegmentsForInit()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSegmentsForInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func setupSegmentsForInit() {
    for segmentNumber in 1...numberOfSegments {
      let newSegmentLayer = SegmentLayer()
      newSegmentLayer.segmentId = segmentNumber
      newSegmentLayer.segmentedCounter = self
      
      layer.addSublayer(newSegmentLayer)
      segmentLayers.append(newSegmentLayer)
    }
    
    updateLayerFrames()
  }
  
  // MARK: - Function Overrides
  
  override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
    let touchLocation = touch.locationInView(self)
    
    // find touched segment
    for segmentToCheckForTouch in segmentLayers {
      if segmentToCheckForTouch.frame.contains(touchLocation) {
        currentValue = segmentToCheckForTouch.segmentId
      }
    }
    
    return false
  }
  
  // MARK: - Private Functions
  
  /*
     Fills in segments starting with the current value or touched segment and working backwards.
   */
  private func fillInSegments(touchedSegment: Int) {
    // if only the first segment is filled and it is touched 
    // again then clear all segments
    if touchedSegment == 1 {
      if segmentLayers[0].active && !segmentLayers[1].active {
        currentValue = 0
        segmentLayers[0].backgroundColor = nil
        return
      }
    }
    
    // fill touched and earlier segments and unfill later segments
    for segmentToCheckForFill in segmentLayers {
      if segmentToCheckForFill.segmentId <= touchedSegment {
        segmentToCheckForFill.active = true
        segmentToCheckForFill.backgroundColor = segmentBackgroundColor
      } else {
        segmentToCheckForFill.active = false
        segmentToCheckForFill.backgroundColor = nil
      }
    }
  }
  
  /*
     Calculates initial segment layer positions based on control size and segment padding.
   */
  private func updateLayerFrames() {
    for (index, segment) in segmentLayers.enumerate() {
      let segmentXPos = (segmentWidth + segmentPadding) * CGFloat(index)
      segment.frame = CGRect(x: segmentXPos, y: 0.0, width: segmentWidth, height: segmentHeight)
      resetDisplayPropertiesForSegment(segment)
    }
    
    fillInSegments(currentValue)
  }
  
  // MARK: Helper functions for resetting display properties
  
  private func resetDisplayPropertiesForSegment(segment: SegmentLayer) {
    segment.borderColor = segmentBorderColor
    segment.borderWidth = segmentBorderWidth
    segment.cornerRadius = segmentCornerRadius
    segment.setNeedsDisplay()
  }
  
  private func resetDisplayPropertiesForAllSegments() {
    for segment in segmentLayers {
      resetDisplayPropertiesForSegment(segment)
    }
  }
}

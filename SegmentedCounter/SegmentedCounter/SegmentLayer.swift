//
//  SegmentLayer.swift
//  SegmentedPicker
//
//  Created by Christopher Olsen on 3/31/16.
//  Copyright © 2016 caolsen. All rights reserved.
//

import UIKit

class SegmentLayer: CALayer {
  var segmentId: Int!
  var active = false
  weak var segmentedCounter: SegmentedCounter?
}

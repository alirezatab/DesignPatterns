//
//  HorizontalScroller.swift
//  DesignPatterns
//
//  Created by ALIREZA TABRIZI on 11/13/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

///An Adapter allows classes with incompatible interfaces to work together. It wraps itself around an object and exposes a standard interface to interact with that object.

import UIKit

@objc protocol HorizontalScrollerDelegate{
    // ask the delegate how many views he wants to present inside the horizontal scroller
    func numberOfViewsForHorizontalScroller(scroller: HorizontalScroller) -> Int
    // ask the delegate to return the view that should appear at <index>
    func horizontalScrollerViewAtIndex(scroller: HorizontalScroller, index: Int) -> UIView
    // inform the delegate what the view at <index> has been clicked
    func horizontalScrollerClicledViewAtIndex(scroller: HorizontalScroller, index: Int)
    // ask the delegate for index of the initial view to display. this method is optional and defualts to 0 if it's not implemented by the delegate
    @objc optional func initialViewIndex(scroller: HorizontalScroller) -> Int
}

class HorizontalScroller: UIView {

    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

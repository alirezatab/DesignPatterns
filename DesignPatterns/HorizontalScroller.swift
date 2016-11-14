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

    //This is necessary in order to prevent a retain cycle. If a class keeps a strong reference to its delegate and the delegate keeps a strong reference back to the conforming class, your app will leak memory since neither class will release the memory allocated to the other. All properties in swift are strong by default!
    weak var delegate : HorizontalScrollerDelegate
    
    //1
    //Define constants to make it easy to modify the layout at design time. The view’s dimensions inside the scroller will be 100 x 100 with a 10 point margin from its enclosing rectangle.
    private let VIEW_PADDING = 10
    private let VIEW_DIMENTSIONS = 100
    private let VIEWS_OFFSET = 100
    
    //2
    //Create the scroll view containing the views.
    private var scroller : UIScrollView!
    
    //3
    //Create an array that holds all the album covers.
    var viewArray = [UIView]()
    
    override init(frame :CGRect){
        super.init(frame: frame)
        initializeScrollView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeScrollView()
    }
    
    func initializeScrollView() {
        //1
        //Create’s a new UIScrollView instance and add it to the parent view.
        scroller = UIScrollView()
        addSubview(scroller)
    
        //2
        //Turn off autoresizing masks. This is so you can apply your own constraints
        ///below code has no setTranslateAutoresizingMaskIntoConstraints
        ///scroller.setTranslateAutoresizingMaskIntoConstraints(false)
        
        //3
        //Apply constraints to the scrollview. You want the scroll view to completely fill the HorizontalScroller
        
        
        //4
        //Create a tap gesture recognizer. The tap gesture recognizer detects touches on the scroll view and checks if an album cover has been tapped. If so, it will notify the HorizontalScroller delegate.
    }
}
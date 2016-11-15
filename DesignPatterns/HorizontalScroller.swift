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
    weak var delegate : HorizontalScrollerDelegate?
    
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
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
        //4
        //Create a tap gesture recognizer. The tap gesture recognizer detects touches on the scroll view and checks if an album cover has been tapped. If so, it will notify the HorizontalScroller delegate.
        let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(HorizontalScroller.scrollerTapped(_:)))
        scroller.addGestureRecognizer(tapRecognizer)
    }
    
    func viewAtIndex(index :Int) -> UIView {
        return viewArray[index]
    }
    
    func scrollerTapped(_ gesture: UITapGestureRecognizer) {
        // The gesture passed in as a parameter lets you extract the location with locationInView()
        let location = gesture.location(in: gesture.view)
        if let delegate = delegate {
            for index in 0..<delegate.numberOfViewsForHorizontalScroller(scroller: self) {
                let view = scroller.subviews[index] 
                if view.frame.contains(location) {
                    // For each view in the scroll view, perform a hit test using CGRectContainsPoint to find the view that was tapped. When the view is found, call the delegate method horizontalScrollerClickedViewAtIndex. Before you break out of the for loop, center the tapped view in the scroll view---> replaced by above code
                    delegate.horizontalScrollerClicledViewAtIndex(scroller: self, index: index)
                    scroller.setContentOffset(CGPoint(x: view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, y: 0), animated:true)
                    break
                }
            }
        }
    }
    
    
    
    func reload() {
        // 1- Check if there is a delegate, if not there is nothing to load
        if let delegate = delegate {
            //2- Will keep adding new album views on relaod, need to retest
            viewArray = []
            let views: NSArray = scroller.subviews as NSArray
            //3- remove all subViews
            for view in views {
                (view as AnyObject).removeFromSuperview()
            }
            
            //4- xValue is the starting point of the views inside the scroller
            var xValue = VIEWS_OFFSET
            for index in 0..<delegate.numberOfViewsForHorizontalScroller(scroller: self) {
                //5- add a view at the right position
                xValue += VIEW_PADDING
                let view = delegate.horizontalScrollerViewAtIndex(scroller: self, index: index)
                view.frame = CGRect(x: CGFloat(xValue), y: CGFloat(VIEW_PADDING), width: CGFloat(VIEW_DIMENTSIONS), height: CGFloat(VIEW_DIMENTSIONS))
                scroller.addSubview(view)
                xValue += VIEW_DIMENTSIONS + VIEW_PADDING
                //6- Store the view so we can reference it later
                viewArray.append(view)
            }
            // 7
            scroller.contentSize = CGSize(width: CGFloat(xValue + VIEWS_OFFSET), height: frame.size.height)
            
            //8 - If an Initial view is defined, ceter the scroller on it
            if let initialView = delegate.initialViewIndex?(scroller: self) {
                scroller.setContentOffset(CGPoint(x: CGFloat(initialView)*CGFloat((VIEW_DIMENTSIONS + (2 * VIEW_PADDING))), y: 0), animated: true)
            }
            
        }
    }
    
}

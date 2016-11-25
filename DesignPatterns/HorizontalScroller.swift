//
//  HorizontalScroller.swift
//  DesignPatterns
//
//  Created by ALIREZA TABRIZI on 11/13/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

///An Adapter allows classes with incompatible interfaces to work together. It wraps itself around an object and exposes a standard interface to interact with that object.
/// Your HorizontalScroller is ready for use! Browse through the code you’ve just written; you’ll see there’s not one single mention of the Album or AlbumView classes. That’s excellent, because this means that the new scroller is truly independent and reusable.

import UIKit

// @objc before the protocol declaration makes @optional delegate methods like in Objective-C.
@objc protocol HorizontalScrollerDelegate{
    // ask the delegate how many views he wants to present inside the horizontal scroller
    func numberOfViewsForHorizontalScroller(_ scroller: HorizontalScroller) -> Int
    // ask the delegate to return the view that should appear at <index>
    func horizontalScrollerViewAtIndex(_ scroller: HorizontalScroller, index:Int) -> UIView
    // inform the delegate what the view at <index> has been clicked
    func horizontalScrollerClickedViewAtIndex(_ scroller: HorizontalScroller, index:Int)
    // ask the delegate for the index of the initial view to display. this method is optional
    // and defaults to 0 if it's not implemented by the delegate
    @objc optional func initialViewIndex(_ scroller: HorizontalScroller) -> Int
}

class HorizontalScroller: UIView {

    //This is necessary in order to prevent a retain cycle. If a class keeps a strong reference to its delegate and the delegate keeps a strong reference back to the conforming class, your app will leak memory since neither class will release the memory allocated to the other. 
    ///All properties in swift are strong by default!
    weak var delegate : HorizontalScrollerDelegate?
    
    // 1 - Define constants to make it easy to modify the layout at design time. The view’s dimensions inside the scroller will be 100 x 100 with a 10 point margin from its enclosing rectangle.
    private let VIEW_PADDING = 10
    private let VIEW_DIMENTSIONS = 100
    private let VIEWS_OFFSET = 100
    
    // 2 - Create the scroll view containing the views.
    fileprivate var scroller : UIScrollView!
    
    // 3 - Create an array that holds all the album covers.
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
        // 1 - Create’s a new UIScrollView instance and add it to the parent view.
        scroller = UIScrollView()
        scroller.delegate = self
        addSubview(scroller)
    
        
        // 2 - Turn off autoresizing masks. This is so you can apply your own constraints
        //below code has no setTranslateAutoresizingMaskIntoConstraints
        //scroller.setTranslateAutoresizingMaskIntoConstraints(false)
        scroller.translatesAutoresizingMaskIntoConstraints = false
        
        
        // 3 - Apply constraints to the scrollview. You want the scroll view to completely fill the HorizontalScroller
        self.addConstraint(NSLayoutConstraint(item: scroller,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .leading,
                                              multiplier: 1.0,
                                              constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: scroller,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .trailing,
                                              multiplier: 1.0,
                                              constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: scroller,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .top,
                                              multiplier: 1.0,
                                              constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: scroller,
                                              attribute: .bottom,
                                              relatedBy: .equal, 
                                              toItem: self, 
                                              attribute: .bottom,
                                              multiplier: 1.0,
                                              constant: 0.0))
        
        
        // 4 - Create a tap gesture recognizer. The tap gesture recognizer detects touches on the scroll view and checks if an album cover has been tapped. If so, it will notify the HorizontalScroller delegate.
        let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(HorizontalScroller.scrollerTapped(_:)))
        scroller.addGestureRecognizer(tapRecognizer)
    }
    
    func viewAtIndex(_ index :Int) -> UIView {
        return viewArray[index]
    }
    
    func scrollerTapped(_ gesture: UITapGestureRecognizer) {
        // The gesture passed in as a parameter lets you extract the location with locationInView()
        let location = gesture.location(in: gesture.view)
        if let delegate = delegate {
            for index in 0..<delegate.numberOfViewsForHorizontalScroller(self) {
                let view = scroller.subviews[index] 
                if view.frame.contains(location) {
                    // For each view in the scroll view, perform a hit test using CGRectContainsPoint to find the view that was tapped. When the view is found, call the delegate method horizontalScrollerClickedViewAtIndex. Before you break out of the for loop, center the tapped view in the scroll view---> replaced by above code
                    delegate.horizontalScrollerClickedViewAtIndex(self, index: index)
                    scroller.setContentOffset(CGPoint(x: view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, y: 0), animated:true)
                    break
                }
            }
        }
    }
    
    // didMoveToSuperview is called on a view when it’s added to another view as a subview. This is the right time to reload the contents of the scroller.
    override func didMoveToSuperview() {
        reload()
    }
    
    func reload() {
        // 1 - Check if there is a delegate, if not there is nothing to load
        if let delegate = delegate {
            // 2 - Will keep adding new album views on relaod, need to retest
            viewArray = []
            let views: NSArray = scroller.subviews as NSArray
            // 3 - remove all subViews
            for view in views {
                (view as AnyObject).removeFromSuperview()
            }
            
            // 4 - xValue is the starting point of the views inside the scroller
            var xValue = VIEWS_OFFSET
            for index in 0..<delegate.numberOfViewsForHorizontalScroller(self) {
                // 5 - add a view at the right position
                // The HorizontalScroller asks its delegate for the views one at a time and it lays them next to each another horizontally with the previously defined padding.
                xValue += VIEW_PADDING
                let view = delegate.horizontalScrollerViewAtIndex(self, index: index)
                view.frame = CGRect(x: CGFloat(xValue), y: CGFloat(VIEW_PADDING), width: CGFloat(VIEW_DIMENTSIONS), height: CGFloat(VIEW_DIMENTSIONS))
                scroller.addSubview(view)
                xValue += VIEW_DIMENTSIONS + VIEW_PADDING
                // 6 - Store the view so we can reference it later
                viewArray.append(view)
            }
            // 7
            // Once all the views are in place, set the content offset for the scroll view to allow the user to scroll through all the albums covers.
            scroller.contentSize = CGSize(width: CGFloat(xValue + VIEWS_OFFSET), height: frame.size.height)
            
            // 8 - If an Initial view is defined, ceter the scroller on it
            // The HorizontalScroller checks if its delegate implements initialViewIndex(). This check is necessary because that particular protocol method is optional. If the delegate doesn’t implement this method, 0 is used as the default value. Finally, this piece of code sets the scroll view to center the initial view defined by the delegate.
            if let initialView = delegate.initialViewIndex?(self) {
                scroller.setContentOffset(CGPoint(x: CGFloat(initialView)*CGFloat((VIEW_DIMENTSIONS + (2 * VIEW_PADDING))), y: 0), animated: true)
            }
            
        }
    }
    
    // The above code takes into account the current offset of the scroll view and the dimensions and the padding of the views in order to calculate the distance of the current view from the center. The last line is important: once the view is centered, you then inform the delegate that the selected view has changed.
    func centerCurrentView() {
        var xFinal = Int(scroller.contentOffset.x) + (VIEWS_OFFSET/2) + VIEW_PADDING
        let viewIndex = xFinal / (VIEW_DIMENTSIONS + (2*VIEW_PADDING))
        xFinal = viewIndex * (VIEW_DIMENTSIONS + (2*VIEW_PADDING))
        scroller.setContentOffset(CGPoint(x: xFinal, y: 0), animated: true)
        if let delegate = delegate {
            delegate.horizontalScrollerClickedViewAtIndex(self, index: Int(viewIndex))
        }  
    }
}



// scrollViewDidEndDragging(_:willDecelerate:) informs the delegate when the user finishes dragging. The decelerate parameter is true if the scroll view hasn’t come to a complete stop yet. When the scroll action ends, the the system calls scrollViewDidEndDecelerating. In both cases you should call the new method to center the current view since the current view probably has changed after the user dragged the scroll view.
extension HorizontalScroller:UIScrollViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            centerCurrentView()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        centerCurrentView()
    }
}

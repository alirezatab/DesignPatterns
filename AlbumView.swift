//
//  AlbumView.swift
//  DesignPatterns
//
//  Created by ALIREZA TABRIZI on 11/10/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit

class AlbumView: UIView {

    ///The coverImage represents the album cover image. The second property is an indicator that spins to indicate activity while the cover is being downloaded.
    ///The properties are marked as private because no class outside AlbumView needs to know of the existence of these properties; they are used only in the implementation of the class’s internal functionality. This convention is extremely important if you’re creating a library or framework for other developers to use to keep private state information private.
    private var coverImage : UIImageView!
    private var indicator : UIActivityIndicatorView!

    ///The NSCoder initializer is required because UIView conforms to NSCoding.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    ///commonInit is a helper method used in both init: that you’ll use in the rest of the app, you set some nice defaults for the album view. You set the background to black, create the image view with a small margin of 5 pixels and create and add the activity indicator.
    func commonInit() {
        backgroundColor = UIColor.black
        coverImage = UIImageView(frame: CGRect(x: 5, y: 5, width: frame.size.width - 10, height: frame.size.height - 10))
        addSubview(coverImage)
        indicator = UIActivityIndicatorView()
        indicator.center = center
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.startAnimating()
        addSubview(indicator)
    }
    
    //#didHighlightView: Bool
    func highlightAlbum(didHighlightView: Bool) {
        if didHighlightView == true {
            backgroundColor = UIColor.white
        } else {
            backgroundColor = UIColor.black
        }
    }
    
}

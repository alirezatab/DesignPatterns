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
    
    init(frame: CGRect, albumCover: String) {
        super.init(frame: frame)
        commonInit()
       
        //This line sends a notification through the NSNotificationCenter singleton. The notification info contains the UIImageView to populate and the URL of the cover image to be downloaded. That’s all the information you need to perform the cover download task.
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BLDownloadImageNotification"), object: self, userInfo:["imageView": coverImage, "coverUrl": albumCover])
   
        // instead of nil for options, use []
    }
    
    ///commonInit is a helper method used in both init: that you’ll use in the rest of the app, you set some nice defaults for the album view. You set the background to black, create the image view with a small margin of 5 pixels and create and add the activity indicator.
    func commonInit() {
        backgroundColor = UIColor.black
        coverImage = UIImageView(frame: CGRect(x: 5, y: 5, width: frame.size.width - 10, height: frame.size.height - 10))
        addSubview(coverImage)
        
        coverImage.addObserver(self, forKeyPath: "image", options: [], context: nil)

        
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
    
    deinit {
        coverImage.removeObserver(self, forKeyPath: "image")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "image"{
            indicator.stopAnimating()
        }
    }
    
}

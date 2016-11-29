//
//  LibraryAPI.swift
//  DesignPatterns
//
//  Created by ALIREZA TABRIZI on 11/10/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit

class LibraryAPI: NSObject {
    
    ///Facade var below
    private let persistencyManager : PersistencyManager
    private let httpClient : HTTPClient
    private let isOnline : Bool
    
    //1
    class var sharedInstance : LibraryAPI{
        //2
        struct singelton {
            //3
            static let instance = LibraryAPI()
        }
        //4
        return singelton.instance
    }
    
    ///Facade init
    // isOnline determines if the server should be updated with any changes made to the albums list, such as added or deleted albums.
    //The HTTP client doesn’t actually work with a real server and is only here to demonstrate the usage of the facade pattern, so isOnline will always be false.
    override init(){
        persistencyManager = PersistencyManager()
        httpClient = HTTPClient()
        isOnline = false
        
        super.init()
        
        //This is the other side of the equation: the observer. Every time an AlbumView class posts a BLDownloadImageNotification notification, since LibraryAPI has registered as an observer for the same notification, the system notifies LibraryAPI. Then LibraryAPI calls downloadImage() in response.
        
        NotificationCenter.default.addObserver(self, selector:#selector(LibraryAPI.downloadImage(_:)), name: NSNotification.Name(rawValue: "BLDownloadImageNotification"), object: nil)
    }
    
    //you must remember to unsubscribe from this notification when your class is deallocated. If you do not properly unsubscribe from a notification your class registered for, a notification might be sent to a deallocated instance. This can result in application crashes.
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getAlbums() -> [Album] {
        return persistencyManager.getAlbums()
    }
    
    //Take a look at addAlbum(_:index:). The class first updates the data locally, and then if there’s an internet connection, it updates the remote server. This is the real strength of the Facade;
    func addAlbum(album: Album, index:Int) {
        persistencyManager.addAlbum(album: album, index: index)
        if isOnline {
            httpClient.postRequest("/api/addAlbum", body: album.description)
        }
    }
    
    func deleteAlbum(index: Int) {
        persistencyManager.deleteAlbumAtIndex(index: index)
        if isOnline {
            httpClient.postRequest("/api/deleteAlbum", body: "\(index)")
        }
    }
    
    
    //Again, you’re using the Facade pattern to hide the complexity of downloading an image from the other classes. The notification sender doesn’t care if the image came from the web or from the file system.
    func downloadImage(_ notification: Notification) {
        //1 - downloadImage is executed via notifications and so the method receives the notification object as a parameter. The UIImageView and image URL are retrieved from the notification.
        let userInfo = notification.userInfo as! [String : AnyObject]
        let imageView = userInfo["imageView"] as! UIImageView?
        let coverUrlString = userInfo["coverUrl"] as! String
        let coverUrl = NSURL(string: coverUrlString)
        print(coverUrl!)
        //2 - Retrieve the image from the PersistencyManager if it’s been downloaded previously.
        if let imageViewUnwrapped = imageView{
            imageViewUnwrapped.image = persistencyManager.getImage((coverUrl?.lastPathComponent)!)
            if imageViewUnwrapped.image == nil{
                //3 - If the image hasn’t already been downloaded, then retrieve it using HTTPClient.
                ///dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                    let downloadImage = self.httpClient.downloadImage(coverUrlString as String)
                    print(downloadImage) 
                    //4 - When the download is complete, display the image in the image view and use the PersistencyManager to save it locally.
                    ///dispatch_sync(dispatch_get_main_queue()
                    DispatchQueue.main.async {
                        imageViewUnwrapped.image = downloadImage
                        self.persistencyManager.saveImage(downloadImage, fileName: (coverUrl?.lastPathComponent)!)
                    }
                }
            }
        }
    }
    
    // Since the main application accesses all services via LibraryAPI, this is how the application will let PersistencyManager know that it needs to save album data.
    // This code simply passes on a call to LibraryAPI to save the albums on to PersistencyMangaer
    func saveAlbums() {
        persistencyManager.saveAlbums()
    }
    
}

///1
/*
Create a class variable as a computed type property. The class variable, like class methods in Objective-C, is something you can call without having to instantiate the class LibraryAPI
 */

///2
/*
 Nested within the class variable is a struct called Singleton.
*/

///3
/*
 Singleton wraps a static constant variable named instance. Declaring a property as static means this property only exists once. Also note that static properties in Swift are implicitly lazy, which means that Instance is not created until it’s needed. Also note that since this is a constant property, once this instance is created, it’s not going to create it a second time. This is the essence of the Singleton design pattern. The initializer is never called again once it has been instantiated.
*/

///4
/*
 Returns the computed type property.
*/
 
 
 
 
 
 
 

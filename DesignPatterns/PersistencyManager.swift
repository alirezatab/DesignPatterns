//
//  PersistencyManager.swift
//  DesignPatterns
//
//  Created by ALIREZA TABRIZI on 11/10/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit

class PersistencyManager: NSObject {
    
    //Here you declare a private property to hold album data. The array is mutable, so you can easily add and delete albums.
    private var albums = [Album]()
    
    override init(){
        //Dummy list of albums
        let album1 = Album(title: "Best of Bowie",
                           artist: "David Bowie",
                           genre: "Pop",
                           coverUrl: "http://www.albumartexchange.com/coverart/gallery/th/theblackcrowes_theband_k9m.jpg",
                           year: "1992")
        
        let album2 = Album(title: "It's My Life",
                           artist: "No Doubt",
                           genre: "Pop",
                           coverUrl: "http://www.albumartexchange.com/coverart/gallery/th/theblackcrowes_theband_k9m.jpg",
                           year: "2003")
        
        let album3 = Album(title: "Nothing Like The Sun",
                           artist: "Sting",
                           genre: "Pop",
                           coverUrl: "http://www.albumartexchange.com/coverart/gallery/th/theblackcrowes_theband_k9m.jpg",
                           year: "1999")
        
        let album4 = Album(title: "Staring at the Sun",
                           artist: "U2",
                           genre: "Pop",
                           coverUrl: "http://www.albumartexchange.com/coverart/gallery/th/theblackcrowes_theband_k9m.jpg",
                           year: "2000")
        
        let album5 = Album(title: "American Pie",
                           artist: "Madonna",
                           genre: "Pop",
                           coverUrl: "http://www.albumartexchange.com/coverart/gallery/th/theblackcrowes_theband_k9m.jpg",
                           year: "2000")
        
        albums = [album1, album2, album3, album4, album5]
    }
    
    //MARK : get, add, and delete albums
    ///These methods allow you to get, add, and delete albums.
    func getAlbums() -> [Album] {
        return albums
    }
    
    func addAlbum(album: Album, index: Int) {
        if (albums.count >= index) {
            albums.insert(album, at: index)
        } else {
            albums.append(album)
        }
    }
    
    func deleteAlbumAtIndex(index: Int) {
        albums.remove(at: index)
    }
    // The downloaded images will be saved in the Documents directory, and getImage() will return nil if a matching file is not found in the Documents directory.
    func saveImage(_ image: UIImage, fileName: String) {
        let filename = NSHomeDirectory() + "/Documents/\(fileName)"
        
        let data = UIImagePNGRepresentation(image)
        try? data?.write(to: URL(fileURLWithPath: filename), options: [.atomic])
    }
    
    func getImage(_ filename: String) -> UIImage? {
        var error: NSError?
        let path = NSHomeDirectory() + "/Documents/\(filename)"
        print(path)
        
        //issue here
        do {
           let data = try? NSData(contentsOfFile: path, options: NSData.ReadingOptions.uncachedRead)
            return UIImage(data: data as! Data)
        } catch {
           return nil
        }
    }
}

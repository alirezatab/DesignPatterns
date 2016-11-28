//
//  Album.swift
//  DesignPatterns
//
//  Created by ALIREZA TABRIZI on 11/10/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit

//conforming to the NSCoding protocol for ARCHIVING
class Album: NSObject, NSCoding {

    var title : String!
    var artist : String!
    var genre : String!
    var coverUrl : String!
    var year : String!
    
    //the init(coder:) initializer will be used to reconstruct or unarchive from a saved instance.
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.artist = aDecoder.decodeObject(forKey: "artist") as! String!
        self.genre = aDecoder.decodeObject(forKey: "genere") as! String
        self.coverUrl = aDecoder.decodeObject(forKey: "coverUrl") as! String
        self.year = aDecoder.decodeObject(forKey: "year") as! String
    }
    
    //As part of the NSCoding protocol, encodeWithCoder will be called when you ask for an Album instance to be archived.
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(artist, forKey: "artist")
        aCoder.encode(genre, forKey: "genre")
        aCoder.encode(coverUrl, forKey: "coverIrl")
        aCoder.encode(year, forKey: "year")
    }
    
    ///This code creates an initializer for the Album class. When you create a new album, you’ll pass in the album name, the artist, the genre, the album cover URL, and the year.
    init(title:String, artist:String, genre:String, coverUrl:String, year:String) {
        super.init()
        self.title = title
        self.artist = artist
        self.genre = genre
        self.coverUrl = coverUrl
        self.year = year
    }
    
    ///The method description() returns a string representation of the album’s attributes.
    override var description: String {
        return "title: \(title)" +
               "artist: \(artist)" +
               "genere: \(genre)" +
               "coverUrl: \(coverUrl)" +
               "year: \(year)"
    }

}

//
//  Album.swift
//  DesignPatterns
//
//  Created by ALIREZA TABRIZI on 11/10/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit

class Album: NSObject {

    var title : String!
    var artist : String!
    var genere : String!
    var coverUrl : String!
    var year : String!
    
    ///This code creates an initializer for the Album class. When you create a new album, you’ll pass in the album name, the artist, the genre, the album cover URL, and the year.
    init(title:String, artist:String, genere:String, coverUrl:String, year:String) {
        super.init()
        self.title = title
        self.artist = artist
        self.genere = genere
        self.coverUrl = coverUrl
        self.year = year
    }
    
    ///The method description() returns a string representation of the album’s attributes.
    override var description: String {
        return "title: \(title)" +
               "artist: \(artist)" +
               "genere: \(genere)" +
               "coverUrl: \(coverUrl)" +
               "year: \(year)"
    }
}

//
//  AlbumExtensions.swift
//  DesignPatterns
//
//  Created by ALIREZA TABRIZI on 11/12/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

///Note: Classes can of course override a superclass’s method, but with extensions you can’t. Methods or properties in an extension cannot have the same name as methods or properties in the original class.

import Foundation

//Notice there’s a ae_ at the beginning of the method name, as an abbreviation of the name of the extension: AlbumExtension. Conventions like this will help prevent collisions with methods (including possible private methods you might not know about) in the original implementation.
extension Album {
    func ae_tableRepresentation() -> (titles:[String], values:[String]) {
        return (["Artist", "Album", "Genre", "Year"], [artist, title, genre, year])
    }
}

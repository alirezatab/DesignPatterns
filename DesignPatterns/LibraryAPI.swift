//
//  LibraryAPI.swift
//  DesignPatterns
//
//  Created by ALIREZA TABRIZI on 11/10/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit

class LibraryAPI: NSObject {
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
 
 
 
 
 
 
 

//
//  WalletClass.swift
//  GroupProject
//
//  Created by Yi on 8/28/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

import UIKit
import Foundation

class WalletClass {
    
    var photosArray = [PFObject]()
    
    class var sharedInstance: WalletClass {
        struct Static {
            static var instance: WalletClass?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = WalletClass()
        }
        
        return Static.instance!
    }
    
    func getPhotosArray() -> [PFObject] {
        return self.photosArray
    }
    
    func getAllPhotos() {
        photosArray = []
        var query = PFQuery(className: "PhotoClass")
        query.whereKey("uid", equalTo: PFUser.currentUser().username)
        query.findObjectsInBackgroundWithBlock({
            (block: [AnyObject]!, error: NSError!) in
            if error == nil {
                println("getting \(block.count) photos")
                for row in block {
                    var object = row as PFObject
                    self.photosArray.append(object)
                }
                println("photosArray has \(self.photosArray.count) photos")
                println("photosArray2 has \(self.getPhotosArray().count) photos")
                NSNotificationCenter.defaultCenter().postNotificationName("kUpdatedPhotoArray", object: nil)
            } else {
                
            }
        })
    }
    
}

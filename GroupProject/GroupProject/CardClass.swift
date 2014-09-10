//
//  CardClass.swift
//  GroupProject
//
//  Created by Yi on 9/4/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

import UIKit
import Foundation

class CardClass {
    
    var title: String!
    var imageArray: [UIImage]!
    var uid: PFUser!
    var tags: [String]!
    var isFavorite: Bool!

    init(title: String, imageArray: [UIImage], uid: PFUser, tags: [String], isFavorite: Bool) {
        self.title = title
        self.imageArray = imageArray
        self.uid = uid
        self.tags = tags
        self.isFavorite = isFavorite
        
        var object = PFObject(className: "CardClass")
        for image in imageArray {
            var imageData = UIImageJPEGRepresentation(image, 1)
            var imageFile = PFFile(name: "image.png", data: imageData)
            object.addObject(imageFile, forKey: "imageFileArray")
        }
        
        var wallet = WalletClass.sharedInstance
        object["title"] = title
        object["uid"] = uid
        object["tags"] = tags
        object["isFavorite"] = isFavorite
        
        wallet.cardsArray.insert(object, atIndex: 0)
        NSNotificationCenter.defaultCenter().postNotificationName("kUpdatedCardsArray", object: nil)
        
        object.saveInBackgroundWithBlock {
            (finished: Bool, error: NSError!) -> Void in
            if error == nil {
                println("finished creating card")
            } else {
                
            }
        }
    }
   
}

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
<<<<<<< HEAD
    var imageArray: [UIImage]!
    var uid: PFUser!
    var tags: [String]!
    var isFavorite: Bool!

    init(title: String, imageArray: [UIImage], uid: PFUser, tags: [String], isFavorite: Bool) {
=======
    var imageArray: [UIImage]
    var uid: String!
    var tags = [String]()

    init(title: String, imageArray: [UIImage], uid: String, tags: [String]) {
>>>>>>> FETCH_HEAD
        self.title = title
        self.imageArray = imageArray
        self.uid = uid
        self.tags = tags
<<<<<<< HEAD
        self.isFavorite = isFavorite
=======
>>>>>>> FETCH_HEAD
        
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
<<<<<<< HEAD
        object["isFavorite"] = isFavorite
        
        wallet.cardsArray.insert(object, atIndex: 0)
        NSNotificationCenter.defaultCenter().postNotificationName("kUpdatedCardsArray", object: nil)
        
        object.saveInBackgroundWithBlock {
            (finished: Bool, error: NSError!) -> Void in
            if error == nil {
//                wallet.getAllCards()
                println("finished creating card")
            } else {
                
=======
        object.saveInBackgroundWithBlock {
            (finished: Bool, error: NSError!) -> Void in
            if error == nil {
                wallet.getAllCards()
>>>>>>> FETCH_HEAD
            }
        }
    }
   
}

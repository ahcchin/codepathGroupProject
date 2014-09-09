//
//  TagClass.swift
//  GroupProject
//
//  Created by Andrew Chin on 9/8/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

import UIKit
import Foundation


class TagClass: NSObject {
   
    var uid: String!
    var tagArray: [String]!
    
    init(uid: String, tags: [String]) {
        
        self.uid = uid
        self.tags = tags
        
        var object = PFObject(className: "TagClass")
        for tags in tagArray {
            var imageData = UIImageJPEGRepresentation(image, 1)
            var imageFile = PFFile(name: "image.png", data: imageData)
            object.addObject(imageFile, forKey: "imageFileArray")
        }
        
        var wallet = WalletClass.sharedInstance
        object["title"] = title
        object["uid"] = uid
        object["tags"] = tags
        object.saveInBackgroundWithBlock {
            (finished: Bool, error: NSError!) -> Void in
            if error == nil {
                wallet.getAllCards()
            }
        }
    }
    
}
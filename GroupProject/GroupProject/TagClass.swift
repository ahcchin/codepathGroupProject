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
   
    var uid: PFUser!
    var tag: String!
    
    init(uid: PFUser, tag: String) {
        
        self.uid = uid
        self.tag = tag
        
        var object = PFObject(className: "TagClass")
        
        object["uid"] = uid
        object["tag"] = tag
        object.saveInBackgroundWithBlock {
            (finished: Bool, error: NSError!) -> Void in
            if error == nil {

            }
        }
    }
    
}
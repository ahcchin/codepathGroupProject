//
//  PhotoClass.swift
//  GroupProject
//
//  Created by Yi on 8/20/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

class PhotoClass {
    
    var title: String!
    var url: String!
    var uid: String!
    var tags = [String]()
    
    init(title: String, url: String, uid: String, tags: [String]) {
        self.title = title
        self.url = url
        self.uid = uid
        self.tags = tags
        
        var object = PFObject(className: "PhotoClass")
        object["title"] = title
        object["url"] = url
        object["uid"] = uid
        object["tags"] = tags
        object.saveInBackground()
    }

}

//
//  PhotoClass.swift
//  GroupProject
//
//  Created by Yi on 8/20/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

class PhotoClass {
    
    var title: String!
    var image: UIImage!
    var uid: String!
    var tags = [String]()
    
    init(title: String, image: UIImage, uid: String, tags: [String]) {
        self.title = title
        self.image = image
        self.uid = uid
        self.tags = tags
        
        var imageData = UIImagePNGRepresentation(image)
        var imageFile = PFFile(name: "image.png", data: imageData)
        var wallet = WalletClass.sharedInstance
        
        var object = PFObject(className: "PhotoClass")
        object["title"] = title
        object["imageFile"] = imageFile
        object["uid"] = uid
        object["tags"] = tags
        object.saveInBackgroundWithBlock {
            (finished: Bool, error: NSError!) -> Void in
            if error == nil {
                wallet.getAllPhotos()
            }
        }
    }

}

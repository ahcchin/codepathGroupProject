//
//  HomeViewController.swift
//  GroupProject
//
//  Created by Yi on 8/17/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var uid: String!
    @IBOutlet weak var photoImageView: UIImageView!
    var images = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uid = UIDevice.currentDevice().identifierForVendor.UUIDString
        
//        var object = PFObject(className: "TestClass")
//        object.addObject("Banana", forKey: "favoriteFood")
//        object.addObject("Chocolate", forKey: "favoriteIceCream")
//        object.saveInBackground()
        
//        signUp()
        setImage()
        
//        var photo = PhotoClass(title: "title", url: "https://dt8kf6553cww8.cloudfront.net/static/images/brand/logotype-vflFbF9pY.png", uid: PFUser.currentUser().username, tags: [])
//        var photo = PhotoClass(title: "title2", url: "https://dt8kf6553cww8.cloudfront.net/static/images/brand/logotype-vflFbF9pY.png", uid: "asdfasdf", tags: [])
        
    }
    
    func setImage2() {
        var query = PFQuery(className: "UserPhoto")
        query.findObjectsInBackgroundWithBlock({
            (block: [AnyObject]!, error: NSError!) in
            if (!error) {
                println("fetching a photos")
                var i = 0
                for item in block {
                    println(item["imageFile"])
                    println(i)
                    var object = item as PFObject
                    self.images.append(object.objectForKey("imageFile"))
                    self.images[i].getDataInBackgroundWithBlock({
                        (imageData: NSData!, error: NSError!) in
                        if (!error) {
                            //var uiImage = UIImage(data: imageData)
                        } else {
                            
                        }
                    })
                    i++
                }
                
            } else {
                
            }
        })
    }
    
    func setImage() {
        var query = PFQuery(className: "UserPhoto")
        var object = query.getFirstObject() as PFObject
        println("Trying some shit")
        println(object)
        let userImageFile = object["imageFile"] as PFFile
        userImageFile.getDataInBackgroundWithBlock({
            (imageData: NSData!, error: NSError!) -> Void in
            if !error {
                let image = UIImage(data:imageData)
            }
        })
    }
    
    
    
    func saveImage() {
        var imageData = UIImagePNGRepresentation(photoImageView.image)
        var imageFile = PFFile(name: "image.png", data: imageData)
        
        var object = PFObject(className: "UserPhoto")
        object.addObject(imageFile, forKey: "imageFile")
        object.saveInBackground()
    }
    
    func getAllPhotos() {
        var query = PFQuery(className: "PhotoClass")
        query.whereKey("uid", equalTo: PFUser.currentUser().username)
        query.findObjectsInBackgroundWithBlock({
            (block: [AnyObject]!, error: NSError!) in
            if (!error) {
                println("getting all photos")
                for item in block {
                    println(item)
                }
            } else {
                
            }
        })
        
    }
    
    func signUp() {
        var user = PFUser()
        user.username = uid
        user.password = uid
        
        user.signUpInBackgroundWithBlock({
            (succeed: Bool, error: NSError!) in
            if (!error) {
                println("Signed up...")
                println(PFUser.currentUser())
            } else {
                if error.code == 202 {
                    println("Signing in...")
                    self.signIn()
                }
            }
        })
    }
    
    func signIn() {
        PFUser.logInWithUsernameInBackground(uid, password: uid)
        println(PFUser.currentUser().username)
//        self.getAllPhotos()
//        self.saveImage()
        self.setImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

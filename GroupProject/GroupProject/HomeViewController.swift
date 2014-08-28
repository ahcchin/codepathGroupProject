//
//  HomeViewController.swift
//  GroupProject
//
//  Created by Yi on 8/17/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var uid: String!
    @IBOutlet weak var photoImageView: UIImageView!
    var photosArray = [PFObject]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uid = UIDevice.currentDevice().identifierForVendor.UUIDString
        tableView.hidden = true
        signUp()
    }
    
    func randomFunc() {
        var photo = PhotoClass(title: "title1", url: "https://dt8kf6553cww8.cloudfront.net/static/images/brand/logotype-vflFbF9pY.png", uid: PFUser.currentUser().username, tags: [])
        var photo1 = PhotoClass(title: "title2", url: "https://dt8kf6553cww8.cloudfront.net/static/images/brand/logotype-vflFbF9pY.png", uid: PFUser.currentUser().username, tags: [])
        var photo2 = PhotoClass(title: "title3", url: "https://dt8kf6553cww8.cloudfront.net/static/images/brand/logotype-vflFbF9pY.png", uid: PFUser.currentUser().username, tags: [])
        var photo3 = PhotoClass(title: "title4", url: "https://dt8kf6553cww8.cloudfront.net/static/images/brand/logotype-vflFbF9pY.png", uid: PFUser.currentUser().username, tags: [])
        var photo4 = PhotoClass(title: "title5", url: "https://dt8kf6553cww8.cloudfront.net/static/images/brand/logotype-vflFbF9pY.png", uid: PFUser.currentUser().username, tags: [])
    }
    
    func setImage() {
        var query = PFQuery(className: "UserPhoto")
        var object = query.getFirstObject() as PFObject
        var userImageFile = object["imageFile"] as PFFile
        println(userImageFile)
        userImageFile.getDataInBackgroundWithBlock({
            (imageData: NSData!, error: NSError!) -> Void in
            if error == nil {
                self.photoImageView.image = UIImage(data:imageData)
            } else {
                println(error)
            }
        })
    }
    
    func saveImage() {
        var imageData = UIImagePNGRepresentation(photoImageView.image)
        var imageFile = PFFile(name: "image.png", data: imageData)
        
        var object = PFObject(className: "UserPhoto")
        object["imageFile"] = imageFile
        object.saveInBackground()
    }
    
    func getAllPhotos() {
        var query = PFQuery(className: "PhotoClass")
        query.whereKey("uid", equalTo: PFUser.currentUser().username)
        query.findObjectsInBackgroundWithBlock({
            (block: [AnyObject]!, error: NSError!) in
            if error == nil {
                println("getting \(block.count) photos")
                for item in block {
                    var row = item as PFObject
                    self.photosArray.append(row)
                }
                self.tableView.reloadData()
            } else {
                
            }
        })
    }
    
    func startAppWithUser() {
//        randomFunc()
        getAllPhotos()
        tableView.hidden = false
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        println("number rows in table \(photosArray.count)")
        return photosArray.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as PhotoTableViewCell
        var row = photosArray[indexPath.row]
        var title = row["title"] as String
        cell.mainTitle.text = title
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
    }
    
    func signUp() {
        var user = PFUser()
        user.username = uid
        user.password = uid
        
        user.signUpInBackgroundWithBlock({
            (succeed: Bool, error: NSError!) in
            if error == nil {
                // Sign up is successful. This was a new user.
                self.startAppWithUser()
            } else {
                if error.code == 202 {
                    // Sign up failed. There's already a user with this username.
                    self.signIn()
                }
            }
        })
    }
    
    func signIn() {
        PFUser.logInWithUsernameInBackground(uid, password: uid) {
            (user: PFUser!, error: NSError!) -> Void in
            if error == nil {
                self.startAppWithUser()
            } else {
                
            }
        }
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

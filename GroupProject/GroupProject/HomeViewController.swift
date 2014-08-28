//
//  HomeViewController.swift
//  GroupProject
//
//  Created by Yi on 8/17/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var uid: String!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTableView:" , name: "kUpdatedPhotoArray", object: nil)
        uid = UIDevice.currentDevice().identifierForVendor.UUIDString
        tableView.hidden = true
        signUp()
    }
    
    func createShit() {
        var photo = PhotoClass(title: "soething else assdaf 1", image: photoImageView.image, uid: PFUser.currentUser().username, tags: [])
        var photo1 = PhotoClass(title: "soething else assdaf 2", image: photoImageView.image, uid: PFUser.currentUser().username, tags: [])
        var photo2 = PhotoClass(title: "soething else assdaf 3", image: photoImageView.image, uid: PFUser.currentUser().username, tags: [])
    }
    
    @IBAction func refreshButton(sender: AnyObject) {
        var wallet = WalletClass.sharedInstance
        wallet.getAllPhotos()
//        tableView.reloadData()
    }
    
    func startAppWithUser() {
//        createShit()
        var wallet = WalletClass.sharedInstance
        wallet.getAllPhotos()
        tableView.hidden = false
        tableView.contentInset.top = navigationController.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.size.height
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        var wallet = WalletClass.sharedInstance
        println("number rows in table \(wallet.getPhotosArray().count)")
        return wallet.getPhotosArray().count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as PhotoTableViewCell
        var wallet = WalletClass.sharedInstance
        var row = wallet.getPhotosArray()[indexPath.row]
        var title = row["title"]
        cell.mainTitle.text = "\(title)"
        
        var cellImageFile = row["imageFile"] as PFFile
        cellImageFile.getDataInBackgroundWithBlock({
            (imageData: NSData!, error: NSError!) -> Void in
            if error == nil {
                cell.photoImageView.image = UIImage(data:imageData)
            } else {
                
            }
        })
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
    }
    
    func updateTableView(notification: NSNotification!) {
        var wallet = WalletClass.sharedInstance
        println("updating table with \(wallet.getPhotosArray().count) cells")
        tableView.reloadData()
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
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        var chosenImage = info[UIImagePickerControllerEditedImage] as UIImage
        var photo = PhotoClass(title: "soething else assdaf 1", image: chosenImage, uid: PFUser.currentUser().username, tags: [])
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onCameraButton(sender: AnyObject) {
        var picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(picker, animated: true, completion: nil)
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

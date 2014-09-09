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
    var picker: UIImagePickerController!
    var selectedCard: Int!
    var zoomTransition: ZoomTransition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTableView:" , name: "kUpdatedCardsArray", object: nil)
        uid = UIDevice.currentDevice().identifierForVendor.UUIDString
        tableView.hidden = true
        signUp()
    }
    
    func createShit() {
        var photo = CardClass(title: "soething else assdaf 1", imageArray: [photoImageView.image], uid: PFUser.currentUser(), tags: [], isFavorite: false)
    }
    
    func startAppWithUser() {
//        createShit()
//        var tag1 = TagClass(uid: PFUser.currentUser(), tag: "Credit/Debit Card")
//        var tag2 = TagClass(uid: PFUser.currentUser(), tag: "Insurance")
//        var tag3 = TagClass(uid: PFUser.currentUser(), tag: "Business Cards")
//        var tag4 = TagClass(uid: PFUser.currentUser(), tag: "Membership")
//        var tag5 = TagClass(uid: PFUser.currentUser(), tag: "Coupon")
        
        var wallet = WalletClass.sharedInstance
        wallet.getAllCards()
        wallet.getTags()
        tableView.hidden = false
        tableView.contentInset.top = navigationController.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.size.height
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        var wallet = WalletClass.sharedInstance
        return wallet.getCardsArray().count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as PhotoTableViewCell
        var wallet = WalletClass.sharedInstance
        var row = wallet.getCardsArray()[indexPath.row]
        var title = row["title"] as String
        cell.mainTitle.text = title
        
        var cellImageFileArray = row["imageFileArray"] as [AnyObject]
        for imageFile in cellImageFileArray {
            var cellImageFile = imageFile as PFFile
            cellImageFile.getDataInBackgroundWithBlock({
                (imageData: NSData!, error: NSError!) -> Void in
                if error == nil {
                    cell.photoImageView.image = UIImage(data:imageData)
                } else {
                    
                }
            })
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        selectedCard = indexPath.row
        performSegueWithIdentifier("viewCardSegue", sender: self)
    }
    
    func updateTableView(notification: NSNotification!) {
        var wallet = WalletClass.sharedInstance
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
        println("Chose photo")
        var chosenImage = info[UIImagePickerControllerOriginalImage] as UIImage
        var photo = CardClass(title: "soething else assdaf 1", imageArray: [chosenImage], uid: PFUser.currentUser(), tags: [], isFavorite: false)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        println("Cancelled")
        if picker.sourceType == UIImagePickerControllerSourceType.PhotoLibrary {
            picker.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func onCameraButton(sender: AnyObject) {
        picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.cameraDevice = UIImagePickerControllerCameraDevice.Rear
        picker.showsCameraControls = false
        
        var overlay = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 100, width: self.view.frame.width, height: 100))
        
        var shootButton = UIButton(frame: CGRect(x: (self.view.frame.width - 100) / 2, y: 0, width: 100, height: 100))
        shootButton.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        shootButton.addTarget(self, action: Selector("takePhoto"), forControlEvents: UIControlEvents.TouchUpInside)
        overlay.addSubview(shootButton)
        
        var cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        cancelButton.backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
        cancelButton.addTarget(self, action: Selector("cancelPhoto"), forControlEvents: UIControlEvents.TouchUpInside)
        overlay.addSubview(cancelButton)
        
        var chooseButton = UIButton(frame: CGRect(x: self.view.frame.width - 100, y: 0, width: 100, height: 100))
        chooseButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        chooseButton.addTarget(self, action: Selector("choosePhoto"), forControlEvents: UIControlEvents.TouchUpInside)
        overlay.addSubview(chooseButton)
        
        picker.cameraOverlayView = overlay
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func onDeleteCardButton(sender: AnyObject) {
        var wallet = WalletClass.sharedInstance
        wallet.deleteCard(0)
    }
    
    func takePhoto() {
        println("pressed TakePhoto")
        picker.takePicture()
    }
    
    func choosePhoto() {
        println("pressed ChoosePhoto")
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    }
    
    func cancelPhoto() {
        println("pressed CancelPhoto")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        
//        var destinationViewController = segue.destinationViewController as CardViewController
//        var wallet = WalletClass.sharedInstance
//        destinationViewController.card = wallet.getCardsArray()[selectedCard]
//        
//        zoomTransition = ZoomTransition()
//        zoomTransition.duration = 0.3
//        
//        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
//        destinationViewController.transitioningDelegate = zoomTransition
//    }

}

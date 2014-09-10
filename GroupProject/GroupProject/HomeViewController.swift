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
    @IBOutlet weak var tableView: UITableView!
    var selectedCard: Int!
    var zoomTransition: ZoomTransition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTableView:" , name: "kUpdatedCardsArray", object: nil)
        uid = UIDevice.currentDevice().identifierForVendor.UUIDString
        tableView.hidden = true
        signUp()
    }
    
    func startAppWithUser() {
        var wallet = WalletClass.sharedInstance
        
//        var tag = wallet.
        
//        var object = PFObject(className: "GlobalTagClass")
//        object["tag"] = "Cards"
//        object.saveInBackgroundWithBlock {
//            (finished: Bool, error: NSError!) -> Void in
//            if error == nil {
//                
//            }
//        }
//        var object2 = PFObject(className: "GlobalTagClass")
//        object2["tag"] = "Memberships"
//        object2.saveInBackgroundWithBlock {
//            (finished: Bool, error: NSError!) -> Void in
//            if error == nil {
//                
//            }
//        }
//        var object3 = PFObject(className: "GlobalTagClass")
//        object3["tag"] = "Coupons"
//        object3.saveInBackgroundWithBlock {
//            (finished: Bool, error: NSError!) -> Void in
//            if error == nil {
//                
//            }
//        }
//        var object4 = PFObject(className: "GlobalTagClass")
//        object4["tag"] = "Insurance"
//        object4.saveInBackgroundWithBlock {
//            (finished: Bool, error: NSError!) -> Void in
//            if error == nil {
//                
//            }
//        }
        
        
        wallet.getAllCards()
        wallet.getTags()
        
        if wallet.getCardsArray().count > 0 {
            tableView.hidden = false
        }
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        var wallet = WalletClass.sharedInstance
        if wallet.getCardsArray().count > 0 {
            tableView.hidden = false
        }
        return wallet.getCardsArray().count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as PhotoTableViewCell
        var wallet = WalletClass.sharedInstance
        var row = wallet.getCardsArray()[indexPath.row]
        var title = row["title"] as String
        cell.mainTitle.text = title
        
        var cellImageFileArray = row["imageFileArray"] as [AnyObject]
        var cellImageFile = cellImageFileArray[0] as PFFile
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
    
    @IBAction func onDeleteCardButton(sender: AnyObject) {
        var wallet = WalletClass.sharedInstance
        wallet.deleteCard(0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "viewCardSegue" {
            var destinationViewController = segue.destinationViewController as CardViewController
            var wallet = WalletClass.sharedInstance
            destinationViewController.card = wallet.getCardsArray()[selectedCard]
            
            zoomTransition = ZoomTransition()
            zoomTransition.duration = 0.3
            
            destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            destinationViewController.transitioningDelegate = zoomTransition
        } else if segue.identifier == "createCardSegue" {
            var destinationViewController = segue.destinationViewController as CameraViewController
            
            zoomTransition = ZoomTransition()
            zoomTransition.duration = 0.3
            
            destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            destinationViewController.transitioningDelegate = zoomTransition
        }
    }

}

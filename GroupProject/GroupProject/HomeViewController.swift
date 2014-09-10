//
//  HomeViewController.swift
//  GroupProject
//
//  Created by Yi on 8/17/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var uid: String!
    @IBOutlet weak var tableView: UITableView!
    var selectedCard: Int!
    var zoomTransition: ZoomTransition!
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var selectedTagIDs: [String]! = [String]()
    var filteredCardArray: [PFObject]! = [PFObject]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTableView:" , name: "kUpdatedCardsArray", object: nil)
        uid = UIDevice.currentDevice().identifierForVendor.UUIDString
        tableView.hidden = true
        signUp()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTagCollectionView:" , name: "kUpdatedTagsArray", object: nil)
        var wallet = WalletClass.sharedInstance
        for row in wallet.getTagsArray() {
            row["selected"] = false
        }
    }

    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        var wallet = WalletClass.sharedInstance
        println("wallet tag array count \(wallet.getTagsArray().count)")
        
        return wallet.getTagsArray().count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        var wallet = WalletClass.sharedInstance
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("tagCell", forIndexPath: indexPath) as TagCollectionViewCell
        var row = wallet.getTagsArray()[indexPath.row]
        cell.tagLabel.text = row["tag"] as String
        cell.layer.cornerRadius = 4.0
        
        if (row["selected"] as Bool == true) {
            cell.backgroundColor =  UIColor.grayColor()
            cell.tagLabel.textColor = UIColor.whiteColor()
        } else {
            cell.backgroundColor = nil
            cell.tagLabel.textColor = UIColor.grayColor()
            cell.layer.borderColor = UIColor.grayColor().CGColor
            cell.layer.borderWidth = 1.0
            
        }
        return cell
}
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        var wallet = WalletClass.sharedInstance
        var tags = wallet.getTagsArray()
        var tag = tags[indexPath.row] as PFObject
        var tagId = tag.objectId
        
        if find(selectedTagIDs, tagId) == nil {
            selectedTagIDs.append(tagId)
            tag["selected"] = true
        } else {
            selectedTagIDs.removeAtIndex(find(selectedTagIDs, tagId)!)
            tag["selected"] = false
        }
        
        filteredCardArray = []
        
        for cardObject in wallet.getCardsArray() {
            for selectedTagID in selectedTagIDs {
                if contains(cardObject["tags"] as [String], selectedTagID) {
                    if !contains(filteredCardArray, cardObject) {
                        filteredCardArray.append(cardObject)
                    }
                }
            }
        }
        
        collectionView.reloadData()
        tableView.reloadData()

    }
    
    func startAppWithUser() {
        var wallet = WalletClass.sharedInstance
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
        
        if (selectedTagIDs.count > 0) {
            return filteredCardArray.count
        }
        return wallet.getCardsArray().count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as PhotoTableViewCell
        var wallet = WalletClass.sharedInstance
        var row = wallet.getCardsArray()[indexPath.row]
        if selectedTagIDs.count > 0 {
            row = filteredCardArray[indexPath.row]
        }
        
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
        tableView.reloadData()
    }
    
    func updateTagCollectionView(notification: NSNotification!) {
        tagCollectionView.reloadData()
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

//
//  AddMetadataViewController.swift
//  GroupProject
//
//  Created by Andrew Chin on 9/4/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

import UIKit

class AddMetadataViewController: ViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet var imageCollectionView: UICollectionView!
    @IBOutlet var imageCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet var tagCollectionView: UICollectionView!
    @IBOutlet var tagCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    var cardImageArray: [UIImage]!
    var selectedTagIDs: [String]! = [String]()
    
    var tagArray = [String]()
    
//    var textLabel: [UITextLabel]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        
        imageCollectionView!.dataSource = self
        imageCollectionView!.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        titleTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        var wallet = WalletClass.sharedInstance
        if (collectionView == imageCollectionView) {
            return 3
        } else {
            return wallet.getTagsArray().count
        }
        
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        var wallet = WalletClass.sharedInstance
        if (collectionView == imageCollectionView) {
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as UICollectionViewCell
            return cell
        } else {
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
    }
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        var wallet = WalletClass.sharedInstance
        if (collectionView == imageCollectionView) {
            
        } else {
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
            collectionView.reloadData()
            
            println(tagId)
            println(selectedTagIDs)
        }
    }
    
    @IBAction func onSaveButton(sender: AnyObject) {
        var photo = CardClass(title: titleTextField.text, imageArray: cardImageArray, uid: PFUser.currentUser(), tags: selectedTagIDs, isFavorite: false)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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

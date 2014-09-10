//
//  CardViewController.swift
//  GroupProject
//
//  Created by Yi on 9/4/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

import UIKit

class CardViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var photoCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var card: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self

        navBar.topItem.title = card["title"] as String
        // Do any additional setup after loading the view.
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        println(card["imageFileArray"])
        return (card["imageFileArray"] as [AnyObject]).count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as PhotoCollectionViewCell
        cell.imageView.frame = CGRect(x: cell.imageView.frame.origin.x, y: cell.imageView.frame.origin.x, width: 320, height: 568)
        
        var imageFileArray = card["imageFileArray"] as [AnyObject]
        var cardImageFile = imageFileArray[indexPath.row] as PFFile
        cardImageFile.getDataInBackgroundWithBlock({
            (imageData: NSData!, error: NSError!) -> Void in
            if error == nil {
                cell.imageView.image = UIImage(data:imageData)
            } else {
                
            }
        })
        return cell
    }

    @IBAction func onBackButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTap(sender: AnyObject) {
        navBar.hidden = !navBar.hidden
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

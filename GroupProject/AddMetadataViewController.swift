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
    var tags: [String]!
    
//    var textLabel: [UITextLabel]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        
        imageCollectionView!.dataSource = self
        imageCollectionView!.delegate = self
        


        
//        textLabel = []
        
//        imageCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
//        imageCollectionViewFlowLayout.itemSize = CGSize(width: 90, height: 120)
//        imageCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: imageCollectionViewFlowLayout)
//        imageCollectionView!.dataSource = self
//        imageCollectionView!.delegate = self
//        imageCollectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
//        imageCollectionView!.backgroundColor = UIColor.whiteColor()
//        s elf.view.addSubview(imageCollectionView!)
        
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
        
        if (collectionView == imageCollectionView) {
            println("image collection view")
            return 3
        } else {
            println("tag collection view")
            return 5
        }
        
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        if (collectionView == imageCollectionView) {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as UICollectionViewCell
            //        cell.backgroundColor = UIColor.orangeColor()
            println("image collection view dequeue")
            return cell


        } else {
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("tagCell", forIndexPath: indexPath) as UICollectionViewCell
            //        cell.backgroundColor = UIColor.orangeColor()
            println("tag collection view dequeue")
            return cell

        }
    }
    
    @IBAction func onSaveButton(sender: AnyObject) {
        var newCard: CardClass!
        newCard.title = titleTextField.text
        newCard.imageArray = cardImageArray
        newCard.uid = PFUser.currentUser().username
        newCard.tags = tags
        
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            //go back to camera view
        })
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

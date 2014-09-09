//
//  CardViewController.swift
//  GroupProject
//
//  Created by Yi on 9/4/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var card: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var imageFileArray = card["imageFileArray"] as [AnyObject]
        for imageFile in imageFileArray {
            var cardImageFile = imageFile as PFFile
            cardImageFile.getDataInBackgroundWithBlock({
                (imageData: NSData!, error: NSError!) -> Void in
                if error == nil {
                    self.imageView.image = UIImage(data:imageData)
                } else {
                    
                }
            })
        }
        
        // Do any additional setup after loading the view.
    }

    @IBAction func onBackButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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

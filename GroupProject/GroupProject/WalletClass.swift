//
//  WalletClass.swift
//  GroupProject
//
//  Created by Yi on 8/28/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

import UIKit
import Foundation

class WalletClass {
    
    var cardsArray = [PFObject]()
    
    class var sharedInstance: WalletClass {
        struct Static {
            static var instance: WalletClass?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = WalletClass()
        }
        
        return Static.instance!
    }
    
    func getCardsArray() -> [PFObject] {
        return self.cardsArray
    }
    
    func getAllCards() {
        cardsArray = []
        var query = PFQuery(className: "CardClass")
<<<<<<< HEAD
        query.whereKey("uid", equalTo: PFUser.currentUser())
        query.orderByDescending("createdAt")
=======
        query.whereKey("uid", equalTo: PFUser.currentUser().username)
>>>>>>> FETCH_HEAD
        query.findObjectsInBackgroundWithBlock({
            (block: [AnyObject]!, error: NSError!) in
            if error == nil {
                println("getting \(block.count) photos")
                for row in block {
                    var object = row as PFObject
                    self.cardsArray.append(object)
                }
                NSNotificationCenter.defaultCenter().postNotificationName("kUpdatedCardsArray", object: nil)
            } else {
                
            }
        })
    }
    
    func deleteCard(index: Int) {
        self.cardsArray.removeAtIndex(index)
<<<<<<< HEAD
        NSNotificationCenter.defaultCenter().postNotificationName("kUpdatedCardsArray", object: nil)
        cardsArray[index].deleteInBackgroundWithBlock { (finished: Bool, error: NSError!) -> Void in
            if error == nil {
                
            } else {
                
            }
=======
        cardsArray[index].deleteInBackgroundWithBlock { (finished: Bool, error: NSError!) -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("kUpdatedCardsArray", object: nil)
>>>>>>> FETCH_HEAD
        }
    }
    
}

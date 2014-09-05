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
        query.whereKey("uid", equalTo: PFUser.currentUser().username)
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
        cardsArray[index].deleteInBackgroundWithBlock { (finished: Bool, error: NSError!) -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("kUpdatedCardsArray", object: nil)
        }
    }
    
}

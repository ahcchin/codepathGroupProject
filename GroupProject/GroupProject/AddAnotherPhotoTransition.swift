//
//  AddAnotherPhotoTransition.swift
//  GroupProject
//
//  Created by Yi on 9/9/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

import UIKit

class AddAnotherPhotoTransition: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    var isPresenting: Bool!
    var duration: NSTimeInterval!
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!) {
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        if isPresenting == true {
            
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            
            UIView.animateWithDuration(duration, animations: {
                toViewController.view.alpha = 1
                }, completion: {
                    (finished: Bool) in
                    transitionContext.completeTransition(true)
                    var cameraViewController = toViewController as CameraViewController
                    cameraViewController.didAddAnother = true
            })
            
        } else {
            
            toViewController.view.alpha = 0
            
            var addMetadataViewController = (toViewController as AddMetadataViewController)
            var selectedImage = (fromViewController as CameraViewController).selectedImage
            addMetadataViewController.cardImageArray.removeLast()
            addMetadataViewController.cardImageArray.append(selectedImage)
            addMetadataViewController.cardImageArray.append(UIImage(named: "AddPhoto"))
            addMetadataViewController.imageCollectionView.reloadData()
            addMetadataViewController.titleTextField.becomeFirstResponder()
            (fromViewController as CameraViewController).didAddAnother = false
            
            UIView.animateWithDuration(duration, animations: {
                toViewController.view.alpha = 1
                }, completion: {
                    (finished: Bool) in
                    transitionContext.completeTransition(true)
            })
        }
    }
   
}

//
//  ZoomTransition.swift
//  GroupProject
//
//  Created by Yi on 9/5/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

import UIKit

class ZoomTransition: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
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
            })
            
        } else {
            
            toViewController.view.alpha = 0
            
            UIView.animateWithDuration(duration, animations: {
                toViewController.view.alpha = 1
                }, completion: {
                    (finished: Bool) in
                    transitionContext.completeTransition(true)
                    if toViewController is CameraViewController {
                        if (fromViewController as AddMetadataViewController).didSave == true {
                            toViewController.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            (toViewController as CameraViewController).showCamera()
                        }
                    }
                    
            })
        }
    }
    
}

//
//  CameraViewController.swift
//  GroupProject
//
//  Created by Yi on 8/17/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var picker: UIImagePickerController!
    var selectedImage: UIImage!
    var didCancelCamera: Bool!
    var didChoosePhoto: Bool!
    var didCancelDetails: Bool!
    var didAddAnother: Bool!
    var zoomTransition: ZoomTransition!

    override func viewDidLoad() {
        super.viewDidLoad()

        didCancelCamera = false
        didChoosePhoto = false
        didCancelDetails = false
        didAddAnother = false
        
        println("view did load")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        println("viewDidAppear in CameraView \(didAddAnother)")
        if didCancelCamera == false && didChoosePhoto == false || didCancelDetails == true {
            showCamera()
        } else {
            if didChoosePhoto == true {
                println("didChoosePhoto in viewDidAppear")
                if didAddAnother == true {
                    println("dismissed to go back to addMeta")
                    dismissViewControllerAnimated(true, completion: nil)
                } else {
                    println("performed segue to go to addMeta")
                    performSegueWithIdentifier("addCardDetailsSegue", sender: self)
                }
            } else {
                dismissViewControllerAnimated(false, completion: nil)
            }
        }
    }
    
    func showCamera() {
        didCancelCamera = false
        didChoosePhoto = false
        didCancelDetails = false
        
        picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.cameraDevice = UIImagePickerControllerCameraDevice.Rear
        picker.showsCameraControls = false
        
        var overlay = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 120, width: self.view.frame.width, height: 100))
        
        var shootButton = UIButton(frame: CGRect(x: (self.view.frame.width - 100) / 2, y: 0, width: 100, height: 100))
        shootButton.setImage(UIImage(named: "TakePhoto"), forState: UIControlState.Normal)
        shootButton.addTarget(self, action: Selector("takePhoto"), forControlEvents: UIControlEvents.TouchUpInside)
        overlay.addSubview(shootButton)
        
        var cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: Selector("cancelPhoto"), forControlEvents: UIControlEvents.TouchUpInside)
        overlay.addSubview(cancelButton)
        
        var chooseButton = UIButton(frame: CGRect(x: self.view.frame.width - 100, y: 0, width: 100, height: 100))
        chooseButton.setTitle("Choose", forState: UIControlState.Normal)
        chooseButton.addTarget(self, action: Selector("choosePhoto"), forControlEvents: UIControlEvents.TouchUpInside)
        overlay.addSubview(chooseButton)
        
        picker.cameraOverlayView = overlay
        presentViewController(picker, animated: false, completion: nil)
    }
    
    @IBAction func onButtonTap(sender: AnyObject) {
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        selectedImage = info[UIImagePickerControllerOriginalImage] as UIImage
        didChoosePhoto = true
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        if picker.sourceType == UIImagePickerControllerSourceType.PhotoLibrary {
            picker.sourceType = UIImagePickerControllerSourceType.Camera
        }
    }
    
    func takePhoto() {
        picker.takePicture()
    }
    
    func choosePhoto() {
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    }
    
    func cancelPhoto() {
        didCancelCamera = true
        dismissViewControllerAnimated(false, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        var destinationViewController = segue.destinationViewController as AddMetadataViewController
        destinationViewController.cardImageArray = [selectedImage]
        
        zoomTransition = ZoomTransition()
        zoomTransition.duration = 0.3
        
        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationViewController.transitioningDelegate = zoomTransition
    }

}

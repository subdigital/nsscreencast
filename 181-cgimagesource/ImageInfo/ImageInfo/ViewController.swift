//
//  ViewController.swift
//  ImageInfo
//
//  Created by Ben Scheirman on 6/30/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var downloadButton: UIBarButtonItem!
    @IBOutlet var downloadProgressView: UIProgressView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var imageInfoPan: UIScreenEdgePanGestureRecognizer!
    
    var rightEdgeConstraint: NSLayoutConstraint?
    var imageInfoVC: ImageInfoController?
    var blurContainer: UIView!
    
    let operationQueue = NSOperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pan = UIPanGestureRecognizer(target: self, action: Selector("screenEdgePan:"))
        view.addGestureRecognizer(pan)
        
        imageInfoVC = createImageInfoViewController()
    }
    
    @IBAction func downloadButtonTapped(sender: AnyObject) {
        downloadButton.enabled = false
        
        let url = NSURL(string: "https://benpublic.s3.amazonaws.com/falls-large.jpg")!
        
        let docsDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first! as! String
        let targetPath = docsDir.stringByAppendingPathComponent("falls.jpg")

        let downloadOperation = DownloadImageOperation(imageURL: url, targetPath: targetPath)
        
        downloadOperation.progressBlock = { self.downloadProgressView.progress = $0 }
        
        var size = CGSize(width: imageView.bounds.size.width * 2, height: imageView.bounds.size.height * 2)
        let resizeOperation = ResizeImageOperation(path: targetPath, containingSize: size)
        resizeOperation.addDependency(downloadOperation)
        
        resizeOperation.completionBlock = {
            if let image = UIImage(contentsOfFile: resizeOperation.resizedImagePath) {
                self.displayImage(image)
            }
        }
        
        let imageStats = ImageStatsOperation(path: targetPath)
        imageStats.addDependency(downloadOperation)
        imageStats.completionBlock = {
            dispatch_async(dispatch_get_main_queue()) {
                self.imageInfoVC!.updateWithImageProperties(imageStats.imageProperties!)
            }
        }
        
        operationQueue.suspended = true
        operationQueue.addOperation(downloadOperation)
        operationQueue.addOperation(resizeOperation)
        operationQueue.addOperation(imageStats)
        
        operationQueue.suspended = false
    }
    
    func displayImage(image: UIImage) {
        imageInfoPan.enabled = true
        imageView.alpha = 0
        dispatch_async(dispatch_get_main_queue()) {
            self.imageView.image = image
            UIView.animateWithDuration(0.3) {
                self.imageView.alpha = 1
                self.toolbar.alpha = 0
            }
        }
    }
    
    func createImageInfoViewController() -> ImageInfoController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ImageInfoController") as! ImageInfoController
        vc.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        return vc
    }
    
    @IBAction func screenEdgePan(pan: UIPanGestureRecognizer) {
        
        let width = CGFloat(400.0)
        switch pan.state {
        case .Began:
            if blurContainer == nil {
                let blur = UIBlurEffect(style: .Dark)
                blurContainer = UIVisualEffectView(effect: blur)
                blurContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
                blurContainer.addSubview(imageInfoVC!.view)
                
                imageInfoVC!.willMoveToParentViewController(self)
                imageInfoVC!.view.backgroundColor = UIColor.clearColor()
                addChildViewController(imageInfoVC!)
                view.addSubview(blurContainer)
                
                // info constraints
                NSLayoutConstraint.activateConstraints(
                    NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: nil, metrics: nil, views: ["view": imageInfoVC!.view])
                )
                
                NSLayoutConstraint.activateConstraints(
                    NSLayoutConstraint.constraintsWithVisualFormat("|[view]|", options: nil, metrics: nil, views: ["view": imageInfoVC!.view])
                )
                
                // blur constraints
                NSLayoutConstraint.activateConstraints(
                    NSLayoutConstraint.constraintsWithVisualFormat("V:|[blur]|", options: nil, metrics: nil, views: ["blur": blurContainer])
                )
                
                NSLayoutConstraint.activateConstraints(
                    NSLayoutConstraint.constraintsWithVisualFormat("[blur(w)]", options: nil, metrics: ["w": width], views: ["blur": blurContainer])
                )
                
                rightEdgeConstraint = NSLayoutConstraint(item: blurContainer, attribute: NSLayoutAttribute.Right, relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: width)
                NSLayoutConstraint.activateConstraints([
                    rightEdgeConstraint!
                ])
                
            }
            
        case .Changed:
            let translation = pan.translationInView(self.view).x
            rightEdgeConstraint?.constant += translation
            if rightEdgeConstraint?.constant < 0 {
                rightEdgeConstraint?.constant = 0
            }
            pan.setTranslation(CGPointZero, inView: view)
            blurContainer.layoutIfNeeded()
            
            
        case .Ended:
            let velocity = pan.velocityInView(view).x
            let prevConstant = rightEdgeConstraint!.constant
            if velocity > 0 {
                rightEdgeConstraint!.constant = width
            } else {
                rightEdgeConstraint!.constant = 0
            }
            
            let distance = fabs(prevConstant - rightEdgeConstraint!.constant)
            let duration = NSTimeInterval(distance/velocity)
            
            UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.blurContainer.layoutIfNeeded()
            }, completion: nil)
            
        default:
            break
        }
        
        
    }
}


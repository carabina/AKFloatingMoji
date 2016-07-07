/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The transitioning delegate used for the AKFloatingMojiViewController presentation.
 */

import UIKit

class AKFloatingMojiTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var presentationIsInteractive = false
    var currentTransitionProgress: CGFloat = 0.0 {
        didSet {
            currentInteractionController?.update(currentTransitionProgress)
        }
    }
    func completeCurrentInteractiveTransition() {
        currentInteractionController?.finish()
    }
    func cancelCurrentInteractiveTransition() {
        currentInteractionController?.cancel()
    }
    
    private var currentInteractionController: AKFloatingMojiInteractionController? = nil
    
    func animationController(forPresentedController presented: UIViewController, presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AKFloatingMojiPresentAnimator()
    }
    
    private func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AKFloatingMojiDismissAnimator()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return AKFloatingMojiPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func interactionController(forPresentation animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if presentationIsInteractive {
            currentInteractionController = AKFloatingMojiInteractionController()
            return currentInteractionController
        }
        else {
            return nil
        }
    }
}

//
//  FlipDismissAnimationController.swift
//  GuessThePet
//
//  Created by WeiShengkun on 2/23/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class FlipDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var destinationFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        let finalFrame = destinationFrame
        
        let snapshot = fromVC.view.snapshotView(afterScreenUpdates: true)!
        snapshot.layer.cornerRadius = 25
        snapshot.clipsToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        
        fromVC.view.isHidden = true
        
        AnimationHelper.perspectiveTransformForContainerView(containerView)
        toVC.view.layer.transform = AnimationHelper.yRotation(-Double.pi/2)
        
        
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3, animations: { 
                snapshot.frame = finalFrame
                
            })
            
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: { 
                snapshot.layer.transform = AnimationHelper.yRotation(Double.pi / 2)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: { 
                toVC.view.layer.transform = AnimationHelper.yRotation(0)
            })
            
        }) { (_) in
            fromVC.view.isHidden = false
            snapshot.removeFromSuperview()
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
}

//
//  FlipPresentAnimationController.swift
//  GuessThePet
//
//  Created by WeiShengkun on 2/23/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class FlipPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        let containerView = transitionContext.containerView
        
        let initialFrame = originFrame
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        
        let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)!
        snapshot.frame = initialFrame
        snapshot.layer.cornerRadius = 25
        snapshot.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.isHidden = true
        
        AnimationHelper.perspectiveTransformForContainerView(containerView)
        snapshot.layer.transform = AnimationHelper.yRotation(Double.pi / 2)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: { 
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3, animations: {
                fromVC.view.layer.transform = AnimationHelper.yRotation(-Double.pi / 2)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: { 
                snapshot.layer.transform = AnimationHelper.yRotation(0)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: { 
                snapshot.frame = finalFrame
            })
            
            
        }) { (_) in
            toVC.view.isHidden = false
            fromVC.view.layer.transform = AnimationHelper.yRotation(0)
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        
        
    }
}

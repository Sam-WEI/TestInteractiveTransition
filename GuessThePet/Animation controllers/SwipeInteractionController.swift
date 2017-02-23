//
//  SwipeInteractionController.swift
//  GuessThePet
//
//  Created by WeiShengkun on 2/23/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
    
    var interactionInProgress = false
    fileprivate var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    
    func wireToViewController(_ viewController: UIViewController) {
        self.viewController = viewController
        prepareGestureRecognizer(in: viewController.view)
    }
    
    private func prepareGestureRecognizer(in view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(gestureRecognizer:)))
        gesture.edges = .left
        view.addGestureRecognizer(gesture)
    }
    
    func handleGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = translation.x / 200
        progress = CGFloat.minimum(1, CGFloat.maximum(progress, 0))
        
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
            
        case .cancelled:
            interactionInProgress = false
            cancel()
            
        case .ended:
            interactionInProgress = false
            if !shouldCompleteTransition {
                cancel()
            } else {
                finish()
            }
            
        default:
            print("UNSUPPORTED")
        }
        
    }

    
}

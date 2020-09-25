//
//  InitialViewControllerAnimatedTransition.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 25/09/2020.
//

import UIKit

final class InitialViewControllerAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.75
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        container.backgroundColor = .background
        
        guard let fromView = transitionContext
                .view(forKey: UITransitionContextViewKey.from) else { return }
        guard let toView = transitionContext
                .view(forKey: UITransitionContextViewKey.to) else { return }
        
        container.addSubview(toView)
        
        toView.alpha = 0
        
        UIView.animate(withDuration: 0.15, animations: {
            fromView.alpha = 0
        }, completion: { _ in
            UIView.animate(withDuration: 0.6, animations: {
                toView.alpha = 1
            }, completion: {
                _ in transitionContext.completeTransition(true)
            })
        })
    }
    
    
}

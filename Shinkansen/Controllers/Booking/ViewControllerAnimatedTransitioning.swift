//
//  ViewControllerAnimatedTransitioning.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 29/09/2020.
//

import UIKit

final class ViewControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting : Bool
    
    lazy var animationStyle: UIViewAnimationStyle = UIViewAnimationStyle.transitionAnimationStyle
    
    lazy var CAAnimationStyle: CABasicAnimationStyle = CABasicAnimationStyle.transitionAnimationStyle
    
    init(isPresenting : Bool) {
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationStyle.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        let container = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        isPresenting ? container.addSubview(toView) : container.insertSubview(toView, belowSubview: fromView)
        
        let parentVC = isPresenting ? fromViewController : toViewController
        
        let childVC = isPresenting ? toViewController : fromViewController
        
        // MARK: Set all the views in place and have been processed thru Autolayout
        parentVC?.view.layoutIfNeeded()
        childVC?.view.layoutIfNeeded()
        
        // MARK: Transition Between BookingViewController
        if let fromBookingVC = fromViewController as? BookingViewController,
            let toBookingVC = toViewController as? BookingViewController {
            
            // Animate Back Button
            
            toBookingVC.backButton.transform.tx = isPresenting ? -44 : 44
            fromBookingVC.backButton.transform.tx = 0
            toBookingVC.backButton.alpha = 0
            
            toBookingVC.backButton.setPath(to: self.isPresenting ? .pullBack : .pushedForward)
            toBookingVC.backButton.playAnimation(to: .original, withDuration: 0.35)
            fromBookingVC.backButton.playAnimation(to: self.isPresenting ? .pullBack : .pushedForward, withDuration: 0.35)
            
            UIView.animate(withStyle: .halfTransitionAnimationStyle, animations: {
                fromBookingVC.backButton.shapeView.transform = .identity
                toBookingVC.backButton.transform.tx = 0
                fromBookingVC.backButton.transform.tx = self.isPresenting ? 24 : -24
                toBookingVC.backButton.alpha = 1
                fromBookingVC.backButton.alpha = 0
            })
        }
        
        let percentageEndPoint: TimeInterval = 0.4
        
        
        // MARK: Transition in and out views in BookingCriteriaViewController
        if let bookingCriterialVC = fromViewController as? BookingCriteriaViewController {
            let transitionDirection: UIView.TransitionalDirection = .transitionOut
            bookingCriterialVC.headerStackView.translateAndFade(as: transitionDirection,
                                                              animationStyle: animationStyle,
                                                              percentageEndPoint: percentageEndPoint,
                                                              translate: .init(x: 0, y: -72))
            bookingCriterialVC.stationsContainerStackView.translateAndFade(as: transitionDirection,
                                                                         animationStyle: animationStyle,
                                                                         percentageEndPoint: percentageEndPoint,
                                                                         translate: .init(x: 0, y: -48))
            bookingCriterialVC.dateSegmentedContainerView.translateAndFade(as: transitionDirection,
                                                                         animationStyle: animationStyle,
                                                                         percentageEndPoint: percentageEndPoint,
                                                                         translate: .init(x: 0, y: -32))
            bookingCriterialVC.timeSegmentedContainerView.translateAndFade(as: transitionDirection,
                                                                         animationStyle: animationStyle,
                                                                         percentageEndPoint: percentageEndPoint,
                                                                         translate: .init(x: 0, y: -16))
            bookingCriterialVC.searchTicketButton.translateAndFade(as: transitionDirection,
                                                                     animationStyle: animationStyle,
                                                                     percentageEndPoint: percentageEndPoint,
                                                                     translate: .init(x: 0, y: -16))
        } else if let bookingCriterialVC = toViewController as? BookingCriteriaViewController {
            let transitionDirection: UIView.TransitionalDirection = .transitionIn
            bookingCriterialVC.headerStackView.translateAndFade(as: transitionDirection,
                                                              animationStyle: animationStyle,
                                                              percentageEndPoint: percentageEndPoint,
                                                              translate: .init(x: 0, y: -72))
            bookingCriterialVC.stationsContainerStackView.translateAndFade(as: transitionDirection,
                                                                         animationStyle: animationStyle,
                                                                         percentageEndPoint: percentageEndPoint,
                                                                         translate: .init(x: 0, y: -48))
            bookingCriterialVC.dateSegmentedContainerView.translateAndFade(as: transitionDirection,
                                                                         animationStyle: animationStyle,
                                                                         percentageEndPoint: percentageEndPoint,
                                                                         translate: .init(x: 0, y: -32))
            bookingCriterialVC.timeSegmentedContainerView.translateAndFade(as: transitionDirection,
                                                                         animationStyle: animationStyle,
                                                                         percentageEndPoint: percentageEndPoint,
                                                                         translate: .init(x: 0, y: -16))
            bookingCriterialVC.searchTicketButton.translateAndFade(as: transitionDirection,
                                                                     animationStyle: animationStyle,
                                                                     percentageEndPoint: percentageEndPoint,
                                                                     translate: .init(x: 0, y: -16))
        }
        
        // MARK: From Crit to Train
        if let train = toViewController as? TrainSelectionViewController,
            fromViewController is BookingCriteriaViewController {
            train.dateLabel.translateAndFade(as: .transitionIn,
                                                                                                                  animationStyle: animationStyle,
                                                                                                                  percentageEndPoint: percentageEndPoint,                                    translate: .init(x: 0, y: 18))
//
//            trainSelectionVC.mainTableView.visibleCells.enumerated().forEach {
//                (index, cell) in
//                cell.translateAndFade(as: .transitionOut,
//                                    animationStyle: animationStyle,
//                                    percentageEndPoint: percentageEndPoint,
//                                    translate: .init(x: 0, y: CGFloat(index) * 16))
//            }
        }
        
        // MARK: From TrainSelectionViewController backward
        if let trainSelectionVC = fromViewController as? TrainSelectionViewController,
            toViewController is BookingCriteriaViewController {
            trainSelectionVC.dateLabel.translateAndFade(as: .transitionOut,
                                                                                                                  animationStyle: animationStyle,
                                                                                                                  percentageEndPoint: percentageEndPoint,                                    translate: .init(x: 0, y: 18))
//
//            trainSelectionVC.mainTableView.visibleCells.enumerated().forEach {
//                (index, cell) in
//                cell.translateAndFade(as: .transitionOut,
//                                    animationStyle: animationStyle,
//                                    percentageEndPoint: percentageEndPoint,
//                                    translate: .init(x: 0, y: CGFloat(index) * 16))
//            }
        }
        
        container.backgroundColor = toView.backgroundColor
        toView.backgroundColor = toView.backgroundColor?.withAlphaComponent(0)
        
        fromView.backgroundColor = fromView.backgroundColor?.withAlphaComponent(0)
        
        // MARK: Perform Animation
        UIView.animate(withStyle: animationStyle, animations: {
            toView.backgroundColor = toView.backgroundColor?.withAlphaComponent(0.0001)
        }, completion: { _ in
            fromView.backgroundColor = fromView.backgroundColor?.withAlphaComponent(1)
            toView.backgroundColor = toView.backgroundColor?.withAlphaComponent(1)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

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
            
            let animateObject = AnimateObject(fromVC: fromBookingVC, toVC: toBookingVC)

            animateObject.animate(view: {$0.dateLabel},
                                  parentView: {$0.view},
                                  basedVerticalAnimationOffset: 18)
            animateObject.animate(view: {$0.headerInfomationView},
                                  parentView: {$0.view},
                                  basedVerticalAnimationOffset: 36)
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
        
        // MARK: From Critial to Train
        if let train = toViewController as? TrainSelectionViewController,
            fromViewController is BookingCriteriaViewController {
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
            trainSelectionVC.tableView.translateAndFade(as: .transitionOut,
                                                        animationStyle: animationStyle,
                                                        percentageEndPoint: percentageEndPoint,
                                                        translate: .init(x: 0, y: 72))
            
            trainSelectionVC.tableView.visibleCells.enumerated().forEach {
                (index, cell) in
                cell.translateAndFade(as: .transitionOut,
                                      animationStyle: animationStyle,
                                      percentageEndPoint: percentageEndPoint,
                                      translate: .init(x: 0, y: CGFloat(index) * 16))
            }
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

struct AnimateObject {
    let fromVC: BookingViewController
    let toVC: BookingViewController
    
    func _animate(fromView: UIView, fromParentView: UIView,
                 toView: UIView, toParentView: UIView,
                 basedHorizontalAnimationOffset: CGFloat = 0,
                 basedVerticalAnimationOffset: CGFloat = 0,
                 percentageEndPoint: TimeInterval = 1) {
        
        // Sets all animated views to orginal position before them get calculated
        fromView.transform = .identity
        toView.transform = .identity
        
        var displacement: CGPoint = .zero
        
        var isTransitioningHiddenView = false
        
        if fromView.isHidden || toView.isHidden {
            
            isTransitioningHiddenView = true
            
            // MARK: Hidden views will be slide up
            if fromView.isHidden  {
                displacement.x = (-basedHorizontalAnimationOffset)
                displacement.y = (-basedVerticalAnimationOffset)
            }
            
            if toView.isHidden  {
                displacement.x = basedHorizontalAnimationOffset
                displacement.y = basedVerticalAnimationOffset
            }
            
        } else {
            let fromActualFrame = fromView.frame(in: fromParentView)
            let toActualFrame = toView.frame(in: toParentView)
            
            displacement = CGPoint(x: toActualFrame.midX - fromActualFrame.midX,
                                   y: toActualFrame.minY - fromActualFrame.minY)
        }
        
        toView.transform.tx = -displacement.x
        toView.transform.ty = -displacement.y
        
        // MARK: In case one view is hidden
        if fromView.isHidden  {
            toView.alpha = 0
        }
        
        if toView.isHidden  {
            fromView.alpha = 1
        }
        
        // mutate
        let animationStyle = UIViewAnimationStyle.transitionAnimationStyle
        var mutatedAnimationStyle = animationStyle
        mutatedAnimationStyle.duration = animationStyle.duration * (fromView.isHidden ? 1 - percentageEndPoint : percentageEndPoint)
        mutatedAnimationStyle.delay = animationStyle.duration - mutatedAnimationStyle.duration
        
        UIView.animate(withStyle: isTransitioningHiddenView ? mutatedAnimationStyle : animationStyle,
                       delay: fromView.isHidden ? mutatedAnimationStyle.delay : 0,
                       animations: {
                        fromView.transform.tx = displacement.x
                        fromView.transform.ty = displacement.y
                        toView.transform = .identity
                        
                        // MARK: Animation for one that is hidden
                        if fromView.isHidden {
                            toView.alpha = 1
                        }
                        
                        if toView.isHidden {
                            fromView.alpha = 0
                        }
        })
    }
    
    func animate(view: ((BookingViewController) -> UIView),
                 parentView: ((BookingViewController) -> UIView)? = nil,
                 basedVerticalAnimationOffset: CGFloat,
                 percentageEndPoint: TimeInterval = 0.4
        ) {
        
        _animate(fromView: view(fromVC),
                 fromParentView: (parentView != nil) ? parentView!(fromVC) : (view(fromVC).superview ?? UIView()),
                 toView: view(toVC),
                 toParentView: (parentView != nil) ? parentView!(toVC) : (view(toVC).superview ?? UIView()),
                 basedVerticalAnimationOffset: basedVerticalAnimationOffset,
                 percentageEndPoint: 0.4)
    }
}

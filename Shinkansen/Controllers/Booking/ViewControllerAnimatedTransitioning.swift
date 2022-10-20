//
//  ViewControllerAnimatedTransitioning.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 29/09/2020.
//

import UIKit

final class ViewControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPush: Bool
    
    lazy var animationStyle: UIViewAnimationStyle = UIViewAnimationStyle.transitionAnimationStyle
    
    init(isPush : Bool) {
        self.isPush = isPush
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationStyle.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: .from)
        
        let toViewController = transitionContext.viewController(forKey: .to)
        
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        let container = transitionContext.containerView
        
        isPush ? container.addSubview(toView) : container.insertSubview(toView, belowSubview: fromView)
        
        let parentVC = isPush ? fromViewController : toViewController
        
        let childVC = isPush ? toViewController : fromViewController
        
        // MARK: Load tất cả views
        parentVC?.view.layoutIfNeeded()
        childVC?.view.layoutIfNeeded()
        
        // MARK: Transition chung của các BookingViewController
        if let fromBookingVC = fromViewController as? BookingViewController,
            let toBookingVC = toViewController as? BookingViewController {
            
            // Reset verticalRubberBandEffect
            fromBookingVC.headerInfomationView.alpha = isPush ? 0 : 1
            toBookingVC.headerInfomationView.alpha = !isPush ? 0 : 1
            
            UIView.animate(withStyle: animationStyle, animations: {
                fromBookingVC.headerInfomationView.verticalRubberBandEffect(byVerticalContentOffset: 0)
                fromBookingVC.interactivePopOverlayView.overlayAlpha = 0
            }, completion: { _ in
                fromBookingVC.headerInfomationView.alpha = toBookingVC is BookingCriteriaViewController ? 0 : 1
                toBookingVC.headerInfomationView.alpha = 1
            })
            
            struct AnimateObject {
                let fromVC: BookingViewController
                let toVC: BookingViewController
                
                func animate(view: ((BookingViewController) -> UIView),
                             parentView: ((BookingViewController) -> UIView)? = nil,
                             basedVerticalAnimationOffset: CGFloat,
                             percentageEndPoint: TimeInterval = 0.4) {
                    
                    _animate(fromView: view(fromVC),
                             fromParentView: (parentView != nil) ? parentView!(fromVC) : (view(fromVC).superview ?? UIView()),
                             toView: view(toVC),
                             toParentView: (parentView != nil) ? parentView!(toVC) : (view(toVC).superview ?? UIView()),
                             basedVerticalAnimationOffset: basedVerticalAnimationOffset,
                             percentageEndPoint: 0.4)
                }
                
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
                    if fromView.isHidden {
                        toView.alpha = 0
                    }
                    
                    if toView.isHidden {
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
            }
            
            let animateObject = AnimateObject(fromVC: fromBookingVC, toVC: toBookingVC)
            
            animateObject.animate(view: { $0.dateLabel },
                                  parentView: { $0.view },
                                  basedVerticalAnimationOffset: 18)

            animateObject.animate(view: { $0.headerInfomationView },
                                  parentView: { $0.view },
                                  basedVerticalAnimationOffset: 72)

            animateObject.animate(view: { $0.headerInfomationView.stationPairView.fromStationHeadlineView.subtitleLabel },
                                  basedVerticalAnimationOffset: 6)

            animateObject.animate(view: { $0.headerInfomationView.stationPairView.toStationHeadlineView.subtitleLabel },
                                  basedVerticalAnimationOffset: 6)

            animateObject.animate(view: { $0.headerInfomationView.descriptionSetView },
                                  basedVerticalAnimationOffset: 18)

            animateObject.animate(view: { $0.headerInfomationView.descriptionSetView.carNumberSetView },
                                  basedVerticalAnimationOffset: 12)

            animateObject.animate(view: { $0.headerInfomationView.descriptionSetView.seatNumberSetView },
                                  basedVerticalAnimationOffset: 12)

            animateObject.animate(view: { $0.headerInfomationView.descriptionSetView.priceSetView },
                                  basedVerticalAnimationOffset: 12)
            
            
            // Animate Back Button
            
            toBookingVC.backButton.transform.tx = isPush ? -44 : 44
            fromBookingVC.backButton.transform.tx = 0
            toBookingVC.backButton.alpha = 0
            
            toBookingVC.backButton.setPath(to: self.isPush ? .pullBack : .pushedForward)
            toBookingVC.backButton.playAnimation(to: .original, withDuration: 0.35)
            fromBookingVC.backButton.playAnimation(to: self.isPush ? .pullBack : .pushedForward, withDuration: 0.35)
            
            UIView.animate(withStyle: .halfTransitionAnimationStyle, animations: {
                fromBookingVC.backButton.shapeView.transform = .identity
                toBookingVC.backButton.transform.tx = 0
                fromBookingVC.backButton.transform.tx = self.isPush ? 24 : -24
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
        
        // MARK: From Booking to Select Train
        if let trainSelectionVC = toViewController as? TrainSelectionViewController,
            fromViewController is BookingCriteriaViewController {

            trainSelectionVC.tableView.translateAndFade(as: .transitionIn,
                                                        animationStyle: animationStyle,
                                                        percentageEndPoint: percentageEndPoint,
                                                        translate: .init(x: 0, y: 72))
            trainSelectionVC.tableView.visibleCells.enumerated().forEach {
                (index, cell) in
                cell.translateAndFade(as: .transitionIn,
                                    animationStyle: animationStyle,
                                    percentageEndPoint: percentageEndPoint,
                                    translate: .init(x: 0, y: CGFloat(index) * 16))
            }
        }
        
        // MARK: From Select Train backward
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
        
        // MARK: Transition views in TrainSelectionViewController to SeatClassSelectionViewController
        if let trainSelectionVC = fromViewController as? TrainSelectionViewController,
            let seatClassSelectionVC = toViewController as? SeatClassSelectionViewController {
            
            // MARK: Transition Train Image View
            seatClassSelectionVC.trainImageView.translateAndFade(as: .transitionIn,
                                                                 animationStyle: animationStyle,
                                                                 percentageEndPoint: percentageEndPoint,
                                                                 translate: .init(x: 0, y: 18))
            
            // Demo
            if let selectedIndexPath = trainSelectionVC.selectedIndexPath {
                guard let cell = trainSelectionVC.tableView.cellForRow(at: selectedIndexPath) as? TrainScheduleTableViewCell else { return }
                
                // MARK: Fade all other cells
                trainSelectionVC.tableView.visibleCells.forEach { otherCell in
                    if otherCell != cell {
                        otherCell.fadeAnimation(as: .transitionOut,
                                                animationStyle: animationStyle,
                                                percentageEndPoint: 0.3)
                    }
                }
                
                // MARK: Fade all other cells
                seatClassSelectionVC.tableView.visibleCells.forEach { otherCell in
                    otherCell.fadeAnimation(as: .transitionIn,
                                            animationStyle: animationStyle,
                                            percentageEndPoint: 0.55)
                    
                }
                
                //
                let originRectInOriginView = cell.touchableView.frame(in: cell.contentView)
                
                seatClassSelectionVC.tableView.visibleCells.forEach { destinationCell in
                    guard let destinationCell = destinationCell as? SeatClassTableViewCell else { return }
                     let destinationRectInOriginView = destinationCell.cardView.frame(in: cell.contentView)
                    
                    let dummyView = UIView() // the white view come after selecting cell
                    cell.contentView.addSubview(dummyView)
                    
                    dummyView.layer.setLayerStyle(cell.touchableView.layer.layerStyle)
                    dummyView.layer.withNoShadow()
                    cell.contentView.layer.setShadow(cell.touchableView.layer.shadowStyle)
                    
                    cell.touchableView.layer.removeAllAnimations()
                    cell.touchableView.contentView.layer.removeAllAnimations()
                    
                    cell.contentView.sendSubviewToBack(dummyView)
                    if destinationCell == seatClassSelectionVC.tableView.visibleCells.last {
                        cell.touchableView.layer.setLayerStyle(LayerStyle(opacity: 0, cornerRadius: 0, shadowStyle: .noShadow))
                        cell.touchableView.contentView.backgroundColor = .clear
                        cell.touchableView.contentView.fadeAnimation(as: .transitionOut, animationStyle: animationStyle, percentageEndPoint: 0.3)
                    }
                    
                    dummyView.frame = originRectInOriginView
                    
                    var muatatedAnimationStyle = animationStyle
                    muatatedAnimationStyle.duration = animationStyle.duration * 0.35
                    UIView.animate(withStyle: muatatedAnimationStyle,
                                   delay: 0.65 * animationStyle.duration,
                                   animations: {
                        dummyView.alpha = 0
                    })
                    
                    
                    
                    UIView.animate(withStyle: animationStyle, animations: {
                        dummyView.frame = destinationRectInOriginView
                    }, completion: {
                        _ in
                        cell.contentView.layer.withNoShadow()
                        dummyView.removeFromSuperview()
                    })
                    
                    let originRectInDestinationView = cell.touchableView.frame(in: destinationCell.contentView)
                    let destinationRectInDestinationView = destinationCell.cardView.frame(in: destinationCell.contentView)
                    destinationCell.cardView.frame = originRectInDestinationView
                    
                    UIView.animate(withStyle: animationStyle, animations: {
                        destinationCell.cardView.frame = destinationRectInDestinationView
                    })
                }
            }
        }
        
        
        // MARK: Transition views in SeatClassSelectionViewController to TrainSelectionViewController (Backward)
        if let trainSelectionVC = toViewController as? TrainSelectionViewController,
            let seatClassSelectionVC = fromViewController as? SeatClassSelectionViewController {
            
            // MARK: Transition Train Image View
            seatClassSelectionVC.trainImageView.translateAndFade(as: .transitionOut,
                                                                 animationStyle: animationStyle,
                                                                 percentageEndPoint: percentageEndPoint,
                                                                 translate: .init(x: 0, y: 18))
            
            // Demo
            if let selectedIndexPath = trainSelectionVC.selectedIndexPath {
                guard let cell = trainSelectionVC.tableView.cellForRow(at: selectedIndexPath) as? TrainScheduleTableViewCell else { return }
                
                // MARK: Fade all other cells
                trainSelectionVC.tableView.visibleCells.forEach { (otherCell) in
                    if otherCell != cell {
                        otherCell.fadeAnimation(as: .transitionIn,
                                                animationStyle: animationStyle,
                                                percentageEndPoint: 0.5)
                    }
                }
                
                // MARK: Fade all other cells
                seatClassSelectionVC.tableView.visibleCells.forEach { (otherCell) in
                    otherCell.fadeAnimation(as: .transitionOut,
                                            animationStyle: animationStyle,
                                            percentageEndPoint: 0.15)
                    
                }
                
                
                let originRectInOriginView = cell.touchableView.frame(in: cell.contentView)
                
                seatClassSelectionVC.tableView.visibleCells.forEach { (destinationCell) in
                    guard let destinationCell = destinationCell as? SeatClassTableViewCell else { return }
                    let destinationRectInOriginView = destinationCell.cardView.frame(in: cell.contentView)
                    
                    
                    cell.touchableView.layer.removeAllAnimations()
                    cell.touchableView.contentView.layer.removeAllAnimations()
                    cell.contentView.layer.setShadow(cell.touchableView.layer.shadowStyle)
                    
                    let dummyView = UIView()
                    cell.contentView.addSubview(dummyView)
                    cell.contentView.sendSubviewToBack(dummyView)
                    
                    
                    dummyView.layer.setLayerStyle(cell.touchableView.layer.layerStyle)
                    dummyView.layer.withNoShadow()
                    dummyView.frame = destinationRectInOriginView
                    dummyView.alpha = 0
                    
                    // Set cell to have no appearance if the cell loops to the last cell
                    if destinationCell == seatClassSelectionVC.tableView.visibleCells.last {
                        cell.touchableView.layer.setLayerStyle(.none)
                        cell.touchableView.contentView.backgroundColor = .clear
                        cell.touchableView.contentView.fadeAnimation(as: .transitionIn, animationStyle: animationStyle, percentageEndPoint: 0.3)
                    }
                    
                    var muatatedAnimationStyle = animationStyle
                    muatatedAnimationStyle.duration = animationStyle.duration * 0.05
                    UIView.animate(withStyle: muatatedAnimationStyle, animations: {
                                    dummyView.alpha = 1
                    })
                    
                    
                    // Animate dummyView's frame
                    UIView.animate(withStyle: animationStyle, animations: {
                        dummyView.frame = originRectInOriginView
                        cell.contentView.layer.withNoShadow()
                        cell.touchableView.layer.setLayerStyle(.card.normal)
                    }, completion: {
                        _ in
                        dummyView.removeFromSuperview()
                    })
                    
                    
                    //Animation the Destination Cell
                    let originRectInDestinationView = cell.touchableView.frame(in: destinationCell.contentView)
                    let destinationRectInDestinationView = destinationCell.cardView.frame(in: destinationCell.contentView)
                    destinationCell.cardView.frame = destinationRectInDestinationView
                    
                    UIView.animate(withStyle: animationStyle, animations: {
                        destinationCell.cardView.frame = originRectInDestinationView
                    })
                }
            }
        }
        
        // MARK: Transition views in SeatClassSelectionViewController to SeatMapSelectionViewController
        if let seatClassSelectionVC = fromViewController as? SeatClassSelectionViewController,
            let seatMapSelectionVC = toViewController as? SeatMapSelectionViewController {
            
            // MARK: Transition Train Image View
            seatClassSelectionVC.trainImageView.translateAndFade(as: .transitionOut,
                                                                 animationStyle: animationStyle,
                                                                 percentageEndPoint: percentageEndPoint,
                                                                 translate: .init(x: 0, y: -18))
            
            seatClassSelectionVC.tableView.clipsToBounds = false
            // Demo
            if let selectedIndexPath = seatClassSelectionVC.selectedIndexPath,
                let selectedCell = seatClassSelectionVC.tableView.cellForRow(at: selectedIndexPath) as? SeatClassTableViewCell {
                
                seatClassSelectionVC.tableView.visibleCells.filter({ $0 != selectedCell }).forEach { otherCell in
                    otherCell.translateAndFade(as: .transitionOut, animationStyle: animationStyle, percentageEndPoint: 0.3, translate: .zero)
                }
                
                let originRectInMainContentView = selectedCell.cardView.frame(in: seatMapSelectionVC.contentView)
                let destinationRectInMainContentView = seatMapSelectionVC.mainCardView.frame(in: seatMapSelectionVC.contentView)
                let destinationRectInOriginView = seatMapSelectionVC.mainCardView.frame(in: selectedCell.contentView)
                
                if let cardViewInDestinationView = seatMapSelectionVC.mainCardView {
                    selectedCell.cardView.contentView.layer.removeAllAnimations()
                    selectedCell.cardView.layer.removeAllAnimations()
                    
                    let dummyView = UIView()
                    seatMapSelectionVC.contentView.addSubview(dummyView)
                    seatMapSelectionVC.contentView.sendSubviewToBack(dummyView)
                    dummyView.layer.setLayerStyle(selectedCell.cardView.layer.layerStyle)
                    dummyView.layer.setShadow(selectedCell.cardView.layer.shadowStyle)
                    dummyView.frame = originRectInMainContentView
                    
                    dummyView.alpha = 0
                    
                    let dummyViewInCell = UIView()
                    selectedCell.contentView.addSubview(dummyViewInCell)
                    selectedCell.contentView.sendSubviewToBack(dummyViewInCell)
                    dummyViewInCell.layer.setLayerStyle(selectedCell.cardView.layer.layerStyle)
                    dummyViewInCell.layer.setShadow(selectedCell.cardView.layer.shadowStyle)
                    dummyViewInCell.frame = selectedCell.cardView.frame
                    
                    dummyViewInCell.alpha = 1
                    
                    selectedCell.cardView.layer.setLayerStyle(.none)
                    selectedCell.cardView.contentView.backgroundColor = .clear
                    
                    selectedCell.cardView.contentView.fadeAnimation(as: .transitionOut, animationStyle: animationStyle, percentageEndPoint: 0.3)
                    
                    cardViewInDestinationView.layer.cornerRadius = dummyView.layer.cornerRadius
                    cardViewInDestinationView.contentView.layer.cornerRadius = dummyView.layer.cornerRadius
                    
                    cardViewInDestinationView.alpha = 0
                    
                    cardViewInDestinationView.frame = originRectInMainContentView
                    cardViewInDestinationView.contentView.frame = cardViewInDestinationView.bounds
                    
                    cardViewInDestinationView.fadeAnimation(as: .transitionIn, animationStyle: animationStyle, percentageEndPoint: 0.55)
                    
                    var muatatedAnimationStyle = animationStyle
                    muatatedAnimationStyle.duration = animationStyle.duration * 0.3
                    UIView.animate(withStyle: muatatedAnimationStyle,
                                   delay: 0.3 * animationStyle.duration,
                                   animations: {
                        dummyView.alpha = 1
                    }, completion: { _ in
                        UIView.animate(withStyle: muatatedAnimationStyle, animations: {
                            dummyView.alpha = 0
                            dummyViewInCell.alpha = 0
                        })
                    })
                    
                    // Animate subview in cardView.content of Destination
                    cardViewInDestinationView.contentView.subviews.forEach { view in
                        view.transform.tx = cardViewInDestinationView.bounds.midX - destinationRectInMainContentView.midX
                        view.transform.ty = cardViewInDestinationView.bounds.midY - destinationRectInMainContentView.midY
                        
                        UIView.animate(withStyle: animationStyle, animations: {
                            view.transform = .identity
                        })
                    }
                    
                    UIView.animate(withStyle: animationStyle, animations: {
                        cardViewInDestinationView.frame = destinationRectInMainContentView
                        cardViewInDestinationView.contentView.frame = cardViewInDestinationView.bounds
                        
                        cardViewInDestinationView.layer.cornerRadius = LayerStyle.card.normal.cornerRadius
                        cardViewInDestinationView.contentView.layer.cornerRadius = LayerStyle.card.normal.cornerRadius
                        
                        dummyView.layer.cornerRadius = LayerStyle.card.normal.cornerRadius
                        dummyViewInCell.layer.cornerRadius = LayerStyle.card.normal.cornerRadius
                        
                        dummyView.frame = destinationRectInMainContentView
                        dummyViewInCell.frame = destinationRectInOriginView
                    }, completion: { _ in
                        dummyView.removeFromSuperview()
                        dummyViewInCell.removeFromSuperview()
                        cardViewInDestinationView.layer.setLayerStyle(.card.normal)
                        selectedCell.cardView.layer.setLayerStyle(.card.normal)
                        seatClassSelectionVC.tableView.clipsToBounds = true
                    })
                }
            }
        }
        
        // MARK: Transition views in SeatMapSelectionViewController to SeatClassSelectionViewController
        if let seatMapSelectionVC = fromViewController as? SeatMapSelectionViewController,
            let seatClassSelectionVC = toViewController as? SeatClassSelectionViewController {
            
            // MARK: Transition Train Image View
            seatClassSelectionVC.trainImageView.translateAndFade(as: .transitionIn,
                                                                 animationStyle: animationStyle,
                                                                 percentageEndPoint: percentageEndPoint,
                                                                 translate: .init(x: 0, y: -18))
            
            seatClassSelectionVC.tableView.clipsToBounds = false
            // Demo
            if let selectedIndexPath = seatClassSelectionVC.selectedIndexPath,
               let selectedCell = seatClassSelectionVC.tableView.cellForRow(at: selectedIndexPath) as? SeatClassTableViewCell {
                
                seatClassSelectionVC.tableView.visibleCells.forEach { otherCell in
                    if otherCell != selectedCell {
                        otherCell.translateAndFade(as: .transitionIn, animationStyle: animationStyle, percentageEndPoint: 0.6, translate: .zero)
                    }
                }
                
                let originRectInMainContentView = selectedCell.cardView.frame(in: seatMapSelectionVC.contentView)
                let destinationRectInMainContentView = seatMapSelectionVC.mainCardView.frame(in: seatMapSelectionVC.contentView)
                let destinationRectInOriginView = seatMapSelectionVC.mainCardView.frame(in: selectedCell.contentView)
                
                if let cardViewInDestinationView = seatMapSelectionVC.mainCardView {
                    selectedCell.cardView.contentView.layer.removeAllAnimations()
                    selectedCell.cardView.layer.removeAllAnimations()
                    
                    let dummyView = UIView()
                    let dummyViewInCell = UIView()
                    seatMapSelectionVC.contentView.addSubview(dummyView)
                    seatMapSelectionVC.contentView.sendSubviewToBack(dummyView)
                    selectedCell.contentView.addSubview(dummyViewInCell)
                    selectedCell.contentView.sendSubviewToBack(dummyViewInCell)
                    
                    dummyView.alpha = 0
                    dummyViewInCell.alpha = 0
                   
                    dummyView.layer.setLayerStyle(seatMapSelectionVC.mainCardView.layer.layerStyle)
                    dummyView.layer.setShadow(seatMapSelectionVC.mainCardView.layer.shadowStyle)
                    dummyView.frame = destinationRectInMainContentView
                    
                    dummyViewInCell.layer.setLayerStyle(seatMapSelectionVC.mainCardView.layer.layerStyle)
                    dummyViewInCell.layer.setShadow(seatMapSelectionVC.mainCardView.layer.shadowStyle)
                    dummyViewInCell.frame = destinationRectInOriginView
                    
                    
                    selectedCell.cardView.layer.setLayerStyle(.none)
                    selectedCell.cardView.contentView.backgroundColor = .clear
                    
                    selectedCell.cardView.contentView.fadeAnimation(as: .transitionIn, animationStyle: animationStyle, percentageEndPoint: 0.5)
                    
                    
                    
                    cardViewInDestinationView.layer.cornerRadius = dummyView.layer.cornerRadius
                    cardViewInDestinationView.contentView.layer.cornerRadius = dummyView.layer.cornerRadius
                    
                    cardViewInDestinationView.alpha = 1
                    
                    cardViewInDestinationView.frame = originRectInMainContentView
                    cardViewInDestinationView.contentView.frame = cardViewInDestinationView.bounds
                    
                    cardViewInDestinationView.fadeAnimation(as: .transitionOut, animationStyle: animationStyle, percentageEndPoint: 0.3)
                    
                    var muatatedAnimationStyle = animationStyle
                    muatatedAnimationStyle.duration = animationStyle.duration * 0.3
                    UIView.animate(withStyle: muatatedAnimationStyle,
                                   delay: 0.3 * animationStyle.duration,
                                   animations: {
                                    dummyView.alpha = 1
                    }, completion: { _ in
                        UIView.animate(withStyle: muatatedAnimationStyle, animations: {
                            dummyView.alpha = 0
                        })
                    })
                    
                    // Animate subview in cardView.content of Destination
                    cardViewInDestinationView.contentView.subviews.forEach { (view) in
                        UIView.animate(withStyle: animationStyle, animations: {
                            view.transform.tx = originRectInMainContentView.midX - destinationRectInMainContentView.midX
                            
                            view.transform.ty = originRectInMainContentView.midY - destinationRectInMainContentView.midY
                        })
                    }
                    
                    UIView.animate(withStyle: animationStyle, animations: {
                        cardViewInDestinationView.frame = originRectInMainContentView
                        cardViewInDestinationView.contentView.frame = cardViewInDestinationView.bounds
                        
                        cardViewInDestinationView.layer.cornerRadius = LayerStyle.card.normal.cornerRadius
                        cardViewInDestinationView.contentView.layer.cornerRadius = LayerStyle.card.normal.cornerRadius
                        
                        dummyView.layer.cornerRadius = LayerStyle.card.normal.cornerRadius
                        dummyViewInCell.layer.cornerRadius = LayerStyle.card.normal.cornerRadius
                        dummyView.frame = originRectInMainContentView
                        dummyViewInCell.frame = selectedCell.cardView.frame
                        
                    }, completion: { _ in
                        dummyView.removeFromSuperview()
                        dummyViewInCell.removeFromSuperview()
                        cardViewInDestinationView.layer.setLayerStyle(.card.normal)
                        cardViewInDestinationView.layer.setShadow(.card.normal)
                        
                        selectedCell.cardView.layer.setShadow(.card.normal)
                        selectedCell.cardView.layer.setLayerStyle(.card.normal)
                        
                        seatClassSelectionVC.tableView.clipsToBounds = true
                    })
                }
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
            if fromView.isHidden {
                displacement.x = (-basedHorizontalAnimationOffset)
                displacement.y = (-basedVerticalAnimationOffset)
            }
            
            if toView.isHidden {
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
        if fromView.isHidden {
            toView.alpha = 0
        }
        
        if toView.isHidden {
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

extension CALayer {
    var layerStyle: LayerStyle {
        return LayerStyle(opacity: opacity,
                          cornerRadius: cornerRadius,
                          backgroundColor: UIColor(cgColor: backgroundColor ?? UIColor.clear.cgColor),
                          shadowStyle: shadowStyle)
    }
    
    var shadowStyle: ShadowStyle {
        return ShadowStyle(shadowOpacity: shadowOpacity,
                           shadowRadius: shadowRadius,
                           shadowOffset: shadowOffset,
                           shadowColor: UIColor(cgColor: shadowColor ?? UIColor.clear.cgColor))
    }
    
    func withNoShadow() {
        shadowOpacity = 0
        shadowRadius = 0
        shadowOffset = .zero
        shadowColor = nil
    }
    
    func setShadow(_ shadowStyle: ShadowStyle) {
        shadowOpacity = shadowStyle.shadowOpacity
        shadowRadius = shadowStyle.shadowRadius
        shadowOffset = shadowStyle.shadowOffset
        shadowColor = shadowStyle.shadowColor?.cgColor
    }
}

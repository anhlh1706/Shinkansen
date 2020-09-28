//
//  AnimationStyle.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 28/09/2020.
//

import UIKit

struct UIViewAnimationStyle {
    
    var duration: TimeInterval
    
    var delay: TimeInterval
    
    var dampingRatio: CGFloat
    
    var velocity: CGFloat
    
    var options: UIView.AnimationOptions
    
    init(duration: TimeInterval = 0.35,
         delay: TimeInterval = 0,
         dampingRatio: CGFloat = 1,
         velocity: CGFloat = 0,
         options: UIView.AnimationOptions = [.allowUserInteraction]) {
        self.duration = duration
        self.delay = delay
        self.dampingRatio = dampingRatio
        self.velocity = velocity
        self.options = options
    }
    
    static let normalAnimationStyle = UIViewAnimationStyle(duration: 0.2, delay: 0, dampingRatio: 1, velocity: 0, options: .allowUserInteraction)
    
    static let transitionAnimationStyle = UIViewAnimationStyle(duration: 0.6, delay: 0, dampingRatio: 1, velocity: 0, options: .allowUserInteraction)
    
    static let halfTransitionAnimationStyle = UIViewAnimationStyle(duration: 0.3, delay: 0, dampingRatio: 1, velocity: 0, options: .allowUserInteraction)
    
    static let quarterTransitionAnimationStyle = UIViewAnimationStyle(duration: 0.15, delay: 0, dampingRatio: 1, velocity: 0, options: .allowUserInteraction)
    
    static let fastTransitionAnimationStyle = UIViewAnimationStyle(duration: 0.125, delay: 0, dampingRatio: 1, velocity: 0, options: .allowUserInteraction)
}

struct CABasicAnimationStyle {
    
    let duration: TimeInterval
    
    let delay: TimeInterval
    
    let timingFunction: CAMediaTimingFunction
    
    let isRemovedOnCompletion: Bool
    
    init(duration: TimeInterval = 0.35,
         delay: TimeInterval = 0,
         timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 1, 1),
         isRemovedOnCompletion: Bool = false) {
        self.duration = duration
        self.delay = delay
        self.timingFunction = timingFunction
        self.isRemovedOnCompletion = isRemovedOnCompletion
    }
    
    static let layerAnimationStyle = CABasicAnimationStyle(duration: 0.2,
                                                           delay: 0,
                                                           timingFunction: CAMediaTimingFunction(controlPoints: 0.2, 0, 0, 1),
                                                           isRemovedOnCompletion: false)
    
    static let transitionAnimationStyle = CABasicAnimationStyle(duration: 0.6,
                                                                delay: 0,
                                                                timingFunction: CAMediaTimingFunction(controlPoints: 0.2, 0, 0, 1),
                                                                isRemovedOnCompletion: false)
}

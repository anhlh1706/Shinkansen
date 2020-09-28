//
//  UIView.swift
//  Base
//
//  Created by Hoàng Anh on 30/07/2020.
//  Copyright © 2020 Hoàng Anh. All rights reserved.
//

import UIKit

extension UIView {
    
    convenience init(backgroundColor: UIColor?) {
        self.init()
        self.backgroundColor = backgroundColor
    }
    
    class func fromNib<T: UIView>() -> T {
        let nib = UINib(nibName: String(describing: self), bundle: nil)
        return (nib.instantiate(withOwner: self, options: nil).first as? T) ?? T()
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue != 0
        }
    }
    
    @IBInspectable
    var masksToBound: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    var width: CGFloat {
        bounds.width
    }
    
    var height: CGFloat {
        bounds.height
    }
    
    func applyGradient(colours: [UIColor], direction: NSLayoutConstraint.Axis) {
        let startPoint = CGPoint(x: 0.0, y: 0.0)
        var endPoint: CGPoint
        switch direction {
        case .horizontal:
            endPoint = CGPoint(x: 1.0, y: 0.0)
        case .vertical:
            endPoint = CGPoint(x: 0.0, y: 1.0)
        @unknown default:
            endPoint = CGPoint(x: 1.0, y: 0.0)
        }
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        layer.addSublayer(gradient)
    }
    
    func roundCorners(cornerRadius: Double, corners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
    
    func removeDashedLine() {
        for case let dash in layer.sublayers ?? [] where dash.name == "dash" {
            dash.removeFromSuperlayer()
        }
    }
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
    }
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        
        layer.add(flash, forKey: nil)
    }
    
    
    func shake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}

extension UIView {

    class func animate(withStyle style: UIViewAnimationStyle,
                              delay: TimeInterval = 0,
                              animations: @escaping () -> Swift.Void,
                              completion: ((Bool) -> Swift.Void)? = nil) {

        animate(withDuration: style.duration,
                delay: delay,
                usingSpringWithDamping: style.dampingRatio,
                initialSpringVelocity: style.velocity,
                options: style.options,
                animations: animations,
                completion: completion)
    }
    
    @discardableResult
    func constraintBottomSafeArea(to view: UIView,
                                  withGreaterThanConstant greaterThanConstant: CGFloat,
                                  minimunConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        
        let bottomConstraint = self
            .bottomAnchor
            .constraint(greaterThanOrEqualTo: view.bottomAnchor,
                        constant: greaterThanConstant > greaterThanConstant ? greaterThanConstant : greaterThanConstant)
        
        let bottomSafeAreaConstraint = self
            .safeAreaLayoutGuide
            .bottomAnchor
            .constraint(equalTo: view.bottomAnchor,
                        constant: minimunConstant)
        bottomSafeAreaConstraint.priority = .defaultHigh
        
        let anchors = [bottomConstraint, bottomSafeAreaConstraint]
        
        NSLayoutConstraint.activate(anchors)
        
        return anchors
    }
    
    func frame(in view: UIView) -> CGRect {
        return superview?.convert(frame, to: view) ?? convert(frame, to: view)
    }
    
    func translateAndFade(as direction: TransitionalDirection,
                        animationStyle: UIViewAnimationStyle,
                        percentageEndPoint: TimeInterval = 1,
                        translate: CGPoint) {
        
        layer.removeAllAnimations()
        
        let duration = animationStyle.duration *
            (direction == .transitionIn ? 1 - percentageEndPoint : percentageEndPoint)
        let delay = animationStyle.duration - duration
        
        var mutatedAnimationStyle = animationStyle
        mutatedAnimationStyle.duration = duration
        
        if direction == .transitionIn {
            transform.tx = translate.x
            transform.ty = translate.y
            alpha = 0
            UIView.animate(withStyle: mutatedAnimationStyle,
                           delay: delay,
                           animations: {
                self.transform.tx = 0
                self.transform.ty = 0
                self.alpha = 1
            })
        }
        
        if direction == .transitionOut {
            transform.tx = 0
            transform.ty = 0
            alpha = 1
            UIView.animate(withStyle: mutatedAnimationStyle,
                           animations: {
                self.transform.tx = translate.x
                self.transform.ty = translate.y
                self.alpha = 0
            })
        }
    }
    
    func transformAnimation(as direction: TransitionalDirection,
                          animationStyle: UIViewAnimationStyle,
                          percentageEndPoint: TimeInterval = 1,
                          transform: CGAffineTransform) {
        
        let duration = animationStyle.duration *
            (direction == .transitionIn ? 1 - percentageEndPoint : percentageEndPoint)
        let delay = animationStyle.duration - duration
        
        var mutatedAnimationStyle = animationStyle
        mutatedAnimationStyle.duration = duration
        
        if direction == .transitionIn {
            self.transform = transform
            UIView.animate(withStyle: mutatedAnimationStyle,
                           delay: delay,
                           animations: {
                            self.transform = .identity
            })
        }
        
        if direction == .transitionOut {
            self.transform = .identity
            UIView.animate(withStyle: mutatedAnimationStyle,
                           animations: {
                            self.transform = transform
            })
        }
    }
    
    func fadeAnimation(as direction: TransitionalDirection,
                          animationStyle: UIViewAnimationStyle,
                          percentageEndPoint: TimeInterval = 1) {
        
        let duration = animationStyle.duration *
            (direction == .transitionIn ? 1 - percentageEndPoint : percentageEndPoint)
        let delay = animationStyle.duration - duration
        
        var mutatedAnimationStyle = animationStyle
        mutatedAnimationStyle.duration = duration
        
        if direction == .transitionIn {
            alpha = 0
            UIView.animate(withStyle: mutatedAnimationStyle,
                           delay: delay,
                           animations: {
                            self.alpha = 1
            })
        }
        
        if direction == .transitionOut {
            alpha = 1
            UIView.animate(withStyle: mutatedAnimationStyle,
                           animations: {
                            self.alpha = 0
            })
        }
    }
    
    enum TransitionalDirection {
        case transitionIn
        case transitionOut
    }
}

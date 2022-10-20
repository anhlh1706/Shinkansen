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
    
    // Appear/disappear anim
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

struct ConstraintEqual : OptionSet {
    let rawValue: Int
    init(rawValue: Int) { self.rawValue = rawValue }
    static let top = ConstraintEqual(rawValue: 1 << 0)
    static let leading = ConstraintEqual(rawValue: 1 << 1)
    static let bottom = ConstraintEqual(rawValue: 1 << 2)
    static let trailing = ConstraintEqual(rawValue: 1 << 3)
    
    static let topMargin = ConstraintEqual(rawValue: 1 << 4)
    static let leadingMargin = ConstraintEqual(rawValue: 1 << 5)
    static let bottomMargin = ConstraintEqual(rawValue: 1 << 6)
    static let trailingMargin = ConstraintEqual(rawValue: 1 << 7)
    
    static let topSafeArea = ConstraintEqual(rawValue: 1 << 8)
    static let leadingSafeArea = ConstraintEqual(rawValue: 1 << 9)
    static let bottomSafeArea = ConstraintEqual(rawValue: 1 << 10)
    static let trailingSafeArea = ConstraintEqual(rawValue: 1 << 11)
    
    static let centerVertical = ConstraintEqual(rawValue: 1 << 12)
    static let centerHorizontal = ConstraintEqual(rawValue: 1 << 13)
    
    static let centerVerticalMargin = ConstraintEqual(rawValue: 1 << 14)
    static let centerHorizontalMargin = ConstraintEqual(rawValue: 1 << 15)
    
    static let centerVerticalSafeArea = ConstraintEqual(rawValue: 1 << 16)
    static let centerHorizontalSafeArea = ConstraintEqual(rawValue: 1 << 17)
    
    static let edges: ConstraintEqual = [top, leading, bottom, trailing]
    static let marginEdges: ConstraintEqual = [topMargin, leadingMargin, bottomMargin, trailingMargin]
    static let safeAreaEdges: ConstraintEqual = [topSafeArea, leadingSafeArea, bottomSafeArea, trailingSafeArea]
    static let center: ConstraintEqual = [centerVertical, centerHorizontal]
    static let centerMargin: ConstraintEqual = [centerVerticalMargin, centerHorizontalMargin]
    static let centerSafeArea: ConstraintEqual = [centerVerticalSafeArea, centerHorizontalSafeArea]
}

extension UIView {
    
    convenience init(containingView: UIView,
                     withConstaintEquals equals: ConstraintEqual,
                     insetsConstant: NSDirectionalEdgeInsets = .zero) {
        self.init(frame: .zero)
        addSubview(containingView, withConstaintEquals: equals,
                   insetsConstant: insetsConstant)
    }
    
    @discardableResult
    func addSubview(_ view: UIView,
                    withConstaintEquals equals: ConstraintEqual,
                    insetsConstant: NSDirectionalEdgeInsets = .zero ) -> Self {
        addSubview(view)
        
        guard !equals.isEmpty else { return self }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if equals.contains(.top) {
            view.topAnchor.constraint(equalTo: topAnchor,
                                      constant: insetsConstant.top).isActive = true
        }
        
        if equals.contains(.bottom) {
            view.bottomAnchor.constraint(equalTo: bottomAnchor,
                                         constant: -insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.leading) {
            view.leadingAnchor.constraint(equalTo: leadingAnchor,
                                          constant: insetsConstant.leading).isActive = true
        }
        
        if equals.contains(.trailing) {
            view.trailingAnchor.constraint(equalTo: trailingAnchor,
                                           constant:  -insetsConstant.trailing).isActive = true
        }
        
        if equals.contains(.topMargin) {
            view.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor,
                                      constant: insetsConstant.top).isActive = true
        }
        
        if equals.contains(.bottomMargin) {
            view.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor,
                                         constant: -insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.leadingMargin) {
            view.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor,
                                          constant: insetsConstant.leading).isActive = true
        }
        
        if equals.contains(.trailingMargin) {
            view.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor,
                                           constant:  -insetsConstant.trailing).isActive = true
        }
        
        
        if equals.contains(.topSafeArea) {
            view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                      constant: insetsConstant.top).isActive = true
        }
        
        if equals.contains(.bottomSafeArea) {
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                         constant: -insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.leadingSafeArea) {
            view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                          constant: insetsConstant.leading).isActive = true
        }
        
        if equals.contains(.trailingSafeArea) {
            view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                           constant:  -insetsConstant.trailing).isActive = true
        }
        
        
        if equals.contains(.centerVertical) {
            view.centerYAnchor.constraint(equalTo: centerYAnchor,
                                          constant: insetsConstant.top - insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.centerHorizontal) {
            view.centerXAnchor.constraint(equalTo:centerXAnchor,
                                          constant: insetsConstant.leading - insetsConstant.trailing).isActive = true
        }
        
        
        if equals.contains(.centerVerticalMargin) {
            view.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor,
                                          constant: insetsConstant.top - insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.centerHorizontalMargin) {
            view.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor,
                                          constant: insetsConstant.leading - insetsConstant.trailing).isActive = true
        }
        
        
        if equals.contains(.centerVerticalSafeArea) {
            view.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor,
                                          constant: insetsConstant.top - insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.centerHorizontalSafeArea) {
            view.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor,
                                          constant: insetsConstant.leading - insetsConstant.trailing).isActive = true
        }
        // for chaining function
        return self
    }
    
    func addConstraints(toView view: UIView,
                        withConstaintEquals equals: ConstraintEqual,
                        insetsConstant: NSDirectionalEdgeInsets = .zero) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if equals.contains(.top) {
            view.topAnchor.constraint(equalTo: topAnchor,
                                      constant: insetsConstant.top).isActive = true
        }
        
        if equals.contains(.bottom) {
            view.bottomAnchor.constraint(equalTo: bottomAnchor,
                                         constant: -insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.leading) {
            view.leadingAnchor.constraint(equalTo: leadingAnchor,
                                          constant: insetsConstant.leading).isActive = true
        }
        
        if equals.contains(.trailing) {
            view.trailingAnchor.constraint(equalTo: trailingAnchor,
                                           constant:  -insetsConstant.trailing).isActive = true
        }
        
        if equals.contains(.topMargin) {
            view.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor,
                                      constant: insetsConstant.top).isActive = true
        }
        
        if equals.contains(.bottomMargin) {
            view.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor,
                                         constant: -insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.leadingMargin) {
            view.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor,
                                          constant: insetsConstant.leading).isActive = true
        }
        
        if equals.contains(.trailingMargin) {
            view.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor,
                                           constant:  -insetsConstant.trailing).isActive = true
        }
        
        
        if equals.contains(.topSafeArea) {
            view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                      constant: insetsConstant.top).isActive = true
        }
        
        if equals.contains(.bottomSafeArea) {
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                         constant: -insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.leadingSafeArea) {
            view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                          constant: insetsConstant.leading).isActive = true
        }
        
        if equals.contains(.trailingSafeArea) {
            view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                           constant:  -insetsConstant.trailing).isActive = true
        }
        
        
        if equals.contains(.centerVertical) {
            view.centerYAnchor.constraint(equalTo: centerYAnchor,
                                          constant: insetsConstant.top - insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.centerHorizontal) {
            view.centerXAnchor.constraint(equalTo:centerXAnchor,
                                          constant: insetsConstant.leading - insetsConstant.trailing).isActive = true
        }
        
        
        if equals.contains(.centerVerticalMargin) {
            view.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor,
                                          constant: insetsConstant.top - insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.centerHorizontalMargin) {
            view.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor,
                                          constant: insetsConstant.leading - insetsConstant.trailing).isActive = true
        }
        
        
        if equals.contains(.centerVerticalSafeArea) {
            view.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor,
                                          constant: insetsConstant.top - insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.centerHorizontalSafeArea) {
            view.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor,
                                          constant: insetsConstant.leading - insetsConstant.trailing).isActive = true
        }
    }
    
    func addConstraints(toView view: UIView,
                        withConstaintGreaterThanOrEquals greaterThanOrEquals: ConstraintEqual,
                        insetsConstant: NSDirectionalEdgeInsets = .zero) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if greaterThanOrEquals.contains(.top) {
            view.topAnchor.constraint(greaterThanOrEqualTo: topAnchor,
                                      constant: insetsConstant.top).isActive = true
        }
        
        if greaterThanOrEquals.contains(.bottom) {
            view.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor,
                                         constant: -insetsConstant.bottom).isActive = true
        }
        
        if greaterThanOrEquals.contains(.leading) {
            view.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor,
                                          constant: insetsConstant.leading).isActive = true
        }
        
        if greaterThanOrEquals.contains(.trailing) {
            trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor,
                                           constant:  insetsConstant.trailing).isActive = true
        }
        
        if greaterThanOrEquals.contains(.topMargin) {
            view.topAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.topAnchor,
                                      constant: insetsConstant.top).isActive = true
        }
        
        if greaterThanOrEquals.contains(.bottomMargin) {
            bottomAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor,
                                         constant: insetsConstant.bottom).isActive = true
        }
        
        if greaterThanOrEquals.contains(.leadingMargin) {
            view.leadingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leadingAnchor,
                                          constant: insetsConstant.leading).isActive = true
        }
        
        if greaterThanOrEquals.contains(.trailingMargin) {
            trailingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor,
                                           constant:  insetsConstant.trailing).isActive = true
        }
        
        
        if greaterThanOrEquals.contains(.topSafeArea) {
            view.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor,
                                      constant: insetsConstant.top).isActive = true
        }
        
        if greaterThanOrEquals.contains(.bottomSafeArea) {
            bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor,
                                         constant: insetsConstant.bottom).isActive = true
        }
        
        if greaterThanOrEquals.contains(.leadingSafeArea) {
            view.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor,
                                          constant: insetsConstant.leading).isActive = true
        }
        
        if greaterThanOrEquals.contains(.trailingSafeArea) {
            trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor,
                                           constant:  insetsConstant.trailing).isActive = true
        }
        
        if greaterThanOrEquals.contains(.centerVertical) {
            view.centerYAnchor.constraint(greaterThanOrEqualTo: centerYAnchor,
                                                              constant: 0).isActive = true
        }
        
        if greaterThanOrEquals.contains(.centerHorizontal) {
            view.centerXAnchor.constraint(greaterThanOrEqualTo: centerXAnchor,
                                                              constant: 0).isActive = true
        }
    }
}

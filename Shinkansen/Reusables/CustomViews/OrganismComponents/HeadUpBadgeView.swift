//
//  HeadUpBadgeView.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 11/03/2022.
//

import UIKit
import Anchorage
class HeadsUpBadgeControl: TouchableControl {
    
    private var label: Label
    
    init() {
        label = Label()
        super.init(frame: .zero)
        setupView()
        setupTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(label)
        label.horizontalAnchors == contentView.horizontalAnchors + 16
        label.verticalAnchors == contentView.verticalAnchors + 12
    }
    
    func setupTheme() {
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .subtext
        
    }
    
    func setupContent(message: String,
                      animated: Bool = true,
                      delay: TimeInterval = 0,
                      completion: ((Bool)->())? = nil) {
        label.text = message
        isHidden = false
        if animated {
            alpha = 0
            layoutIfNeeded()
            transform.ty = -bounds.height * 1.5
            UIView.animate(withStyle: .halfTransitionAnimationStyle,
                           delay: delay,
                           animations: {
                            self.alpha = 1
                            self.transform.ty = 0
            },
                           completion: completion)
        }
    }
    
    func dismiss(animated: Bool = true,
                 delay: TimeInterval = 0,
                 removeWhenComplete: Bool = true,
                 completion: ((Bool)->())? = nil) {
        isHidden = false
        if animated {
            layer.removeAllAnimations()
            alpha = 1
            transform.ty = 0
            UIView
                .animate(withStyle: .transitionAnimationStyle,
                         delay: delay,
                         animations: {
                            [weak self] in
                            self?.alpha = 0
                            self?.transform.ty = -(self?.bounds.height ?? 0) * 1.5
                }, completion: {
                    finished in
                    if removeWhenComplete { self.removeFromSuperview() }
                    if let completion = completion {
                        completion(finished)
                    }
                })
        } else {
            if removeWhenComplete { self.removeFromSuperview() }
            if let completion = completion {
                completion(true)
            }
        }
    }
}

//
//  CALayer.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 25/09/2020.
//

import UIKit

extension CALayer {

    func setOpacityAnimated(_ toOpacity: Float) {
        let anim = createCABasicAnimation(keyPath: "opacity", fromValue: opacity, toValue: toOpacity)
        
        add(anim, forKey: "layerAnimation")
        opacity = toOpacity
    }
    
    func setTransformAnimated(_ toTransform: CATransform3D) {
        let anim = createCABasicAnimation(keyPath: "transform", fromValue: transform, toValue: toTransform)
        
        add(anim, forKey: "layerAnimation")
        transform = toTransform
    }
    
    private func createCABasicAnimation(keyPath: String,
                                        fromValue: Any?,
                                        toValue: Any?,
                                        isRemovedOnCompletion: Bool = false) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.isRemovedOnCompletion = isRemovedOnCompletion

        return animation

    }
}

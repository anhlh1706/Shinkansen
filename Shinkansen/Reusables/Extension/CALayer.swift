//
//  CALayer.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 25/09/2020.
//

import UIKit

extension CALayer {
    
    func setLayerStyle(_ layerStyle: LayerStyle) {
        
        opacity = layerStyle.opacity

        cornerRadius = layerStyle.cornerRadius
        
        backgroundColor = layerStyle.backgroundColor?.cgColor

        shadowOpacity = layerStyle.shadowStyle.shadowOpacity

        shadowRadius = layerStyle.shadowStyle.shadowRadius

        shadowOffset.width = layerStyle.shadowStyle.shadowOffset.width

        shadowOffset.height = layerStyle.shadowStyle.shadowOffset.height
    }
    
    func setShadowStyle(_ shadowStyle: ShadowStyle) {
        shadowOpacity = shadowStyle.shadowOpacity
        shadowRadius = shadowStyle.shadowRadius
        shadowOffset = shadowStyle.shadowOffset
        shadowColor = shadowStyle.shadowColor?.cgColor
    }

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

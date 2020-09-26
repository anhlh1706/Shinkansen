//
//  CALayer.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 25/09/2020.
//

import UIKit

struct ShadowStyle {

    var shadowOpacity: Float

    var shadowRadius: CGFloat

    var shadowOffset: CGSize

    var shadowColor: UIColor?
    
    init(shadowOpacity: Float = 1.0,
         shadowRadius: CGFloat = 0,
         shadowOffset: CGSize = .zero,
         shadowColor: UIColor? = nil) {
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.shadowColor = shadowColor
    }
    
    static func normalCard() -> ShadowStyle {
        return ShadowStyle(shadowOpacity: 0.12, shadowRadius: 10, shadowOffset: .init(width: 0, height: 5), shadowColor: .black)
    }
}

struct LayerStyle {
    
    var opacity: Float
    
    var cornerRadius: CGFloat
    
    var backgroundColor: UIColor?
    
    var shadowStyle: ShadowStyle
    
    static func normalCard() -> LayerStyle {
        return LayerStyle(opacity: 1, cornerRadius: 8, backgroundColor: .background, shadowStyle: ShadowStyle.normalCard())
    }
}

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

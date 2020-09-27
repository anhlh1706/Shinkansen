//
//  LayerStyle.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 26/09/2020.
//

import UIKit

struct LayerStyle {
    
    var opacity: Float
    
    var cornerRadius: CGFloat
    
    var backgroundColor: UIColor?
    
    var shadowStyle: ShadowStyle
    
    enum card {
        static var normal: LayerStyle {
            LayerStyle(opacity: 1, cornerRadius: 8, backgroundColor: .background, shadowStyle: ShadowStyle.card.normal)
        }
    }
    
    enum segmentedItem {
        static var normal: LayerStyle {
            LayerStyle(opacity: 1, cornerRadius: 8, backgroundColor: .background, shadowStyle: ShadowStyle.card.normal)
        }
        
        static var selected: LayerStyle {
            LayerStyle(opacity: 0, cornerRadius: 0, backgroundColor: .clear, shadowStyle: .noShadow)
        }
    }
    
    enum segmentedControl {
        static var normal: LayerStyle {
            LayerStyle(opacity: 1, cornerRadius: 12, backgroundColor: .background, shadowStyle: ShadowStyle.card.disabled)
        }
    }
    
}

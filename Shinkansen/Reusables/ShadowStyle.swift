//
//  ShadowStyle.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 26/09/2020.
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
    
    static var noShadow: ShadowStyle {
        ShadowStyle(shadowOpacity: 0, shadowRadius: 0, shadowOffset: .zero, shadowColor: .clear)
    }
    
    enum card {
        static var normal: ShadowStyle {
            ShadowStyle(shadowOpacity: 0.12, shadowRadius: 10, shadowOffset: .init(width: 0, height: 5), shadowColor: .black)
        }
        
        static var highlighted: ShadowStyle {
            ShadowStyle(shadowOpacity: 0.1, shadowRadius: 2, shadowOffset: .init(width: 0, height: 2), shadowColor: .black)
        }
        
        static var disabled: ShadowStyle {
            ShadowStyle(shadowOpacity: 0.08, shadowRadius: 14, shadowOffset: .init(width: 0, height: 2), shadowColor: .black)
        }
    }
    
    enum segmentedItem {
        
        static var normal: ShadowStyle {
            ShadowStyle(shadowOpacity: 0,
                               shadowRadius: 0,
                               shadowOffset: .init(width: 0, height: 0),
                               shadowColor: .black)
        }
        
        static var selected: ShadowStyle {
            ShadowStyle(shadowOpacity: 0.12,
                               shadowRadius: 10,
                               shadowOffset: .init(width: 0, height: 5),
                               shadowColor: .black)
        }
    }
}

//
//  TouchableControl.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 29/09/2020.
//

import UIKit
import Anchorage

/// Define a Touchable Control with an empty contentView and touch down/up animation
class TouchableControl: UIControl {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0.55
            self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            self.layer.setShadowStyle(ShadowStyle.card.highlighted)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.alpha = self.isHighlighted ? 0.54 : 1
            self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
            self.layer.setShadowStyle(ShadowStyle.card.normal)
        }
    }
    
    var contentView: UIView
    
    override init(frame: CGRect) {
        contentView = UIView()
        contentView.isUserInteractionEnabled = false
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(contentView)
        contentView.edgeAnchors == edgeAnchors
        
        contentView.backgroundColor = .background
        contentView.layer.setLayerStyle(LayerStyle.card.normal)
    }
}

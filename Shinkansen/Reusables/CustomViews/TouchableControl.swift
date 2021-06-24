//
//  TouchableControl.swift
//  Base
//
//  Created by Lê Hoàng Anh on 29/09/2020.
//

import UIKit
import Anchorage

/// Define a Touchable Control with an empty contentView and touch down/up animation
class TouchableControl: UIControl {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        UIView.animate(withDuration: 0.2) { [self] in
            alpha = 0.55
            transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            layer.setShadowStyle(ShadowStyle.card.highlighted)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) { [self] in
            alpha = isHighlighted ? 0.54 : 1
            transform = isHighlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
            layer.setShadowStyle(ShadowStyle.card.normal)
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
        contentView.clipsToBounds = true
        addSubview(contentView)
        contentView.edgeAnchors == edgeAnchors
        
        contentView.backgroundColor = .background
        contentView.layer.setLayerStyle(LayerStyle.card.normal)
        layer.setLayerStyle(LayerStyle.card.normal)
    }
}

class TouchableButton: UIButton {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        UIView.animate(withDuration: 0.15) { [self] in
            transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        super.sendActions(for: .touchDown)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.15) { [self] in
            transform = isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
        }
        
        guard let touchPoint = touches.first?.location(in: self) else { return }
        if bounds.contains(touchPoint) {
            super.sendActions(for: .touchUpInside)
        } else {
            super.sendActions(for: .touchUpOutside)
        }
    }
}

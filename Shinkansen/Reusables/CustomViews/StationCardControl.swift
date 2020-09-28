//
//  StationCardControl.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 25/09/2020.
//

import UIKit
import Anchorage

final class StationCardControl: UIControl {
    
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
    
    var basedHeight: CGFloat = 72 {
        didSet {
            heightConstraint.constant = basedHeight
        }
    }
    
    var stationNameJP: String?
    
    var stationName: String?
    
    private var heightConstraint: NSLayoutConstraint
    
    private var contentStackView: UIStackView
    
    private var stationNameJPLabel: Label
    
    private var stationNameLabel: Label
    
    var contentView: UIView
    
    init(stationNameJP: String? = nil,
         stationName: String? = nil) {
        heightConstraint = NSLayoutConstraint()
        contentStackView = UIStackView()
        stationNameJPLabel = Label()
        stationNameLabel = Label()
        contentView = UIView()
        contentView.isUserInteractionEnabled = false
        contentStackView.isUserInteractionEnabled = false
        super.init(frame: .zero)
        setupView()
        setupTheme()
        setupValue(stationNameJP: stationNameJP, stationName: stationName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = heightAnchor.constraint(equalToConstant: basedHeight)
        
        heightConstraint.isActive = true
        contentStackView.spacing = 0
        
        contentStackView.axis = .vertical
        
        addSubview(contentView)
        contentView.edgeAnchors == edgeAnchors
        
        contentView.addSubview(contentStackView)
        contentStackView.centerAnchors == contentView.centerAnchors
        
        stationNameJPLabel.textAlignment = .center
        stationNameLabel.textAlignment = .center
        
        contentStackView.addArrangedSubview(stationNameJPLabel)
        contentStackView.addArrangedSubview(stationNameLabel)
        contentStackView.alignment = .center
        contentView.backgroundColor = .background
        contentView.layer.setLayerStyle(LayerStyle.card.normal)
    }
    
    func setupValue(stationNameJP: String? = nil,
                    stationName: String? = nil) {
        stationNameJPLabel.text = stationNameJP
        stationNameLabel.text = stationName
    }
    
    func setupTheme() {
        heightConstraint.constant = basedHeight
        
        stationNameJPLabel.font = .systemFont(ofSize: 24)
        stationNameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        stationNameJPLabel.textColor = .primary
        stationNameLabel.textColor = .primary
    }
}

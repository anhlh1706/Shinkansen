//
//  StationCardControl.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 25/09/2020.
//

import UIKit
import Anchorage

/// From Touchable Control, adding a stack of 2 labels to show kanji and latin name of station
final class StationCardControl: TouchableControl {
    
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
    
    init(stationNameJP: String? = nil,
         stationName: String? = nil) {
        heightConstraint = NSLayoutConstraint()
        contentStackView = UIStackView()
        stationNameJPLabel = Label()
        stationNameLabel = Label()
        contentStackView.isUserInteractionEnabled = false
        super.init(frame: .zero)
        setupView()
        setupValue(stationNameJP: stationNameJP, stationName: stationName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        heightConstraint = (heightAnchor == basedHeight)
        heightConstraint.isActive = true
        
        contentStackView.spacing = 0
        contentStackView.axis = .vertical
        
        contentView.addSubview(contentStackView)
        contentStackView.centerAnchors == contentView.centerAnchors
        
        stationNameJPLabel.textAlignment = .center
        stationNameLabel.textAlignment = .center
        
        contentStackView.addArrangedSubview(stationNameJPLabel)
        contentStackView.addArrangedSubview(stationNameLabel)
        contentStackView.alignment = .center
        contentView.backgroundColor = .background
        contentView.layer.setLayerStyle(LayerStyle.card.normal)
        
        heightConstraint.constant = basedHeight
        
        stationNameJPLabel.font = .systemFont(ofSize: 24)
        stationNameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        stationNameJPLabel.textColor = .primary
        stationNameLabel.textColor = .primary
    }
    
    func setupValue(stationNameJP: String? = nil,
                    stationName: String? = nil) {
        stationNameJPLabel.text = stationNameJP
        stationNameLabel.text = stationName
    }
}

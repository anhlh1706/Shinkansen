//
//  StationCardControl.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 25/09/2020.
//

import UIKit
import Anchorage

final class StationCardControl: UIControl {
    
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
    
    private var contentView: UIView
    
    var currentState: State = .normal {
        didSet {
            updateAppearance()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            currentState = isEnabled ? .normal : .disabled
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isEnabled {
                currentState = isHighlighted ? .highlighted : .normal
            }
        }
    }
    
    init(stationNameJP: String? = nil,
         stationName: String? = nil) {
        contentView = UIView()
        heightConstraint = NSLayoutConstraint()
        contentStackView = UIStackView()
        stationNameJPLabel = Label()
        stationNameLabel = Label()
        super.init(frame: .zero)
        setupView()
        setupValue(stationNameJP: stationNameJP, stationName: stationName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateAppearance() {
        let contentViewOpacity: Float = currentState == .highlighted ? 0.54 : 1
        contentView.layer.setOpacityAnimated(contentViewOpacity)
        
        let transform = currentState == .highlighted ? CATransform3DMakeScale(0.98, 0.98, 1) : CATransform3DIdentity
        contentView.layer.setTransformAnimated(transform)
        
    }
    
    private func setupView() {
        addSubview(contentView)
        contentView.edgeAnchors == edgeAnchors
        contentView.clipsToBounds = true
        contentView.isUserInteractionEnabled = false
        
        translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = heightAnchor.constraint(equalToConstant: basedHeight)
        
        heightConstraint.isActive = true
        contentStackView.spacing = 0
        
        stationNameJPLabel.textAlignment = .center
        stationNameLabel.textAlignment = .center
        
        contentStackView.addArrangedSubview(stationNameJPLabel)
        contentStackView.addArrangedSubview(stationNameLabel)
        
        contentStackView.axis = .vertical
        
        contentView.addSubview(contentStackView)
        contentStackView.edgeAnchors == contentView.edgeAnchors
    }
    
    public func setupValue(stationNameJP: String? = nil,
                    stationName: String? = nil) {
        stationNameJPLabel.text = stationNameJP
        stationNameLabel.text = stationName
    }
    
//    public func setupTheme() {
//        heightConstraint.constant = basedHeight.systemSizeMuliplier()
//        
//        stationNameJPLabel.textStyle = textStyle.title1()
//        stationNameLabel.textStyle = textStyle.caption1Alt()
//        
//        stationNameJPLabel.textColor = currentColorTheme.componentColor.callToAction
//        stationNameLabel.textColor = currentColorTheme.componentColor.callToAction
//    }
}

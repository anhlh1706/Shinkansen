//
//  StationPairView.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 28/09/2020.
//

import UIKit

final class StationPairView: UIStackView {
    
    var fromStationHeadlineView: VerticalLabelsStackView
    
    var toStationHeadlineView: VerticalLabelsStackView
    
    var toLabel: Label
    
    init(fromStation: String, fromTime: String? = nil,
         toStation: String, toTime: String? = nil) {
        fromStationHeadlineView = VerticalLabelsStackView(title: fromStation, subtitle: fromTime, textAlignment: .left)
        toStationHeadlineView = VerticalLabelsStackView(title: toStation, subtitle: toTime, textAlignment: .right)
        toLabel = Label()
        super.init(frame: .zero)
        setupView()
        setupTheme()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        alignment = .firstBaseline
        distribution = .equalSpacing
        addArrangedSubview(fromStationHeadlineView)
        addArrangedSubview(toLabel)
        addArrangedSubview(toStationHeadlineView)
        
        toLabel.text = "to"
        toLabel.textAlignment = .center
    }
    
    public func setupTheme() {
        fromStationHeadlineView.setupTheme()
        toStationHeadlineView.setupTheme()
        toLabel.textColor = .subtext
        toLabel.font = .systemFont(ofSize: 16)
    }
    
    public func setupValue(fromStation: String, fromTime: String? = nil,
                          toStation: String, toTime: String? = nil) {
        fromStationHeadlineView.setupValue(title: fromStation, subtitle: fromTime)
        toStationHeadlineView.setupValue(title: toStation, subtitle: toTime)
        
        fromStationHeadlineView.subtitleLabel.isHidden = fromTime == nil && toTime == nil
        toStationHeadlineView.subtitleLabel.isHidden = fromTime == nil && toTime == nil
        
    }
}

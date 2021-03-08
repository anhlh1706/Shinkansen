//
//  TrainScheduleTableCell.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 29/09/2020.
//

import UIKit
import Anchorage

final class TrainScheduleTableViewCell: UITableViewCell {
    var touchableView: TouchableControl
    var timeLabelSetView: VerticalLabelsStackView
    var trainLabelSetView: VerticalLabelsStackView
    var granClassIconImageView: SeatClassIconImageView
    var greenIconImageView: SeatClassIconImageView
    var ordinaryIconImageView: SeatClassIconImageView
    var priceLabel: Label
    var classIconStackView: UIStackView
    var trainImageView: UIImageView
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: nil)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        touchableView = TouchableControl()
        timeLabelSetView = VerticalLabelsStackView()
        trainLabelSetView = VerticalLabelsStackView()
        
        timeLabelSetView.type = .regular
        trainLabelSetView.type = .small
        trainLabelSetView.textAlignment = .right
        
        granClassIconImageView = SeatClassIconImageView(seatClass: .granClass,
                                                        iconSize: .small)
        greenIconImageView = SeatClassIconImageView(seatClass: .green,
                                                    iconSize: .small)
        ordinaryIconImageView = SeatClassIconImageView(seatClass: .ordinary,
                                                       iconSize: .small)
        priceLabel = Label()
        classIconStackView = UIStackView()
        trainImageView = UIImageView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        selectionStyle = .none
        preservesSuperviewLayoutMargins = true
        contentView.preservesSuperviewLayoutMargins = true
        contentView.isUserInteractionEnabled = false
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(touchableView)
        touchableView.edgeAnchors == contentView.edgeAnchors + UIEdgeInsets(top: 4, left: 15, bottom: 12, right: 15)
        
        let seatClassStackView = UIStackView([granClassIconImageView,
                                              greenIconImageView,
                                              ordinaryIconImageView], distribution: .fill, alignment: .fill, spacing: 8)
        
        let seatClassAndPriceStackView = UIStackView([seatClassStackView, priceLabel],
                                                     axis: .vertical,
                                                     distribution: .fill, alignment: .leading, spacing: 4)
        
        let headerTextDetailStackView = UIStackView([timeLabelSetView, trainLabelSetView],
                                                    axis: .horizontal,
                                                    distribution: .equalSpacing,
                                                    alignment: .top)
        
        let verticalStackView = UIStackView([headerTextDetailStackView, seatClassAndPriceStackView],
                                            axis: .vertical,
                                            distribution: .fill,
                                            alignment: .fill,
                                            spacing: 24)
        
        touchableView.contentView.addSubview(verticalStackView)
        verticalStackView.edgeAnchors == touchableView.contentView.edgeAnchors + 16
        
        touchableView.contentView.addSubview(trainImageView)
        trainImageView.bottomAnchor == touchableView.contentView.bottomAnchor - 16
        
        trainImageView.topAnchor == headerTextDetailStackView.bottomAnchor + 8
        
        touchableView.centerXAnchor == trainImageView.leadingAnchor + 32
        trainImageView.widthAnchor == trainImageView.heightAnchor * 6
        
        trainImageView.setContentCompressionResistancePriority(.init(rawValue: 249), for: .vertical)
        trainImageView.setContentCompressionResistancePriority(.init(rawValue: 249), for: .horizontal)
       
        trainImageView.image = nil
    }
    
    public func setupTheme() {
        timeLabelSetView.setupTheme()
        trainLabelSetView.setupTheme()
        granClassIconImageView.setupTheme()
        greenIconImageView.setupTheme()
        ordinaryIconImageView.setupTheme()
        priceLabel.font = .systemFont(ofSize: 13, weight: .medium)
        priceLabel.textColor = .subtext
    }
    
    public func setupValue(time: String,
                           amountOfTime: String? = nil,
                           trainNumber: String? = nil,
                           trainName: String? = nil,
                           showGranClassIcon: Bool = true,
                           isGranClassAvailable: Bool = true,
                           showGreenIcon: Bool = true,
                           isGreenAvailable: Bool = true,
                           showOrdinaryIcon: Bool = true,
                           isOrdinaryAvailable: Bool = true,
                           price: String? = nil,
                           trainImage: UIImage? = nil) {
        timeLabelSetView.setupValue(title: time, subtitle: amountOfTime)
        trainLabelSetView.setupValue(title: trainNumber ?? "", subtitle: trainName)
        granClassIconImageView.isHidden = !showGranClassIcon
        granClassIconImageView.isAvailable = isGranClassAvailable

        greenIconImageView.isHidden = !showGreenIcon
        greenIconImageView.isAvailable = isGreenAvailable

        ordinaryIconImageView.isHidden = !showOrdinaryIcon
        ordinaryIconImageView.isAvailable = isOrdinaryAvailable
        priceLabel.text = price
        
        trainImageView.image = trainImage
    }
    
    public func preparePropertiesForAnimation() {
        contentView.alpha = 0
        trainImageView.transform.tx = trainImageView.bounds.width
    }
    
    public func setPropertiesToIdentity() {
        contentView.alpha = 1
        trainImageView.transform.tx = 0
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        touchableView.isHighlighted = highlighted
    }
}

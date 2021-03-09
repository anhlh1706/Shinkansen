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
    
    func setupTheme() {
        timeLabelSetView.setupTheme()
        trainLabelSetView.setupTheme()
        granClassIconImageView.setupTheme()
        greenIconImageView.setupTheme()
        ordinaryIconImageView.setupTheme()
        priceLabel.font = .systemFont(ofSize: 13, weight: .medium)
        priceLabel.textColor = .subtext
    }
    
    func setup(trainSchedule: TrainSchedule, timeOffset: TimeInterval) {
        let granClassObject = trainSchedule.seatClasses.first(where: {
            $0.seatClass == .granClass
        })
        
        let greenObject = trainSchedule.seatClasses.first(where: {
            $0.seatClass == .green
        })
        
        let ordinaryObject = trainSchedule.seatClasses.first(where: {
            $0.seatClass == .ordinary
        })
        
        let availableObjects = [granClassObject, greenObject, ordinaryObject].compactMap { $0 }
        
        let cheapestPrice = availableObjects.map { $0.price }.min()
        
        // MARK: Offset of time is only for a sake of mock data
        let fromTimeString = trainSchedule.fromTime.addingTimeInterval(timeOffset).time
        let toTimeString = trainSchedule.toTime.addingTimeInterval(timeOffset).time
        
        let time = "\(fromTimeString) – \(toTimeString)"
        let amountOfTime = trainSchedule.toTime.offset(from: trainSchedule.fromTime)
        
        timeLabelSetView.setupValue(title: time, subtitle: amountOfTime)
        trainLabelSetView.setupValue(title: trainSchedule.trainNumber , subtitle: trainSchedule.trainName)
        granClassIconImageView.isHidden = granClassObject == nil
        granClassIconImageView.isAvailable = granClassObject?.isAvailable ?? false

        greenIconImageView.isHidden = greenObject == nil
        greenIconImageView.isAvailable = greenObject?.isAvailable ?? false

        ordinaryIconImageView.isHidden = ordinaryObject == nil
        ordinaryIconImageView.isAvailable = ordinaryObject?.isAvailable ?? false
        priceLabel.text = "from \(cheapestPrice?.yen ?? "-")"
        
        trainImageView.image = UIImage(named: trainSchedule.trainImageName)
    }
    
    func preparePropertiesForAnimation() {
        contentView.alpha = 0
        trainImageView.transform.tx = trainImageView.bounds.width
    }
    
    func setPropertiesToIdentity() {
        contentView.alpha = 1
        trainImageView.transform.tx = 0
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        touchableView.isHighlighted = highlighted
    }
}

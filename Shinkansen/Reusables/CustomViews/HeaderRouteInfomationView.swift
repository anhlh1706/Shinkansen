//
//  HeaderRouteInfomationView.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 28/09/2020.
//

import UIKit
import Anchorage

final class HeaderRouteInformationView: UIStackView {
    
    var stationPairView: StationPairView
    
//    var descriptionSetView: DescriptionSetView
    
    init(fromStation: String, fromTime: String? = nil,
         toStation: String, toTime: String? = nil,
         trainNumber: String? = nil,
         trainName: String? = nil,
         carNumber: String? = nil,
         className: String? = nil,
         seatNumber: String? = nil,
         price: String? = nil) {
        
        stationPairView = .init(fromStation: fromStation, fromTime: fromTime,
                                toStation: toStation, toTime: toTime)
//        descriptionSetView = .init(trainNumber: trainNumber ?? " ",
//                                   trainName: trainName,
//                                   carNumber: carNumber,
//                                   className: className,
//                                   seatNumber: seatNumber,
//                                   price: price)
//
//            descriptionSetView.isHidden = trainNumber == nil && trainName == nil &&
//                carNumber == nil && className == nil && seatNumber == nil && price == nil
        
        super.init(frame: .zero)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .vertical
        spacing = 24
        addArrangedSubview(stationPairView)
//        addArrangedSubview(descriptionSetView)
    }
    
    public func setupTheme() {
        stationPairView.setupTheme()
//        descriptionSetView.setupTheme()
        spacing = 24
    }
    
    public func setupValue(fromStation: String, fromTime: String? = nil,
                          toStation: String, toTime: String? = nil,
                          trainNumber: String? = nil,
                          trainName: String? = nil,
                          carNumber: String? = nil,
                          className: String? = nil,
                          seatNumber: String? = nil,
                          price: String? = nil) {
        
        stationPairView.setupValue(fromStation: fromStation, fromTime: fromTime,
                                  toStation: toStation, toTime: toTime)
//        descriptionSetView.setupValue(trainNumber: trainNumber ?? " ",
//                                     trainName: trainName,
//                                     carNumber: carNumber,
//                                     className: className,
//                                     seatNumber: seatNumber,
//                                     price: price)
//
//        descriptionSetView.isHidden = trainNumber == nil && trainName == nil &&
//            carNumber == nil && className == nil && seatNumber == nil && price == nil
    }
    
    public func verticalRubberBandEffect(byVerticalContentOffset contentOffsetY: CGFloat) {
        
        // To filter only negative offset otherwise there will have no effect
        guard contentOffsetY < 0 else {
            stationPairView.transform.ty = 0
//            descriptionSetView.transform.ty = 0
            return
        }
        let stationPairViewAppliedVerticalEffectPercentage: CGFloat = {
            return (stationPairView.bounds.height / 2) / bounds.height
        }()
        let descriptionSetViewAppliedVerticalEffectPercentage: CGFloat = {
            return (stationPairView.bounds.height
                + spacing)
//                + descriptionSetView.bounds.height / 2)
                / bounds.height
        }()
        stationPairView.transform.ty = -contentOffsetY * stationPairViewAppliedVerticalEffectPercentage
//        descriptionSetView.transform.ty = -contentOffsetY * descriptionSetViewAppliedVerticalEffectPercentage
    }
}

//
//  BookingCriteriaViewController.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 25/09/2020.
//

import UIKit
import Anchorage

struct Station {
    var kanjiName: String
    var romajiName: String
}

final class BookingCriteriaViewController: UIViewController {
    
    var headerStackView: UIStackView!
    
    var headlineLabel: Label!
    
    var logoImageView: UIImageView!
    
    var stationsContainerStackView: UIStackView!
    
    var fromStationContainerView: HeadlineWithContainerView!
    
    var fromStationCardControl: StationCardControl!
    
    var arrowImageView: UIImageView!
    
    var destinationStationContainerView: HeadlineWithContainerView!
    
    var destinationStationCardControl: StationCardControl!
    
    var dateSegmentContainerView: HeadlineWithContainerView!
    
//    var dateSegment: !
    
    var timeSegmentContainerView: HeadlineWithContainerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Setup logo section
        headlineLabel = Label()
        headlineLabel.numberOfLines = 0
        
        logoImageView = UIImageView()
        logoImageView.setContentHuggingPriority(.required, for: .horizontal)
        
        headerStackView = UIStackView([headlineLabel, logoImageView],
                                      axis: .horizontal,
                                      distribution: .fill,
                                      alignment: .top)
        
        headlineLabel.font = .systemFont(ofSize: 36, weight: .light)
        headlineLabel.textColor = .primary
        
        headlineLabel.text = "Reserve \nShinkansen \nTickets"
    
        logoImageView.image = UIImage(named: "Logo JR East")
        logoImageView.tintColor = .primary
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.sizeAnchors == CGSize(width: 52, height: 52)
        
        view.addSubview(headerStackView)
        headerStackView.topAnchor == view.safeAreaLayoutGuide.topAnchor + 30
        headerStackView.horizontalAnchors == view.horizontalAnchors + 20
        
        
        // MARK: - Setup stations section
        fromStationCardControl = StationCardControl(stationNameJP: "東京", stationName: "Tokyo")
        fromStationContainerView = HeadlineWithContainerView(containingView: fromStationCardControl)
        fromStationContainerView.setTitle(title: "From")
        
        let arrowContainerView = UIView()
        arrowImageView = UIImageView(image: UIImage(named: "iconArrowRight"))
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.tintColor = .primary
        
        arrowContainerView.addSubview(arrowImageView)
        arrowImageView.horizontalAnchors == arrowContainerView.horizontalAnchors
        arrowImageView.bottomAnchor == arrowContainerView.bottomAnchor - 24
        
        destinationStationCardControl = StationCardControl(stationNameJP: "大阪", stationName: "Osaka")
        destinationStationContainerView = HeadlineWithContainerView(containingView: destinationStationCardControl)
        destinationStationContainerView.setTitle(title: "Destination")
        
        stationsContainerStackView = UIStackView(arrangedSubviews: [fromStationContainerView, arrowContainerView, destinationStationContainerView])
        
        view.addSubview(stationsContainerStackView)
        stationsContainerStackView.topAnchor == headerStackView.bottomAnchor + 60
        stationsContainerStackView.horizontalAnchors == view.horizontalAnchors + 20
        stationsContainerStackView.heightAnchor == 96
        
        let buttonsWidth = (stationsContainerStackView.widthAnchor / 2) - 20
        fromStationContainerView.widthAnchor == buttonsWidth
        destinationStationContainerView.widthAnchor == buttonsWidth
        
        // MARK: - Setup date segment
//        dateSegmentContainerView = HeadlineWithContainerView(title: "Date", containingView: UIView())
        
        
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

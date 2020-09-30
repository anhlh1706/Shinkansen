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

final class BookingCriteriaViewController: BookingViewController {
    
    var headerStackView: UIStackView!
    
    var headlineLabel: Label!
    
    var logoImageView: UIImageView!
    
    var stationsContainerStackView: UIStackView!
    
    var fromStationContainerView: HeadlineWithContainerView!
    
    var fromStationCardControl: StationCardControl!
    
    var arrowImageView: UIImageView!
    
    var destinationStationContainerView: HeadlineWithContainerView!
    
    var destinationStationCardControl: StationCardControl!
    
    var dateSegmentedContainerView: HeadlineWithContainerView!
    
    var dateSegmentedControl: SegmentedControl!
    
    var timeSegmentedContainerView: HeadlineWithContainerView!
    
    var timeSegmentedControl: SegmentedControl!
    
    var searchTicketButton: Button!
    
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
        
        destinationStationCardControl = StationCardControl(stationNameJP: "大宮", stationName: "Ōmiya")
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

        dateSegmentedControl = SegmentedControl()
        dateSegmentedContainerView = HeadlineWithContainerView(containingView: dateSegmentedControl)
        dateSegmentedControl.layer.setLayerStyle(LayerStyle.segmentedControl.normal)
        
        view.addSubview(dateSegmentedContainerView)
        dateSegmentedContainerView.topAnchor == stationsContainerStackView.bottomAnchor + 30
        dateSegmentedContainerView.horizontalAnchors == view.horizontalAnchors + 20
        dateSegmentedContainerView.heightAnchor == 98
        
        let today = Date()
        let tomorrow = today.addingTimeInterval(60 * 60 * 24)
        let formatter = DateFormatter.dateOnly()
        dateSegmentedContainerView.setTitle(title: "Date")
        dateSegmentedControl.items = [(title: "Today", subtitle: formatter.string(from: today), true),
                                      (title: "Tomorrow", subtitle: formatter.string(from: tomorrow), true),
                                      (title: "Pick a Date", subtitle: " ", true)]
        
        dateSegmentedControl
            .addTarget(self,
                       action: #selector(reloadTimeSegemtnedControl),
                       for: .valueChanged)
        
        // MARK: - Setup time section
        
        timeSegmentedControl = SegmentedControl()
        timeSegmentedContainerView = HeadlineWithContainerView(containingView: timeSegmentedControl)
        timeSegmentedControl.layer.setLayerStyle(LayerStyle.segmentedControl.normal)
        
        view.addSubview(timeSegmentedContainerView)
        timeSegmentedContainerView.topAnchor == dateSegmentedContainerView.bottomAnchor + 30
        timeSegmentedContainerView.horizontalAnchors == view.horizontalAnchors + 20
        timeSegmentedContainerView.heightAnchor == 98
        
        timeSegmentedContainerView.setTitle(title: "Time")
        
        reloadTimeSegemtnedControl()
        
        // MARK: - Bottom Button
        
        searchTicketButton = Button(type: .contained(rounder: 10), title: "Search for Tickets")
        searchTicketButton.titleFont = .systemFont(ofSize: 20, weight: .medium)
        view.addSubview(searchTicketButton)
        searchTicketButton.horizontalAnchors == view.horizontalAnchors + 20
        searchTicketButton.bottomAnchor == view.safeAreaLayoutGuide.bottomAnchor - 10
        searchTicketButton.heightAnchor == 55
        
        searchTicketButton.addTarget(self,action: #selector(searchAction), for: .touchUpInside)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        backButton.isHidden = true
    }
    
    @objc
    func searchAction() {
        let dateOffset: TimeInterval
        switch dateSegmentedControl.selectedIndex {
        case 0:
            dateOffset = 0
        case 1:
            dateOffset = 60 * 60 * 24
        default:
            dateOffset = 60 * 60 * 24 * 2
        }
        
        let selectedDate = Date(timeIntervalSinceNow: dateOffset)
        
        let timeOffset: TimeInterval
        switch timeSegmentedControl.selectedIndex {
        case 0:
            timeOffset = 0
        case 1:
            timeOffset = TimeInterval(60 * 60 * 6)
        default:
            timeOffset = TimeInterval(60 * 60 * 12)
        }
        let trainSelectionVC = TrainSelectionViewController()
        
        let formatter = DateFormatter.longStyle()
        let dayOfWeek = Calendar.current.weekdaySymbols[Calendar.current.component(.weekday, from: selectedDate) - 1]
        let date = formatter.string(from: selectedDate)
        let fromStation = "Tokyo"
        let toStation = "Ōmiya"
        
        trainSelectionVC.headerInformation =
            HeaderInformation(dayOfWeek: dayOfWeek,
                              date: date,
                              fromStation: fromStation,
                              toStation: toStation)
//        trainSelectionVC.dateOffset = dateOffset
//        trainSelectionVC.timeOffset = timeOffset
        navigationController?.pushViewController(trainSelectionVC, animated: true)
    }
    
    @objc
    func reloadTimeSegemtnedControl() {
        
        let timeInterval: TimeInterval
        switch dateSegmentedControl.selectedIndex {
        case 0:
            timeInterval = 0
        case 1:
            timeInterval = 60 * 60 * 24
        default:
            timeInterval = 60 * 60 * 24
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            showAlert(msg: "Oops! Picking a particular date feature doesn't work as this prototype doesn't have it implemented yet.")
        }
        
        let morning = (Date(byHourOf: 6)...Date(byHourOf: 12)).addingTimeInterval(timeInterval)
        let afternoon = (Date(byHourOf: 12)...Date(byHourOf: 18)).addingTimeInterval(timeInterval)
        let evening = (Date(byHourOf: 18)...Date(byHourOf: 24)).addingTimeInterval(timeInterval)
        let now = Date()

        timeSegmentedControl.items = [(title: "Morning",
                                       subtitle: morning.toString(),
                                       isEnabled: now < morning.upperBound),
                                      (title: "Afternoon",
                                       subtitle: afternoon.toString(),
                                       isEnabled: now < afternoon.upperBound),
                                      (title: "Evening",
                                       subtitle: evening.toString(),
                                       isEnabled: now < evening.upperBound)]
    }
}

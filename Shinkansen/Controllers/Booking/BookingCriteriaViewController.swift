//
//  BookingCriteriaViewController.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 25/09/2020.
//

import UIKit
import Anchorage

final class BookingCriteriaViewController: UIViewController {
    
    var headerStackView: UIStackView!
    
    var headlineLabel: Label!
    
    var logoImageView: UIImageView!
    
    var fromStationContainerView: HeadlineWithContainerView!
    
    var fromStationCardControl: StationCardControl!
    
    var destinationStationContainerView: HeadlineWithContainerView!
    
    var destinationStationCardControl: StationCardControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fromStationCardControl = StationCardControl(stationNameJP: "some name", stationName: "Okebabe")
        fromStationContainerView = HeadlineWithContainerView(containingView: fromStationCardControl)
        fromStationCardControl.layer.borderWidth = 1
        fromStationCardControl.layer.borderColor = UIColor.gray.cgColor
        view.addSubview(fromStationContainerView)

        fromStationContainerView.frame = CGRect(x: 100, y: 300, width: 160, height: 100)
        fromStationContainerView.setTitle(title: "Oke")
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // MARK: - Setup Logo
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
        
        
    }
}

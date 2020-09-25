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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
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

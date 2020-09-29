//
//  BookingViewController.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 28/09/2020.
//

import UIKit
import Anchorage

class BookingViewController: UIViewController {
    
    struct HeaderInformation {
        var dayOfWeek: String
        var date: String
        var fromStation: String
        var fromTime: String? = nil
        var toStation: String
        var toTime: String? = nil
        var trainNumber: String? = nil
        var trainName: String? = nil
        var carNumber: String? = nil
        var className: String? = nil
        var seatNumber: String? = nil
        var price: String? = nil
        
        init(dayOfWeek: String, date: String, fromStation: String, toStation: String) {
            self.dayOfWeek = dayOfWeek
            self.date = date
            self.fromStation = fromStation
            self.toStation = toStation
            fromTime = nil
            toTime = nil
            trainNumber = nil
            trainName = nil
            carNumber = nil
            className = nil
            seatNumber = nil
            price = nil
        }
    }
    
    var isPopPerforming = false {
        didSet {
            if oldValue != isPopPerforming && isPopPerforming == true {
                navigationController?.popViewController(animated: true)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
    }
    
    var headerInformation: HeaderInformation?
    
    var dateLabel: Label!
    
    var headerInfoStackView: UIStackView!
    
    var backButton: BackButton!
    
    var headerInfomationView: HeaderRouteInformationView!
    
    var interactivePopOverlayView: InteractivePopOverlayView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - PopOver
        interactivePopOverlayView = InteractivePopOverlayView()
        view.addSubview(interactivePopOverlayView)
        interactivePopOverlayView.edgeAnchors == view.edgeAnchors
        
        // MARK: - Header view
        backButton = BackButton()
        
        headerInfoStackView = UIStackView()
        dateLabel = Label(textAlignment: .center)
        dateLabel.font = .systemFont(ofSize: 18)
        headerInfoStackView.addArrangedSubview(dateLabel)
        
        view.addSubview(headerInfoStackView)
        headerInfoStackView.axis = .vertical
        headerInfoStackView.horizontalAnchors == view.horizontalAnchors + 15
        headerInfoStackView.topAnchor == view.safeAreaLayoutGuide.topAnchor + 12
        
        view.addSubview(backButton)
        backButton.centerYAnchor == dateLabel.centerYAnchor
        backButton.leadingAnchor == dateLabel.leadingAnchor - 10
        
        backButton.tintColor = .primary
        backButton.addTarget(self,
                             action: #selector(backButtonAction),
                             for: .touchUpInside)
        
        // MARK: - Present header infomation
        guard let headerInformation = headerInformation else {
            return
        }
        dateLabel?.text = "\(headerInformation.dayOfWeek), \(headerInformation.date)"
        setupInteraction()
        
//        navigationController?.delegate = self
    }
    
    @objc
    func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupInteraction() {
        let screenEdgePanGesture =
            UIScreenEdgePanGestureRecognizer(target: self,
                                             action: #selector(screenEdgePanGestureDidPan))
        screenEdgePanGesture.edges = .left
        view.addGestureRecognizer(screenEdgePanGesture)
    }
    
    @objc
    func screenEdgePanGestureDidPan(_ sender: UIScreenEdgePanGestureRecognizer) {
        
        guard self != navigationController?.viewControllers[0],
            !isPopPerforming else { return }
        view.bringSubviewToFront(interactivePopOverlayView)
        let state = sender.state
        
        let location = sender.location(in: sender.view!)
        let translate = CGPoint(x: max(sender.translation(in: sender.view!).x, 0),
                                y: location.y)
        let velocity = sender.velocity(in: sender.view!)
        let dismissXTranslateThreshold: CGFloat = view.bounds.width / 5
        let alphaXTranslateThreshold: CGFloat = dismissXTranslateThreshold
        
        interactivePopOverlayView.dismissXTranslateThreshold = dismissXTranslateThreshold
        
        func setAlpha(to alpha: CGFloat) {
            interactivePopOverlayView.overlayAlpha = 1 - alpha
        }
        
        switch state {
        case .changed:
            if !isPopPerforming {
                backButton.transform.tx = min(translate.x / 3, view.bounds.width / 9)
                
                let alpha = max((0.75 *
                    (1 - translate.x / alphaXTranslateThreshold)), 0) +
                    0.25
                
                setAlpha(to: alpha)
                
                interactivePopOverlayView.currentTranslation = translate
            }
            
        case .ended:
            UIView.animate(withDuration: 0.2) {
                [weak self] in
                self?.interactivePopOverlayView.currentTranslation?.x = 0
                setAlpha(to: 1)
                self?.backButton.transform.tx = 0
            }
            
            if velocity.x > 128 {
                isPopPerforming = true
            } else {
                if translate.x > dismissXTranslateThreshold {
                    isPopPerforming = true
                } else {
                }
            }
        default:
            break
        }
    }
    
    func setHeaderInformationValue(_ headerInformation: HeaderInformation?) {
//        guard let headerInformation = headerInformation,
//            let dateLabel = dateLabel,
//            let headerRouteInformationView = headerRouteInformationView else { return }
//
//        dateLabel.text = "\(headerInformation.dayOfWeek), \(headerInformation.date)"
//        headerRouteInformationView.setupValue(fromStation: headerInformation.fromStation,
//                                              fromTime: headerInformation.fromTime,
//                                              toStation: headerInformation.toStation,
//                                              toTime: headerInformation.toTime,
//                                              trainNumber: headerInformation.trainNumber,
//                                              trainName: headerInformation.trainName,
//                                              carNumber: headerInformation.carNumber,
//                                              className: headerInformation.className,
//                                              seatNumber: headerInformation.seatNumber,
//                                              price: headerInformation.price)
    }
}

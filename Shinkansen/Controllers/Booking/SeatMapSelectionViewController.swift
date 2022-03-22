//
//  SeatMapSelectionViewController.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 11/03/2022.
//

import SceneKit
import Anchorage

final class SeatMapSelectionViewController: BookingViewController {
    
    var mainCardView: TouchableControl!
    
    var seatMapSceneView: SeatMapSceneView!
    
    var bottomButton: Button!
    
    var selectedSeatID: Int?
    
    var seatClass: SeatClass?
    
    var sceneDidSetup = false
    
    var seatMap: SeatMap? {
        didSet {
            setupScene()
        }
    }
    
    var seatClassEntity: SeatClassEntity?
    
    private var isTransitionPerforming: Bool = true
    
    private var selectedEntity: ReservableEntity? {
        didSet {
            if headerInfomation?.carNumber != selectedEntity?.carNumber {
                headerInfomation?.carNumber = selectedEntity?.carNumber
                headerInfomationView.descriptionSetView.carNumberSetView.alpha = 0
            }
            
            bottomButton.isEnabled = selectedEntity != nil
            
            let buttonTitle = "Continue with seat \(selectedEntity?.name ?? "*")"
            if bottomButton.titleLabel?.text != buttonTitle {
                bottomButton.setTitle(buttonTitle, for: .normal)
                bottomButton.titleLabel?.alpha = 0
            }
            
            UIView.animate(withDuration: 0.35,
                           animations: {
                            self.headerInfomationView
                                .descriptionSetView
                                .carNumberSetView.alpha = 1
                            self.bottomButton
                                .titleLabel?.alpha = 1
            })
        }
    }
    
    deinit {
        mainCardView.contentView.motionEffects.removeAll()
        seatMapSceneView.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupStaticContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isTransitionPerforming = false
    }
    
    func setupView() {
        mainViewType = .view
        
        mainCardView = TouchableControl()
        contentView.addSubview(mainCardView)
        mainCardView.edgeAnchors == contentView.edgeAnchors + UIEdgeInsets(top: 0, left: 0, bottom: -mainCardView.layer.cornerRadius, right: 0)
        
        seatMapSceneView = SeatMapSceneView()
        seatMapSceneView.seatMapDelegate = self
        mainCardView.contentView.addSubview(seatMapSceneView)
        seatMapSceneView.edgeAnchors == mainCardView.contentView.edgeAnchors
        
        // MARK: - Bottom Button
        
        bottomButton = Button(type: .contained(rounder: 10), title: "Search for Tickets")
        bottomButton.titleFont = .systemFont(ofSize: 20, weight: .medium)
        view.addSubview(bottomButton)
        bottomButton.horizontalAnchors == view.horizontalAnchors + 20
        bottomButton.bottomAnchor == view.safeAreaLayoutGuide.bottomAnchor - 10
        bottomButton.heightAnchor == 55
        
        bottomButton.addTarget(self, action: #selector(mainCallToActionButtonDidTouch(_:)), for: .touchUpInside)
        
        mainCardView.contentView.isUserInteractionEnabled = true
        bottomButton.isEnabled = false
        setupScene()
        seatMapSceneView.setupTheme()
    }
    
    private func setupStaticContent() {
        bottomButton.setTitle("Please Select a Seat", for: .normal)
    }
    
    private func setupScene() {
        guard let seatMap = seatMap,
            let seatMapSceneView = seatMapSceneView,
            let seatClassEntity = seatClassEntity, !sceneDidSetup else {
                return
        }
        
        seatMapSceneView.setupContent(seatMap: seatMap,
                                      currentEntity: seatClassEntity,
                                      fromStation: headerInfomation?.fromStation,
                                      toStation: headerInfomation?.toStation)
        sceneDidSetup = true
        
    }
    
    func verticalRubberBandEffect(byVerticalContentOffset contentOffsetY: CGFloat)  {
        guard contentOffsetY < 0 else {
            mainCardView.transform.ty = 0
            headerInfomationView.verticalRubberBandEffect(byVerticalContentOffset: 0)
            backButton.shapeView.transform.tx = 0
            return
        }
        mainCardView.transform.ty = -contentOffsetY
        
        headerInfomationView.verticalRubberBandEffect(byVerticalContentOffset: contentOffsetY)
    }
    
    @objc func mainCallToActionButtonDidTouch(_ sender: Button) {
        
//        guard let selectedEntity = selectedEntity else {
//            return
//        }
//        isTransitionPerforming = true
//
//        let bookingConfirmationVC = BookingConfirmationViewController()
//        bookingConfirmationVC.seatClassType = seatClassEntity?.seatClass
//        bookingConfirmationVC.headerInformation = headerInformation
//        bookingConfirmationVC.headerInformation?.seatNumber = selectedEntity.name
//        bookingConfirmationVC.headerInformation?.price = seatClass?.price.yen
//        navigationController?.pushViewController(bookingConfirmationVC, animated: true)
    }
}

extension SeatMapSelectionViewController: SeatMapSceneViewDelegate {
    
    func sceneViewDidPanFurtherUpperBoundLimit(by offset: CGPoint) {
        
        if !isPopPerforming {
            
            // Perform interaction
            if !isTransitionPerforming {
                DispatchQueue.main.async { [weak self] in
                    self?.verticalRubberBandEffect(byVerticalContentOffset: offset.y)
                }
            }
        }
    }
    
    func sceneView(sceneView: SeatMapSceneView, didSelected reservableEntity: ReservableEntity) {
        selectedEntity = reservableEntity
    }
}

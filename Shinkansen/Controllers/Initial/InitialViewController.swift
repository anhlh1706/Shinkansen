//
//  InitialViewController.swift
//  shinkansen
//
//  Created by Lê Hoàng Anh on 24/09/2020.
//

import UIKit
import Anchorage
import SafariServices

final class InitialViewController: UIViewController {
    
    // MARK: - UI Elements
    var textScrollView: UIScrollView!
    
    var headlineLabel: Label!
    
    var bodyLabel: Label!
    
    var buttonStackView: UIStackView!
    
    var githubButton: Button!
    
    var designButton: Button!
    
    var startButton: Button!
    
    let headlineText = "Welcome to 3D Seat Booking Prototype!"
    let bodyText = """
Thank you for your interest in this prototype!
This prototype shows the potential usage of 3D visualization capability in interactive booking products.
As this is a prototype, the information showing is mock data which statically stores in the app. That means the information doesn't obtain from or send back to the server, and many functionalities don't fully work. (Particularly, the route picker and date picker in the first view.)
To start the prototype, please tap on "Start this Prototype" button, and to exit the prototype in the middle of the flow, shake your device and the exiting prompt will show up.
This prototype is an open-source project, so feel free to visit the project's GitHub repository to learn more or contribute. "GitHub Repository" button down there will direct you to the repository's site.
If you have any further question or feedback, please contact me by sending feedback via TestFlight feedback or direct message via Twitter @virakri.
"""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .primary
        
        // MARK: - Setup Buttons
        githubButton = Button(type: .text(color: .white), title: "Github Repository")
        githubButton.addTarget(self, action: #selector(openGitHub), for: .touchUpInside)
        
        designButton = Button(type: .text(color: .white), title: "Expore Design System")
        designButton.addTarget(self, action: #selector(openDesignSystem), for: .touchUpInside)
        
        startButton = Button(type: .contained(rounder: 8, color: .white, titleColor: .primary), title: "Start")
        startButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        
        buttonStackView = UIStackView(arrangedSubviews: [githubButton, designButton, startButton])
        buttonStackView.axis = .vertical
        buttonStackView.setCustomSpacing(0, after: githubButton)
        buttonStackView.setCustomSpacing(15, after: designButton)
        
        view.addSubview(buttonStackView)
        buttonStackView.horizontalAnchors == view.horizontalAnchors + 20
        buttonStackView.bottomAnchor == view.safeAreaLayoutGuide.bottomAnchor - 8
        buttonStackView.heightAnchor == 180
        buttonStackView.arrangedSubviews.forEach {
            $0.heightAnchor == 55
            ($0 as? Button)?.spacing = 1.1
            ($0 as? Button)?.titleFont = .systemFont(ofSize: 20, weight: .regular)
        }
        
        // MARK: Setup Labels
        
        textScrollView = UIScrollView()
        textScrollView.showsVerticalScrollIndicator = false
        
        headlineLabel = Label()
        bodyLabel = Label()
        
        headlineLabel.text = headlineText
        bodyLabel.text = bodyText
        
        view.addSubview(textScrollView)
        textScrollView.topAnchor == view.safeAreaLayoutGuide.topAnchor
        textScrollView.horizontalAnchors == view.horizontalAnchors + 20
        textScrollView.bottomAnchor == buttonStackView.topAnchor - 10
        
        textScrollView.addSubview(headlineLabel)
        textScrollView.addSubview(bodyLabel)
        
        headlineLabel.topAnchor == textScrollView.topAnchor + 30
        headlineLabel.widthAnchor == textScrollView.widthAnchor
        headlineLabel.leadingAnchor == textScrollView.leadingAnchor
        headlineLabel.numberOfLines = 0
        headlineLabel.textColor = .background
        headlineLabel.font = .systemFont(ofSize: 38, weight: .light)
        headlineLabel.linedSpacing = 3
        
        bodyLabel.topAnchor == headlineLabel.bottomAnchor + 30
        bodyLabel.widthAnchor == textScrollView.widthAnchor
        bodyLabel.leadingAnchor == textScrollView.leadingAnchor
        bodyLabel.bottomAnchor == textScrollView.bottomAnchor
        bodyLabel.numberOfLines = 0
        bodyLabel.textColor = .background
        bodyLabel.font = .systemFont(ofSize: 22, weight: .light)
        bodyLabel.linedSpacing = 5
    }
    
}

//MARK: - Actions
private extension InitialViewController {
    
    @objc
    func openGitHub() {
        let vc = SFSafariViewController(url: URL(string: "https://github.com/virakri/shinkansen-tickets-booking-prototype")!)
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true, completion: nil)
    }
    
    @objc
    func openDesignSystem() {
        let viewController = DesignSystemViewController()
        present(viewController, animated: true)
    }
    
    @objc
    func start() {
        let presentedViewController = UINavigationController(rootViewController: BookingCriteriaViewController())
        presentedViewController.modalPresentationStyle = .fullScreen
        presentedViewController.transitioningDelegate = self
        
        present(presentedViewController, animated: true, completion: nil)
    }
}

// MARK: - InitialViewControllerTransitioningDelegate
extension InitialViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = InitialViewControllerAnimatedTransition()
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = InitialViewControllerAnimatedTransition()
        return transition
    }
}

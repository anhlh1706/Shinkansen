//
//  TrainSelectionViewController.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 28/09/2020.
//

import UIKit

final class TrainSelectionViewController: BookingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.addTarget(self,
                             action: #selector(backButtonAction),
                             for: .touchUpInside)
    }
    
    @objc
    func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}

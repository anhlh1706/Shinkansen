//
//  ViewController.swift
//  Base
//
//  Created by Hoàng Anh on 29/07/2020.
//  Copyright © 2020 Hoàng Anh. All rights reserved.
//

import UIKit
import Anchorage

extension UIViewController {
    
    func showAlert(title: String? = nil, msg: String?, action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            action?()
        })
        alert.addAction(okAction)
        
        UIImpactFeedbackGenerator().impactOccurred()
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showGetDataErrorAlert() {
        showAlert(msg: "Fetching data failed")
    }
    
    func showNoInternetAlert() {
        showAlert(msg: "You are not connected to the internet")
    }
    
    func showNoDataAlert() {
        showAlert(msg: "No data available.")
    }
}

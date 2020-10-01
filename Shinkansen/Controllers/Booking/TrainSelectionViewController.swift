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
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension TrainSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Oke"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
}

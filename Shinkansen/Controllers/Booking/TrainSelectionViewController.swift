//
//  TrainSelectionViewController.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 28/09/2020.
//

import UIKit
import Anchorage

final class TrainSelectionViewController: BookingViewController {
    
    private var trainSchedules: [TrainSchedule] = []
    
    var selectedIndexPath: IndexPath?
    
    private var loadingView: UIActivityIndicatorView!
    
    var trainCriteria: TrainCriteria? {
        didSet {
            trainSchedules = trainCriteria?.trainSchedules ?? []
            tableView.reloadData()
        }
    }
    
    var dateOffset: TimeInterval = 0
    
    var timeOffset: TimeInterval = 0
    
    var firstAppear = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cell: TrainScheduleTableViewCell.self)
        
        loadingView = UIActivityIndicatorView(style: .large)
        loadingView.startAnimating()
        tableView.isUserInteractionEnabled = false
        tableView.addSubview(loadingView)
        loadingView.sizeAnchors == CGSize(width: 100, height: 40)
        loadingView.centerXAnchor == tableView.centerXAnchor
        loadingView.centerYAnchor == tableView.centerYAnchor - 70
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard firstAppear else { return }
        firstAppear = false
        guard let train = try? Bundle.main.decode(fileName: "TrainCriteria", type: TrainCriteria.self) else {
            return
        }
        trainCriteria = train
        
        tableView.visibleCells.enumerated().forEach { (index, cell) in
            guard let cell = cell as? TrainScheduleTableViewCell else { return }
            cell.preparePropertiesForAnimation()
            cell.transform.ty = 24 * CGFloat(index)
            
            let duration = 0.05 * TimeInterval(index) + 0.5
            var animationStyle = UIViewAnimationStyle.transitionAnimationStyle
            animationStyle.duration = duration
            
            UIView.animate(withStyle: animationStyle, animations: {
                cell.transform.ty = 0
                cell.contentView.alpha = 1
                
                UIView.animate(withDuration: duration, delay: 0.2, options: .curveEaseIn, animations: {
                    cell.setPropertiesToIdentity()
                }, completion: nil)
            })
            
        }
        tableView.isUserInteractionEnabled = true
        loadingView.stopAnimating()
    }
}

extension TrainSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cell: TrainScheduleTableViewCell.self, indexPath: indexPath)
        cell.setup(trainSchedule: trainSchedules[indexPath.row], timeOffset: timeOffset)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainSchedules.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndexPath = indexPath
        let trainSchedule = trainSchedules[indexPath.row]
        let seatClasses = trainSchedule.seatClasses
        let seatClassSelectionVC = SeatClassSelectionViewController()
        seatClassSelectionVC.seatClasses = seatClasses
        seatClassSelectionVC.trainImage = UIImage(named: trainSchedule.trainImageName)
        seatClassSelectionVC.headerInfomation = headerInfomation
        seatClassSelectionVC.headerInfomation?.fromTime = trainSchedule.fromTime.addingTimeInterval(timeOffset).time
        seatClassSelectionVC.headerInfomation?.toTime = trainSchedule.toTime.addingTimeInterval(timeOffset).time
        seatClassSelectionVC.headerInfomation?.trainNumber = trainSchedule.trainNumber
        seatClassSelectionVC.headerInfomation?.trainName = trainSchedule.trainName
        navigationController?.pushViewController(seatClassSelectionVC, animated: true)
    }
}

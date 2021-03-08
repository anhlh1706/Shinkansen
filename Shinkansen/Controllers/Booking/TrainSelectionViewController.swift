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
    
    private var loadingView: UIActivityIndicatorView!
    
    var trainCriteria: TrainCriteria? {
        didSet {
            let now = Date()
            trainSchedules = trainCriteria?.trainSchedules ?? []
//            trainSchedules = (trainCriteria?.trainSchedules ?? []).filter {
//                let component = Calendar.current.dateComponents(in: TimeZone(identifier: "JST")!, from: $0.fromTime)
//                let date = Date(byHourOf: component.hour, minute: component.minute, second: component.second).addingTimeInterval(dateOffset + timeOffset)
//                return now < date
//            }
//            tableView.reloadData()
        }
    }
    
    var dateOffset: TimeInterval = 0
    
    var timeOffset: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cell: TrainScheduleTableViewCell.self)
        
        loadingView = UIActivityIndicatorView(style: .large)
        loadingView.startAnimating()
        tableView.isUserInteractionEnabled = false
        tableView.addSubview(loadingView)
        loadingView.edgeAnchors == tableView.edgeAnchors
        
        Bundle.main.decode(fileName: "TrainCriteria", type: TrainCriteria.self) { [self] result in
            if case .success(let train) = result {
                trainCriteria = train
                
                tableView.visibleCells.enumerated().forEach { (index, cell) in
                    guard let cell = cell as? TrainScheduleTableViewCell else { return }
                    cell.preparePropertiesForAnimation()
                    cell.transform.ty = 24 * CGFloat(index)
                    var animationStyle = UIViewAnimationStyle.transitionAnimationStyle
                    animationStyle.duration = 0.05 * TimeInterval(index) + 0.5
                    UIView.animate(withStyle: animationStyle, animations: {
                        cell.setPropertiesToIdentity()
                        cell.transform.ty = 0
                    })
                }
                tableView.isUserInteractionEnabled = true
                loadingView.stopAnimating()
                
                /// Check if there is no result
                if tableView.visibleCells.count == 0 {
                    let label = Label()
                    label.numberOfLines = 0
                    label.text = "No train scheduled in the time range you selected"
                    label.font = .systemFont(ofSize: 22)
                    label.textColor = .secondaryLabel
                    label.textAlignment = .center
                    tableView.addSubview(label)
                    label.edgeAnchors == tableView.edgeAnchors + 24
                }
            }
        }
    }
    
}

extension TrainSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cell: TrainScheduleTableViewCell.self, indexPath: indexPath)
         let trainSchedule = trainSchedules[indexPath.row]
            
        let granClassObject = trainSchedule.seatClasses.first(where: {
            $0.seatClass == .granClass
        })
        
        let greenObject = trainSchedule.seatClasses.first(where: {
            $0.seatClass == .green
        })
        
        let ordinaryObject = trainSchedule.seatClasses.first(where: {
            $0.seatClass == .ordinary
        })
        
        let availableObjects = [granClassObject, greenObject, ordinaryObject].compactMap({$0})
        let cheapestPrice = availableObjects.sorted(by: { (classL, classR) -> Bool in
            return classL.price < classR.price
        }).first?.price
        
        // MARK: Offset of time is only for a sake of mock data
        let fromTimeString = trainSchedule.fromTime.addingTimeInterval(timeOffset).time
        let toTimeString = trainSchedule.toTime.addingTimeInterval(timeOffset).time
        cell.setupValue(time: "\(fromTimeString) – \(toTimeString)",
            amountOfTime: trainSchedule.toTime.offset(from: trainSchedule.fromTime),
            trainNumber: trainSchedule.trainNumber,
            trainName: trainSchedule.trainName,
            showGranClassIcon: granClassObject != nil,
            isGranClassAvailable: granClassObject?.isAvailable ?? false,
            showGreenIcon: greenObject != nil,
            isGreenAvailable: greenObject?.isAvailable ?? false,
            showOrdinaryIcon: ordinaryObject != nil,
            isOrdinaryAvailable: ordinaryObject?.isAvailable ?? false,
            price: "from \(cheapestPrice?.yen ?? "-")",
            trainImage: UIImage(named: trainSchedule.trainImageName))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainSchedules.count
    }
}

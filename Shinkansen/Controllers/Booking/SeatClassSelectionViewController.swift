//
//  SeatClassSelectionViewController.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 11/03/2022.
//

import UIKit
import Anchorage

final class SeatClassSelectionViewController: BookingViewController {
    
    var trainImage: UIImage?
    
    var trainImageView: UIImageView!
    
    var selectedIndexPath: IndexPath?
    
    var seatClasses: [SeatClass] = []
    
    var seatMap: SeatMap?
    
    weak var seatMapSelectionVC: SeatMapSelectionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupStaticContent()
        obtainData()
    }
    
    func setupView() {
        mainViewType = .tableView
        
        headerInfomationView.descriptionSetView.addArrangedSubview(UIView())
        
        trainImageView = UIImageView()
        
        headerInfomationView.descriptionSetView.addSubview(trainImageView)
        
        trainImageView.leadingAnchor >= headerInfomationView.descriptionSetView.trainNumberSetView.trailingAnchor + 48
        
        trainImageView.trailingAnchor == headerInfomationView.trailingAnchor ~ .low
        
        trainImageView.topAnchor == headerInfomationView.stationPairView.bottomAnchor + 12
        
        headerInfomationView.descriptionSetView.bottomAnchor == trainImageView.bottomAnchor
        
        trainImageView.widthAnchor == trainImageView.heightAnchor * 6
        
        trainImageView
            .setContentCompressionResistancePriority(
                .init(rawValue: 249), for: .vertical)
        trainImageView
            .setContentCompressionResistancePriority(
                .init(rawValue: 249), for: .horizontal)
        
    }
    
    func obtainData() {
        SeatMap.fetchData { [weak self] result in
            if case .success(let seatMap) = result {
                DispatchQueue.main.async {
                    self?.seatMap = seatMap
                    if let vc = self?.seatMapSelectionVC,
                        let indexPath = self?.tableView?.indexPathForSelectedRow,
                        let seatClass = self?.seatClasses[indexPath.row],
                        let selectedEntity = seatMap.seatClassEntities.first(where: {
                            $0.seatClass == seatClass.seatClass
                        }){
                        vc.seatClass = seatClass
                        vc.seatClassEntity = selectedEntity
                        vc.seatMap = seatMap
                    }
                }
            }
        }
        
        
        let decoder = JSONDecoder()
        if let data = NSDataAsset(name: "ModelData")?.data,
            let modelData = try? decoder.decode([ModelData].self, from: data) {
                NodeFactory.shared =
                    NodeFactory(modelData: modelData)
        } else {
            fatalError("There is some errors of trying to phrase JSON, so please check ModelData.json in Assets.xcassets")
        }
    }

    func setupStaticContent() {
        trainImageView.image = trainImage
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        tableView.register(SeatClassTableViewCell.self, forCellReuseIdentifier: "SeatClassTableViewCell")
    }
}

extension SeatClassSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seatClasses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeatClassTableViewCell",
                                                       for: indexPath) as? SeatClassTableViewCell else { return UITableViewCell() }
        let seatClass = seatClasses[indexPath.row]
        
        cell.setupValue(seatClassType: seatClass.seatClass,
                        seatClassName: seatClass.name,
                        price: seatClass.price.yen,
                        description: seatClass.description,
                        seatImage: seatClass.seatClass.image())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard !(navigationController?.viewControllers.last is SeatMapSelectionViewController?) else {
            return print("Seat map is loading please wait")
        }

        //
        selectedIndexPath = indexPath

        let seatClass = seatClasses[indexPath.row]

        let selectedEntity = seatMap?.seatClassEntities.first(where: {
            $0.seatClass == seatClass.seatClass
        })

        let seatMapSelectionVC = SeatMapSelectionViewController()
        seatMapSelectionVC.seatClass = seatClass
        seatMapSelectionVC.seatClassEntity = selectedEntity
        seatMapSelectionVC.seatMap = seatMap
        seatMapSelectionVC.headerInfomation = headerInfomation
        seatMapSelectionVC.headerInfomation?.carNumber = selectedEntity?.carNumber
        seatMapSelectionVC.headerInfomation?.className = seatClass.name
        seatMapSelectionVC.headerInfomation?.price = seatClass.price.yen
        if seatMap == nil {
            self.seatMapSelectionVC = seatMapSelectionVC
        }
        navigationController?.pushViewController(seatMapSelectionVC, animated: true)
    }
    
}

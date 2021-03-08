//
//  TrainCriteria.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 05/03/2021.
//

import Foundation

struct TrainCriteria: Codable {
    let id: Int
    let fromStationJPName: String
    let fromStationName: String
    let toStationJPName: String
    let toStationName: String
    let date: Date
    let trainSchedules: [TrainSchedule]
}

struct TrainSchedule: Codable {
    let id: Int
    let fromTime: Date
    let toTime: Date
    let trainNumber: String
    let trainName: String
    let trainImageName: String
    let seatClasses: [SeatClass]
}

struct SeatClass: Codable {
    let id: Int
    let name: String
    let description: String
    let seatClass: SeatClassType
    let price: Float
    let isAvailable: Bool
}

enum SeatClassType: String, Codable {
    case granClass
    case green
    case ordinary
}

extension SeatClassType {
    var name: String {
        switch self {
        case .granClass:
            return "Gran Class"
        case .green:
            return "Green Class"
        case .ordinary:
            return "Ordinary Class"
        }
    }
    
    var completeNodeName: String {
        switch self {
        case .granClass:
            return "_e7_gran_seat_complete"
        case .green:
            return "_e7_green_seat_complete"
        case .ordinary:
            return "_e7_ordinary_seat_complete"
        }
    }
}

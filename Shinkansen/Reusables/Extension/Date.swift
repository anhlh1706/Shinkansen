//
//  Date.swift
//  Base
//
//  Created by Hoàng Anh on 30/07/2020.
//  Copyright © 2020 Hoàng Anh. All rights reserved.
//

import Foundation

extension Date {
    
    init(byHourOf hour: Int? = 0, minute: Int? = 0, second: Int? = 0) {
        var dateComponents = Calendar.current.dateComponents(in: .current, from: Date())
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        self = Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    
    var timeHour: String {
        
        guard let checkingFormatter: String =
            DateFormatter
                .dateFormat(fromTemplate: "j",
                            options:0,
                            locale:NSLocale.current)
            else { return "" }
        
        let dateFormatter = DateFormatter()
        if checkingFormatter.contains("a") {
            dateFormatter.dateFormat = "ha"
            return dateFormatter.string(from: self)
        } else {
            dateFormatter.dateFormat = "H:mm"
            return dateFormatter.string(from: self)
        }
    }
}

extension ClosedRange where Bound == Date {
    func toString() -> String {
        return "\(lowerBound.timeHour) - \(upperBound.timeHour)"
    }
    
    func addingTimeInterval(_ timeInterval: TimeInterval) -> ClosedRange {
        return lowerBound.addingTimeInterval(timeInterval)...upperBound.addingTimeInterval(timeInterval)
    }
}

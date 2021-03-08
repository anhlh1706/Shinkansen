//
//  Date.swift
//  Base
//
//  Created by Hoàng Anh on 30/07/2020.
//  Copyright © 2020 Hoàng Anh. All rights reserved.
//

import Foundation

class TimeFormatter: DateFormatter {
    override init() {
        super.init()
        timeStyle = .short
        timeZone = Date.JPCalendar.timeZone
        calendar = Date.JPCalendar
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class YenFormatter: NumberFormatter {
    override init() {
        super.init()
        usesGroupingSeparator = true
        numberStyle = .currency
        locale = Locale(identifier: "ja_JP")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension Date {
    
    static let JPCalendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ja_JP")
        calendar.timeZone = TimeZone(identifier: "JST")!
        return calendar
    }()
    
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
    
    var time: String {
        return TimeFormatter().string(from: self)
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date)) year"   }
        if months(from: date)  > 0 { return "\(months(from: date)) month"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date)) week"   }
        if days(from: date)    > 0 { return "\(days(from: date)) day"    }
        if hours(from: date)   > 0 { return "\(hours(from: date)) hr"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date)) min" }
        return ""
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

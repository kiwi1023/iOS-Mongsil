//
//  Date + Extension.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/17.
//

import Foundation

extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
    var dayInfo: DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day], from: self)
    }
    
    var convertKorean: String {
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "a hh시 mm분"
        myDateFormatter.locale = Locale(identifier:"ko_KR")
        
        return myDateFormatter.string(from: self)
    }
    
    func convertCurrenDate() -> Date {
        let date = Date()
        let year = Calendar.current.dateComponents([.year], from: self)
        let month = Calendar.current.dateComponents([.month], from: self)
        let day = Calendar.current.dateComponents([.day], from: self)
        let hour = Calendar.current.dateComponents([.hour], from: date)
        let minute = Calendar.current.dateComponents([.minute], from: date)
        let second = Calendar.current.dateComponents([.second], from: date)
        let dateComponents = DateComponents(timeZone: nil ,
                                            year: year.year,
                                            month: month.month,
                                            day: day.day,
                                            hour: hour.hour,
                                            minute: minute.minute,
                                            second: second.second)
        
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
}

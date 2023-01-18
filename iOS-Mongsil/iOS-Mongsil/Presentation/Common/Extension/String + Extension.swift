//
//  String + Extension.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/17.
//

import Foundation

extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter
    }()

    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}

//
//  DateConverter.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 11.08.2024.
//

import Foundation

class DateConverter {
    let formatter: DateFormatter
    
    init(format: String) {
        formatter = DateFormatter()
        formatter.dateFormat = format
    }
    
    func toDate(from string: String) -> Date? {
        return formatter.date(from: string)
    }
    
    func toString(from date: Date) -> String {
        return formatter.string(from: date)
    }
}

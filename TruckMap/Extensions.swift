//
//  Extensions.swift
//  TruckMap
//
//  Created by Mac on 07/04/22.
//

import Foundation
import MapKit

// Date extension
extension Date {
    
    static func getStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    
}

extension Int {
    
    static func getDateFromString() -> Date? {
        let formatter = ISO8601DateFormatter()
        let dateString = "\(self)"
        formatter.formatOptions = [.withInternetDateTime,
                                   .withDashSeparatorInDate,
                                   .withFullDate,
                                   .withFractionalSeconds,
                                   .withColonSeparatorInTimeZone]
        guard let date = formatter.date(from: dateString) else {
            return nil
        }
        return date
    }
}

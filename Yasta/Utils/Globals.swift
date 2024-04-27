//
//  Globals.swift
//  Yasta
//
//  Created by Antonio Cranga on 16.04.2024.
//

import Foundation

enum Globals {
    static func formattedInterval(startDate: Date?, endDate: Date?) -> String {
        guard let startDate = startDate, let endDate = endDate else {
            return ""
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"

        let startDateComponents = Calendar.current.dateComponents([.day, .year, .month], from: startDate)
        let endDateComponents = Calendar.current.dateComponents([.day, .year, .month], from: endDate)

        let formattedStart = dateFormatter.string(from: startDate)
        let formattedEnd = dateFormatter.string(from: endDate)

        let startDateString = "\(startDateComponents.day ?? 0)"
        let endDateString = formattedEnd

        return "\(startDateString)-\(endDateString) \(endDateComponents.year ?? 0)"
    }
}

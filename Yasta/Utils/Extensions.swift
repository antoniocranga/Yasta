//
//  Extensions.swift
//  Yasta
//
//  Created by Antonio Cranga on 06.04.2024.
//

import Foundation

extension Int {
    func ratio(by: Int) -> Double {
        return Double(by) / Double(self)
    }
    
    func normalizedRatio(by: Int, minRatio: Double, maxRatio: Double) -> Double {
        var ratio = self.ratio(by: by)
        if ratio < 0.0 {
            ratio = 0.0
        } else if ratio > 1.0 {
            ratio = 1.0
        }
        return minRatio + (maxRatio - minRatio) * ratio
    }
    
    func compareInPercentage(with: Int) -> Double {
        guard with != 0 else {
            fatalError("Division by 0")
        }
        
        let difference = self - with
        var percentage = (Double(difference) / Double(with)) * 100.0
        if self < with {
            percentage = -percentage
        }
        return percentage
    }
}

extension Date {
    var short: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE d"
        return dateFormatter.string(from: self)
    }
    
    var medium: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE d"
        return dateFormatter.string(from: self)
    }
    
    var large: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        return dateFormatter.string(from: self)
    }
    
    func large(unit: Calendar.Component) -> String {
        let dateFormatter = DateFormatter()
        switch unit {
        case .hour:
            dateFormatter.dateFormat = "dd MM, yyyy HH:mm"
        default:
            dateFormatter.dateFormat = "dd MM, yyyy"
        }
        return dateFormatter.string(from: self)
    }
    
    static var startOfTheWeek: Date? {
        Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date.now))
    }
    
    static var endOfTheWeek: Date? {
        if let endOfTheWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: startOfTheWeek!) {
            return Calendar.current.date(byAdding: .day, value: -1, to: endOfTheWeek)
        }
        return nil
    }
    
    static var startOfTheMonth: Date? {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date.now))
    }
    
    static var endOfTheMonth: Date? {
        Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfTheMonth!)
    }
}

extension Double {
    var twoDecimals: String {
        String(format: "%.2f", self)
    }
}

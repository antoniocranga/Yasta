//
//  Interval.swift
//  Yasta
//
//  Created by Antonio Cranga on 16.04.2024.
//

import Foundation

enum Interval: String, CaseIterable, Identifiable {
    case today = "Today", week = "Week", month = "Month"
}

extension Interval {
    var id: Self { self }
    
    var toInteger: Int {
        switch self {
        case .today: return 1
        case .week: return 7
        case .month: return 30
        }
    }
    
    var unit: Calendar.Component {
        switch self {
        case .today: return .hour
        case .week: return .day
        case .month: return .day
        }
    }
}

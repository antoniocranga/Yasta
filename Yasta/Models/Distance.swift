//
//  Distance.swift
//  Yasta
//
//  Created by Antonio Cranga on 11.04.2024.
//

import Foundation

struct Distance: Metric, Hashable {
    let id: UUID
    let workoutType: WorkoutType?
    let date: Date
    let type: Measure = .distance
    let measure: Measurement<UnitLength>

    var value: Double {
        measure.converted(to: .meters).value
    }
}

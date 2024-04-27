//
//  Step.swift
//  Yasta
//
//  Created by Antonio Cranga on 11.04.2024.
//

import Foundation

struct Step: Metric, Hashable {
    let id: UUID
    let workoutType: WorkoutType?
    let date: Date
    let type: Measure = .steps
    let count: Int

    var value: Double {
        Double(count)
    }
}

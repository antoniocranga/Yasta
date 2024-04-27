//
//  Calorie.swift
//  Yasta
//
//  Created by Antonio Cranga on 11.04.2024.
//

import Foundation

struct Calorie: Metric, Hashable {
    let id: UUID
    let workoutType: WorkoutType?
    let date: Date
    let type: Measure = .calories
    let count: Int

    var value: Double {
        Double(count)
    }
}

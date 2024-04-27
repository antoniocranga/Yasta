//
//  Workout.swift
//  Yasta
//
//  Created by Antonio Cranga on 11.04.2024.
//

import CoreLocation
import Foundation

struct Workout: Identifiable, Hashable {
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        lhs.id == rhs.id
    }

    let id: UUID
    let date: Date
    let type: WorkoutType?
    let route: [CLLocation]?
    let duration: Double?
    let distance: Distance? // total distance
    let speed: Speed? // average speed
    let distances: [Measurement<UnitLength>]?
    let speeds: [Measurement<UnitSpeed>]?
    let altitudes: [Measurement<UnitLength>]?
    let steps: Step?
    let calories: Calorie?
}

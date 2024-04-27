//
//  Measure.swift
//  Yasta
//
//  Created by Antonio Cranga on 11.04.2024.
//

import Foundation
import HealthKit

enum Measure: Int16, CaseIterable {
    case distance
    case speed
    case steps
    case calories
}

extension Measure {
    var name: String {
        switch self {
        case .distance: return "Distance"
        case .speed: return "Speed"
        case .steps: return "Steps"
        case .calories: return "Calories"
        }
    }

    var unit: HKUnit {
        switch self {
        case .distance: return .meter()
        case .speed: return .meter().unitDivided(by: .second())
        case .steps: return .count()
        case .calories: return .largeCalorie()
        }
    }

    var identifier: HKQuantityTypeIdentifier {
        switch self {
        case .distance: return .distanceWalkingRunning
        case .speed: return .walkingSpeed
        case .steps: return .stepCount
        case .calories: return .activeEnergyBurned
        }
    }

    var icon: String {
        switch self {
        case .distance: return "road.lanes"
        case .speed: return "speedometer"
        case .steps: return "shoeprints.fill"
        case .calories: return "scalemass"
        }
    }
}

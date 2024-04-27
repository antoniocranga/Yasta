//
//  Metric.swift
//  Yasta
//
//  Created by Antonio Cranga on 11.04.2024.
//

import Foundation

protocol Metric: Identifiable {
    var id: UUID { get }
    var workoutType: WorkoutType? { get }
    var date: Date { get }
    var type: Measure { get }
    var value: Double { get }
}

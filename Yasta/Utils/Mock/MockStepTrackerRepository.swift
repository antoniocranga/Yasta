//
//  MockStepTrackerRepository.swift
//  YastaTests
//
//  Created by Antonio Cranga on 06.04.2024.
//

import Foundation

class MockStepTrackerRepository: StepTracker {
    func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
        completion(true, nil)
    }

    var isHealthKitAvailable: Bool = true

    func query(forMeasure measure: Measure, forPast days: Int, completion: @escaping ([any Metric]?, Error?) -> Void) {
        var randomData = [any Metric]()

        for i in 0 ..< days {
            let randomDate = Date().addingTimeInterval(TimeInterval(-i * 86400))
            switch measure {
            case .distance:
                randomData.append(Distance(id: UUID(), workoutType: .none, date: randomDate, measure: Measurement(value: Double(i) * 100.0, unit: .meters)))
            case .calories:
                randomData.append(Calorie(id: UUID(), workoutType: .none, date: randomDate, count: i * 100))
            case .speed:
                randomData.append(Speed(id: UUID(), workoutType: .none, date: randomDate, measure: Measurement(value: Double(i) * 100.0, unit: .metersPerSecond)))
            case .steps:
                randomData.append(Step(id: UUID(), workoutType: .none, date: randomDate, count: i * 100))
            }
        }

        completion(
            randomData.sorted {
                $0.date < $1.date
            }, nil
        )
    }

    func query(forMeasure: Measure, startDate: Date, endDate: Date, completion: @escaping ([any Metric]?, Error?) -> Void) {
        let days = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day!

        query(forMeasure: forMeasure, forPast: days) {
            result, error in
            completion(result, error)
        }
    }
}

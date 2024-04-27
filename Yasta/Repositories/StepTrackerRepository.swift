//
//  StepTrackerRepository.swift
//  Yasta
//
//  Created by Antonio Cranga on 06.04.2024.
//

import Foundation
import HealthKitUI
import OSLog

struct StepTrackerRepository: StepTracker {
    static let preview = MockStepTrackerRepository()
    let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: StepTrackerRepository.self)
    )
    
    let healthStore = HKHealthStore()
    
    var isHealthKitAvailable: Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
        guard let stepType = HKObjectType.quantityType(forIdentifier: Measure.steps.identifier), let calorieType = HKObjectType.quantityType(forIdentifier: Measure.calories.identifier), let distanceType = HKObjectType.quantityType(forIdentifier: Measure.distance.identifier), let speedType = HKObjectType.quantityType(forIdentifier: Measure.speed.identifier) else {
            completion(false, HealthKitError.unavailable)
            return
        }
        
        healthStore.requestAuthorization(toShare: [], read: Set([stepType, calorieType, distanceType, speedType])) { success, error in
            completion(success, error)
        }
    }
    
    func query(forMeasure measure: Measure, forPast days: Int, completion: @escaping ([any Metric]?, Error?) -> Void) {
        let endDate = Date.now
        let daysAgo = Calendar.current.date(byAdding: DateComponents(day: -days + 1), to: endDate)!
        let startDate = Calendar.current.startOfDay(for: daysAgo)
        
        query(forMeasure: measure, startDate: startDate, endDate: endDate) {
            result, error in
            completion(result, error)
        }
    }
    
    func query(forMeasure measure: Measure, startDate: Date, endDate: Date, completion: @escaping ([any Metric]?, Error?) -> Void) {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: measure.identifier) else {
            completion(nil, HealthKitError.unavailable)
            return
        }
        var metrics = [any Metric]()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        var query: HKStatisticsCollectionQuery
        var intervalComponents = DateComponents(day: 1)
        let difference = Calendar.current.dateComponents([.year, .month, .day], from: startDate, to: endDate)
        
        guard let year = difference.year, let month = difference.month, let day = difference.day else {
            completion(nil, HealthKitError.unavailable)
            return
        }

        if year >= 1 || month >= 5 {
            intervalComponents = DateComponents(month: 1)
        } else if day < 1 {
            intervalComponents = DateComponents(hour: 1)
        }
        
        switch measure {
        case .speed:
            query = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: [.discreteAverage], anchorDate: startDate, intervalComponents: intervalComponents)
        case .calories, .steps, .distance:
            query = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: intervalComponents)
        }
        
        query.initialResultsHandler = {
            _, results, _ in
            guard let results = results else {
                return
            }
            
            results.enumerateStatistics(from: startDate, to: endDate) {
                statistics, _ in
                if let sumQuantity = statistics.sumQuantity() {
                    let date = statistics.startDate
                    switch measure {
                    case .distance:
                        metrics.append(Distance(id: UUID(), workoutType: .none, date: date, measure: Measurement(value: sumQuantity.doubleValue(for: measure.unit), unit: .meters)))
                    case .calories:
                        metrics.append(Calorie(id: UUID(), workoutType: .none, date: date, count: Int(sumQuantity.doubleValue(for: measure.unit))))
                    case .steps:
                        metrics.append(Step(id: UUID(), workoutType: .none, date: date, count: Int(sumQuantity.doubleValue(for: measure.unit))))
                    default:
                        break
                    }
                }
                if let averageQuantity = statistics.averageQuantity() {
                    let date = statistics.startDate
                    switch measure {
                    case .speed:
                        metrics.append(Speed(id: UUID(), workoutType: .none, date: date, measure: Measurement(value: averageQuantity.doubleValue(for: measure.unit), unit: .metersPerSecond)))
                    default:
                        break
                    }
                }
            }
            completion(
                metrics.sorted {
                    $0.date < $1.date
                }, nil
            )
        }
        healthStore.execute(query)
    }
}

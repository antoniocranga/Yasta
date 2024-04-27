//
//  StepTrackerViewModel.swift
//  Yasta
//
//  Created by Antonio Cranga on 06.04.2024.
//

import Foundation
import OSLog

@Observable
class StepTrackerViewModel {
    static let preview = StepTrackerViewModel(stepTracker: StepTrackerRepository.preview)

    private var localStorage = LocalStorage()
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: StepTrackerViewModel.self)
    )
    private let stepTracker: StepTracker
    private var isHealthKitAuthorized: Bool = false

    private(set) var calories = [Calorie]()
    private(set) var distances = [Distance]()
    private(set) var speeds = [Speed]()
    private(set) var steps = [Step]()

    init(stepTracker: StepTracker = StepTrackerRepository()) {
        self.stepTracker = stepTracker
        checkHealthKitAuthorization()
    }

    private func checkHealthKitAuthorization() {
        guard stepTracker.isHealthKitAvailable else {
            // HealthKit is not available on this device
            return
        }

        stepTracker.authorizeHealthKit { [weak self] success, _ in
            DispatchQueue.main.async {
                self?.isHealthKitAuthorized = success
                if success {
                    self?.fetchMetrics()
                } else {
                    self?.logger.error("HealthKit Authorization failed")
                }
            }
        }
    }

    func fetchMetrics() {
        if !isHealthKitAuthorized { return }

        fetchCalories()
        fetchDistances()
        fetchSpeeds()
        fetchSteps()
    }

    private func fetch(forMeasure measure: Measure, forPast days: Int = 7, completion: @escaping ([any Metric]?, Error?) -> Void) {
        if !isHealthKitAuthorized { return }

        stepTracker.query(forMeasure: measure, forPast: days) {
            metrics, error in
            completion(metrics, error)
        }
    }

    private func fetch(forMeasure measure: Measure, startDate: Date, endDate: Date, completion: @escaping ([any Metric]?, Error?) -> Void) {
        if !isHealthKitAuthorized {
            return
        }

        stepTracker.query(forMeasure: measure, startDate: startDate, endDate: endDate) {
            metrics, error in
            completion(metrics, error)
        }
    }
}

// MARK: Steps methods

extension StepTrackerViewModel {
    func fetchSteps(forPast days: Int = 7) {
        fetch(forMeasure: .steps, forPast: days) {
            steps, _ in
            guard let steps = steps else {
                return
            }
            self.steps = steps as! [Step]
        }
    }

    func fetchSteps(startDate: Date, endDate: Date) {
        fetch(forMeasure: .steps, startDate: startDate, endDate: endDate) {
            steps, _ in
            guard let steps = steps else {
                return
            }
            self.steps = steps as! [Step]
        }
    }

    var averageSteps: Int {
        if steps.count == 0 {
            return 0
        }
        return steps.map {
            $0.count
        }.reduce(0,+) / steps.count
    }
}

// MARK: Calories methods

extension StepTrackerViewModel {
    func fetchCalories(forPast days: Int = 7) {
        fetch(forMeasure: .calories, forPast: days) {
            calories, _ in
            guard let calories = calories else {
                return
            }
            self.calories = calories as! [Calorie]
        }
    }

    func fetchCalories(startDate: Date, endDate: Date) {
        fetch(forMeasure: .calories, startDate: startDate, endDate: endDate) {
            calories, _ in
            guard let calories = calories else {
                return
            }
            self.calories = calories as! [Calorie]
        }
    }
    
    var averageCalories: Int {
        if calories.count == 0 {
            return 0
        }
        return calories.map {
            $0.count
        }.reduce(0,+) / calories.count
    }
}

// MARK: Speed methods

extension StepTrackerViewModel {
    func fetchSpeeds(forPast days: Int = 7) {
        fetch(forMeasure: .speed, forPast: days) {
            speeds, _ in
            guard let speeds = speeds else {
                return
            }
            self.speeds = speeds as! [Speed]
        }
    }

    func fetchSpeeds(startDate: Date, endDate: Date) {
        fetch(forMeasure: .speed, startDate: startDate, endDate: endDate) {
            speeds, _ in
            guard let speeds = speeds else {
                return
            }
            self.speeds = speeds as! [Speed]
        }
    }
    
    var averageSpeed: Double {
        if speeds.count == 0 {
            return 0
        }
        return speeds.map {
            $0.value
        }.reduce(0,+) / Double(speeds.count)
    }
}

// MARK: Distance methods

extension StepTrackerViewModel {
    func fetchDistances(forPast days: Int = 7) {
        fetch(forMeasure: .distance, forPast: days) {
            distances, _ in
            guard let distances = distances else {
                return
            }
            self.distances = distances as! [Distance]
        }
    }

    func fetchDistances(startDate: Date, endDate: Date) {
        fetch(forMeasure: .distance, startDate: startDate, endDate: endDate) {
            distances, _ in
            guard let distances = distances else {
                return
            }
            self.distances = distances as! [Distance]
        }
    }
    
    var averageDistance: Double {
        if distances.count == 0 {
            return 0
        }
        return distances.map {
            $0.value
        }.reduce(0,+) / Double(distances.count)
    }
}

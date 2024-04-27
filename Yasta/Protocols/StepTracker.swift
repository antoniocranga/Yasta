//
//  StepTracker.swift
//  Yasta
//
//  Created by Antonio Cranga on 11.04.2024.
//

import Foundation

protocol StepTracker {
    func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void)
    //    func queryStepsCount(forPast days: Int, completion: @escaping ([Activity]?, Error?) -> Void)
    var isHealthKitAvailable: Bool { get }
    func query(forMeasure: Measure, forPast days: Int, completion: @escaping ([any Metric]?, Error?) -> Void)
    func query(forMeasure: Measure, startDate: Date, endDate: Date, completion: @escaping ([any Metric]?, Error?) -> Void)
}

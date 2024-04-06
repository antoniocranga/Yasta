//
//  StepTrackerViewModel.swift
//  Yasta
//
//  Created by Antonio Cranga on 06.04.2024.
//

import Foundation
import OSLog

class StepTrackerViewModel: ObservableObject {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: StepTrackerViewModel.self))
    var steps: Double = 0
    var isHealthKitAuthorized: Bool = false
    
    var stepTrackerRepository = StepTrackerRepository()
    
    init(){
        checkHealthKitAuthorization()
    }
    
    private func checkHealthKitAuthorization() {
        guard stepTrackerRepository.isHealthKitAvailable else {
            // HealthKit is not available on this device
            return
        }
        
        stepTrackerRepository.authorizeHealthKit { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isHealthKitAuthorized = success
                if success {
                    self?.fetchSteps()
                } else {
                    print("HealthKit Authorization failed")
                }
            }
        }
    }
    
    func fetchSteps() {
        stepTrackerRepository.queryStepCount{
            [weak self] steps, error in
            DispatchQueue.main.async {
                if let steps = steps {
                    self?.steps = steps
                } else {
                    self?.logger.debug("Error fatching step count")
                }
            }
        }
    }
}

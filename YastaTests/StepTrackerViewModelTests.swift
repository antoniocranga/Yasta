//
//  StepTrackerViewModelTests.swift
//  YastaTests
//
//  Created by Antonio Cranga on 06.04.2024.
//

import XCTest
@testable import Yasta

class StepTrackerViewModelTests: XCTestCase {
    let viewModel = StepTrackerViewModel(stepTracker: MockStepTrackerRepository())
    
    func test_fetch_steps() {
        self.viewModel.fetchSteps(forPast: 7)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.steps.last?.count, 0)
        }
    }
    
    func test_fetch_calories() {
        viewModel.fetchCalories(forPast: 7)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.calories.last?.count, 0)
        }
    }
    
    func test_fetch_speeds() {
        viewModel.fetchSpeeds(forPast: 7)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.speeds.last?.value, 0.0)
        }
    }
    
    func test_fetch_distances() {
        viewModel.fetchDistances(forPast: 7)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.distances.last?.value, 0.0)
        }
    }
}

//
//  StepTrackerView.swift
//  Yasta
//
//  Created by Antonio Cranga on 06.04.2024.
//

import SwiftUI
import Charts
struct StepTrackerView: View {
    @StateObject private var viewModel = StepTrackerViewModel()
    
    var body: some View {
        VStack{
            Text("Steps taken today \(viewModel.steps, specifier:  "%.0f")").font(.title)
            Chart {
                BarMark (x: .value("Date", "Today"), y: .value("Steps", viewModel.steps),width: 160)
            }
        }.frame(height: 400).onAppear {
            viewModel.fetchSteps()
        }
    }
}

#Preview {
    StepTrackerView()
}

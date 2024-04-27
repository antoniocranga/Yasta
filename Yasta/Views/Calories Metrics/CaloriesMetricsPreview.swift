//
//  CaloriesMetricsPreview.swift
//  Yasta
//
//  Created by Antonio Cranga on 14.04.2024.
//

import Charts
import SwiftUI

struct CaloriesMetricsPreview: View {
    @State var viewModel: StepTrackerViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Today you have burnt")
                Text("\(viewModel.calories.last?.count ?? 0) calories").bold().foregroundStyle(.orange)
            }
            Chart(viewModel.calories) {
                BarMark(x: .value("Day", $0.date.short), y: .value("Calories", $0.count))
                    .foregroundStyle(.orange)
            }
            .chartYAxis(.hidden)
            .frame(height: 50)
        }
    }
}

#Preview {
    CaloriesMetricsPreview(viewModel: .preview)
}

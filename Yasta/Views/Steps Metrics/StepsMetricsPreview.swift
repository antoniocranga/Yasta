//
//  StepsMetricsPreview.swift
//  Yasta
//
//  Created by Antonio Cranga on 14.04.2024.
//

import Charts
import SwiftUI

struct StepsMetricsPreview: View {
    @State var viewModel: StepTrackerViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Today you have made")
                Text("\(viewModel.steps.last?.count ?? 0) steps").bold().foregroundStyle(.blue)
            }
            Chart(viewModel.steps) {
                BarMark(x: .value("Day", $0.date.short), y: .value("Steps", $0.count))
                    .foregroundStyle(.blue)
            }
            .chartYAxis(.hidden)
            .frame(height: 50)
        }
    }
}

#Preview {
    StepsMetricsPreview(viewModel: .preview)
}

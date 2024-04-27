//
//  SpeedMetricsPreview.swift
//  Yasta
//
//  Created by Antonio Cranga on 14.04.2024.
//

import Charts
import SwiftUI

struct SpeedMetricsPreview: View {
    @State var viewModel: StepTrackerViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Average speed for today")
                Text("\(viewModel.averageSpeed.twoDecimals) m/s").bold().foregroundStyle(.green)
            }
            Chart(viewModel.speeds) {
                LineMark(x: .value("Day", $0.date.short), y: .value("m/s", $0.value))
                    .foregroundStyle(.green)
                    .interpolationMethod(.catmullRom)
                    .lineStyle(.init(lineWidth: 2))
                    .symbol {
                        Circle()
                            .fill(.green)
                            .frame(width: 12, height: 12)
                    }
            }
            .chartYAxis(.hidden)
            .frame(height: 50)
        }
    }
}

#Preview {
    SpeedMetricsPreview(viewModel: .preview)
}

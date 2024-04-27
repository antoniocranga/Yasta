//
//  DistanceMetricsPreview.swift
//  Yasta
//
//  Created by Antonio Cranga on 14.04.2024.
//

import Charts
import SwiftUI

struct DistanceMetricsPreview: View {
    @State var viewModel: StepTrackerViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Average distance for today")
                Text("\(viewModel.averageDistance.twoDecimals) m").bold().foregroundStyle(.red)
            }
            Chart(viewModel.distances) {
                LineMark(x: .value("Day", $0.date.short), y: .value("m", $0.value))
                    .foregroundStyle(.red)
                    .interpolationMethod(.catmullRom)
                    .lineStyle(.init(lineWidth: 2))
                    .symbol {
                        Circle()
                            .fill(.red)
                            .frame(width: 12, height: 12)
                    }
            }
            .chartYAxis(.hidden)
            .frame(height: 50)
        }
    }
}

#Preview {
    DistanceMetricsPreview(viewModel: .preview)
}

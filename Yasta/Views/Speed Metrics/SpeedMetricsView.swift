//
//  SpeedMetricsView.swift
//  Yasta
//
//  Created by Antonio Cranga on 14.04.2024.
//

import Charts
import SwiftUI

struct SpeedMetricsView: View {
    @State var viewModel: StepTrackerViewModel

    @State private var selectedInterval: Interval = .week
    @State private var rawSelectedDate: Date? = nil
    var selectedDateValue: Speed? {
        if let rawSelectedDate {
            return viewModel.speeds.first(where: {
                Calendar.current.isDate($0.date, equalTo: rawSelectedDate, toGranularity: selectedInterval.unit)
            })
        }
        return nil
    }
    
    var body: some View {
        List {
            Picker("Interval", selection: $selectedInterval) {
                ForEach(Interval.allCases) {
                    interval in
                    Text(interval.rawValue.capitalized)
                }
            }
            .onChange(of: selectedInterval) {
                viewModel.fetchSpeeds(forPast: selectedInterval.toInteger)
            }
            .pickerStyle(.segmented)
            .listRowSeparator(.hidden)
            VStack(alignment: .leading) {
                Text("AVERAGE").font(.caption)
                HStack(alignment: .bottom) {
                    Text("\(viewModel.averageSpeed.twoDecimals)").font(.title).bold().foregroundStyle(.green)
                    Text("m/s")
                }
                Text(Globals.formattedInterval(startDate: viewModel.speeds.first?.date, endDate: viewModel.speeds.last?.date))
            }
            Chart(viewModel.speeds) {
                LineMark(x: .value("Day", $0.date, unit: selectedInterval.unit), y: .value("m/s", $0.value.twoDecimals)).foregroundStyle(.green)
                    .opacity(selectedDateValue == nil || selectedDateValue?.id == $0.id ? 1 : 0.5)
                    .interpolationMethod(.catmullRom)
                    .lineStyle(.init(lineWidth: 2))
                    .symbol {
                        Circle()
                            .fill(.green)
                            .frame(width: 12, height: 12)
                    }
                if let rawSelectedDate {
                    RuleMark(x: .value("Day", rawSelectedDate, unit: selectedInterval.unit)).annotation(position: .top, overflowResolution: .init(x: .fit(to: .chart), y: .fit(to: .chart))) {
                        if let selectedDateValue {
                            VStack(alignment: .leading) {
                                Text("TOTAL").font(.caption)
                                HStack(alignment: .bottom) {
                                    Text("\(selectedDateValue.value.twoDecimals)").font(.title).foregroundStyle(.green).bold()
                                    Text("m/s")
                                }
                                Text(selectedDateValue.date.large(unit: selectedInterval.unit))
                            }
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.regularMaterial)
                            }
                        }
                    }
                    .foregroundStyle(.green)
                }
            }
            .frame(height: 400)
            .chartXSelection(value: $rawSelectedDate)
            .navigationTitle("Speed")
            .navigationBarTitleDisplayMode(.inline)
            .listRowSeparator(.hidden)
            
        }
        .listStyle(.plain)
        .onDisappear {
            viewModel.fetchSpeeds()
        }
        .refreshable {
            viewModel.fetchSpeeds(forPast: selectedInterval.toInteger)
        }
    }
}

#Preview {
    SpeedMetricsView(viewModel: .preview)
}

//
//  DistanceMetricsView.swift
//  Yasta
//
//  Created by Antonio Cranga on 14.04.2024.
//

import Charts
import SwiftUI

struct DistanceMetricsView: View {
    @State var viewModel: StepTrackerViewModel

    @State private var selectedInterval: Interval = .week
    @State private var rawSelectedDate: Date? = nil
    var selectedDateValue: Distance? {
        if let rawSelectedDate {
            return viewModel.distances.first(where: {
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
                viewModel.fetchDistances(forPast: selectedInterval.toInteger)
            }
            .pickerStyle(.segmented)
            .listRowSeparator(.hidden)
            VStack(alignment: .leading) {
                Text("AVERAGE").font(.caption)
                HStack(alignment: .bottom) {
                    Text("\(viewModel.averageDistance.twoDecimals)").font(.title).bold().foregroundStyle(.red)
                    Text("m/s")
                }
                Text(Globals.formattedInterval(startDate: viewModel.distances.first?.date, endDate: viewModel.distances.last?.date))
            }
            Chart(viewModel.distances) {
                LineMark(x: .value("Day", $0.date, unit: selectedInterval.unit), y: .value("m/s", $0.value)).foregroundStyle(.red)
                    .opacity(selectedDateValue == nil || selectedDateValue?.id == $0.id ? 1 : 0.5)
                    .interpolationMethod(.catmullRom)
                    .lineStyle(.init(lineWidth: 2))
                    .symbol {
                        Circle()
                            .fill(.red)
                            .frame(width: 12, height: 12)
                    }
                if let rawSelectedDate {
                    RuleMark(x: .value("Day", rawSelectedDate, unit: selectedInterval.unit)).annotation(position: .top, overflowResolution: .init(x: .fit(to: .chart), y: .fit(to: .chart))) {
                        if let selectedDateValue {
                            VStack(alignment: .leading) {
                                Text("TOTAL").font(.caption)
                                HStack(alignment: .bottom) {
                                    Text("\(selectedDateValue.value.twoDecimals)").font(.title).foregroundStyle(.red).bold()
                                    Text("m")
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
                    .foregroundStyle(.red)
                }
            }
            .frame(height: 400)
            .chartXSelection(value: $rawSelectedDate)
            .navigationTitle("Distance")
            .navigationBarTitleDisplayMode(.inline)
            .listRowSeparator(.hidden)
            
        }
        .listStyle(.plain)
        .onDisappear {
            viewModel.fetchDistances()
        }
        .refreshable {
            viewModel.fetchDistances(forPast: selectedInterval.toInteger)
        }
    }
}

#Preview {
    DistanceMetricsView(viewModel: .preview)
}

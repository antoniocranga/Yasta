//
//  StepsMetricsView.swift
//  Yasta
//
//  Created by Antonio Cranga on 14.04.2024.
//

import Charts
import SwiftUI

struct StepsMetricsView: View {
    @State var viewModel: StepTrackerViewModel

    @State private var selectedInterval: Interval = .week
    @State private var rawSelectedDate: Date? = nil
    var selectedDateValue: Step? {
        if let rawSelectedDate {
            return viewModel.steps.first(where: {
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
                viewModel.fetchSteps(forPast: selectedInterval.toInteger)
            }
            .pickerStyle(.segmented)
            .listRowSeparator(.hidden)
            VStack(alignment: .leading) {
                Text("AVERAGE").font(.caption)
                HStack(alignment: .bottom) {
                    Text("\(viewModel.averageSteps)").font(.title).bold().foregroundStyle(.blue)
                    Text("steps")
                }
                Text(Globals.formattedInterval(startDate: viewModel.steps.first?.date, endDate: viewModel.steps.last?.date))
            }
            Chart(viewModel.steps) {
                BarMark(x: .value("Day", $0.date, unit: selectedInterval.unit), y: .value("Steps", $0.count)).foregroundStyle(.blue)
                    .opacity(selectedDateValue == nil || selectedDateValue?.id == $0.id ? 1 : 0.5)
                
                if let rawSelectedDate {
                    RuleMark(x: .value("Day", rawSelectedDate, unit: selectedInterval.unit)).annotation(position: .top, overflowResolution: .init(x: .fit(to: .chart), y: .fit(to: .chart))) {
                        if let selectedDateValue {
                            VStack(alignment: .leading) {
                                Text("TOTAL").font(.caption)
                                HStack(alignment: .bottom) {
                                    Text("\(selectedDateValue.count)").font(.title).foregroundStyle(.blue).bold()
                                    Text("steps")
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
                }
            }
            .frame(height: 400)
            .chartXSelection(value: $rawSelectedDate)
            .navigationTitle("Steps")
            .navigationBarTitleDisplayMode(.inline)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .onDisappear {
            viewModel.fetchSteps()
        }
        .refreshable {
            viewModel.fetchSteps(forPast: selectedInterval.toInteger)
        }
    }
}

#Preview {
    StepsMetricsView(viewModel: .preview)
}

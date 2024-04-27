//
//  CaloriesMetricsView.swift
//  Yasta
//
//  Created by Antonio Cranga on 14.04.2024.
//

import Charts
import SwiftUI

struct CaloriesMetricsView: View {
    @State var viewModel: StepTrackerViewModel

    @State private var selectedInterval: Interval = .week
    @State private var rawSelectedDate: Date? = nil
    var selectedDateValue: Calorie? {
        if let rawSelectedDate {
            return viewModel.calories.first(where: {
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
                viewModel.fetchCalories(forPast: selectedInterval.toInteger)
            }
            .pickerStyle(.segmented)
            .listRowSeparator(.hidden)
            VStack(alignment: .leading) {
                Text("AVERAGE").font(.caption)
                HStack(alignment: .bottom) {
                    Text("\(viewModel.averageCalories)").font(.title).bold().foregroundStyle(.orange)
                    Text("calories")
                }
                Text(Globals.formattedInterval(startDate: viewModel.calories.first?.date, endDate: viewModel.calories.last?.date))
            }
            Chart(viewModel.calories) {
                BarMark(x: .value("Day", $0.date, unit: selectedInterval.unit), y: .value("Calories", $0.count)).foregroundStyle(.orange)
                    .opacity(selectedDateValue == nil || selectedDateValue?.id == $0.id ? 1 : 0.5)
                
                if let rawSelectedDate {
                    RuleMark(x: .value("Day", rawSelectedDate, unit: selectedInterval.unit)).annotation(position: .top, overflowResolution: .init(x: .fit(to: .chart), y: .fit(to: .chart))) {
                        if let selectedDateValue {
                            VStack(alignment: .leading) {
                                Text("TOTAL").font(.caption)
                                HStack(alignment: .bottom) {
                                    Text("\(selectedDateValue.count)").font(.title).foregroundStyle(.orange).bold()
                                    Text("calories")
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
                    .foregroundStyle(.orange)
                }
            }
            .frame(height: 400)
            .chartXSelection(value: $rawSelectedDate)
            .navigationTitle("Calories")
            .navigationBarTitleDisplayMode(.inline)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .onDisappear {
            viewModel.fetchCalories()
        }
        .refreshable {
            viewModel.fetchCalories(forPast: selectedInterval.toInteger)
        }
    }
}

#Preview {
    CaloriesMetricsView(viewModel: .preview)
}

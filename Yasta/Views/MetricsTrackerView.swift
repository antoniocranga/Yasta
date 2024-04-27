//
//  StepTrackerView.swift
//  Yasta
//
//  Created by Antonio Cranga on 06.04.2024.
//

import Charts
import SwiftUI

struct MetricsTrackerView: View {
    @State var viewModel: StepTrackerViewModel

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        StepsMetricsView(viewModel: viewModel)
                    } label: {
                        StepsMetricsPreview(viewModel: viewModel)
                    }
                } header: {
                    Text("Steps")
                }
                Section {
                    NavigationLink {
                        CaloriesMetricsView(viewModel: viewModel)
                    } label: {
                        CaloriesMetricsPreview(viewModel: viewModel)
                    }
                } header: {
                    Text("Calories")
                }
                Section {
                    NavigationLink {
                        SpeedMetricsView(viewModel: viewModel)
                    } label: {
                        SpeedMetricsPreview(viewModel: viewModel)
                    }
                } header: {
                    Text("Speeds")
                }
                Section {
                    NavigationLink {
                        DistanceMetricsView(viewModel: viewModel)
                    } label: {
                        DistanceMetricsPreview(viewModel: viewModel)
                    }
                } header: {
                    Text("Distance")
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(
                        action: {},
                        label: {
                            Image(systemName: "calendar")
                        }
                    )
                }
            }
            .navigationTitle("Activity")
        }
        .onAppear {
            viewModel.fetchMetrics()
        }
        .refreshable {
            viewModel.fetchMetrics()
        }
    }
}

#Preview {
    MetricsTrackerView(viewModel: .preview)
}

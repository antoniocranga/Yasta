//
//  ContentView.swift
//  Yasta
//
//  Created by Antonio Cranga on 06.04.2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var stepTrackerViewModel = StepTrackerViewModel()
    var body: some View {
        TabView {
            MetricsTrackerView(viewModel: stepTrackerViewModel).tabItem {
                Label("Activity", systemImage: "figure.walk")
            }
            StatisticsView().tabItem {
                Label("Statistics", systemImage: "chart.pie")
            }
            MapTrackerView().tabItem {
                Label("Map tracker", systemImage: "map")
            }
            SettingsView().tabItem {
                Label("Settings", systemImage: "gearshape")
            }
        }.background(.ultraThinMaterial)
    }
}

#Preview {
    ContentView()
}

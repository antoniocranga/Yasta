//
//  ContentView.swift
//  Yasta
//
//  Created by Antonio Cranga on 06.04.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            StepTrackerView().tabItem {
                Label ("Activity", systemImage: "figure.walk")
            }
            StepTrackerView().tabItem {
                Label ("Statistics", systemImage: "chart.pie")
            }
            StepTrackerView().tabItem {
                Label ("Map tracker", systemImage: "map")
            }
            StepTrackerView().tabItem {
                Label ("Settings", systemImage: "gearshape")
            }
        }.background(.ultraThinMaterial)
    }
}

#Preview {
    ContentView()
}

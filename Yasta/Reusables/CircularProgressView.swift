//
//  CircularProgressView.swift
//  Yasta
//
//  Created by Antonio Cranga on 06.04.2024.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle().stroke(
                .ultraThinMaterial,
                lineWidth: 4
            )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    .blue,
                    style: StrokeStyle(
                        lineWidth: 4, lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
        .frame(width: 30, height: 30)
    }
}

#Preview {
    CircularProgressView(progress: 0.1)
}

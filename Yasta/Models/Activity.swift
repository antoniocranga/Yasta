//
//  Activity.swift
//  Yasta
//
//  Created by Antonio Cranga on 07.04.2024.
//

import Foundation

struct Activity: Identifiable {
    let id = UUID()
    let date: Date
    let steps: Int
    let calorie: Calorie?
    let distance: Distance?
}

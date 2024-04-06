//
//  Item.swift
//  Yasta
//
//  Created by Antonio Cranga on 06.04.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

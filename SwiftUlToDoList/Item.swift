//
//  Item.swift
//  SwiftUlToDoList
//
//  Created by user on 2025/02/26.
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

//
//  Item.swift
//  My Closet
//
//  Created by Caroline Waxman on 1/30/25.
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

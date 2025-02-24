//
//  ClothingItem.swift
//  My Closet
//
//  Created by Caroline Waxman on 2/17/25.
//

import SwiftData

@Model
class ClothingItem {
    var name: String
    var category: String
    var owner: User?
    
    init(name: String, category: String, owner: User?) {
        self.name = name
        self.owner = owner
        self.category = category
    }
}

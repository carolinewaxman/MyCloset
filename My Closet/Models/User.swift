//
//  User.swift
//  My Closet
//
//  Created by Caroline Waxman on 2/6/25.
//

import SwiftData

@Model
class User {
    var name: String
    var email: String
    var password: String
    var clothing_categories_raw: String
    var clothing_items: [ClothingItem]
    var groups: [String] = []
    
    var clothing_categories: [String] {
        get { clothing_categories_raw.components(separatedBy: ",") }
        set { clothing_categories_raw = newValue.joined(separator: ",") }
    }
    
    
    init(name: String, email: String, password: String, clothing_categories: [String] = [], clothing_items: [ClothingItem] = [], groups: [String] = []) {
        self.name = name
        self.email = email
        self.password = password
        self.clothing_categories_raw = clothing_categories.joined(separator: ",")
        self.clothing_items = clothing_items
        self.groups = groups
    }
}

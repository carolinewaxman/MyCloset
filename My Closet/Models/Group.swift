//
//  Groups.swift
//  My Closet
//
//  Created by Caroline Waxman on 1/31/25.
//
import SwiftData
import Foundation

@Model
class Group {
    var id: String
    var name: String
    var joinCode: String
    var members: [String] = []
    
    init(name: String, joinCode: String) {
        self.id = UUID().uuidString
        self.name = name
        self.joinCode = joinCode
        self.members = []
    }
    
}

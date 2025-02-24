//
//  UserManager.swift
//  My Closet
//
//  Created by Caroline Waxman on 2/8/25.
//

import SwiftData
import Foundation

class UserManager {
    static let shared = UserManager()
    
    func getUser(email: String, context: ModelContext) -> User? {
        let predicate = #Predicate<User> { user in user.email == email}
        let descriptor = FetchDescriptor<User>(predicate: predicate)
        return try? context.fetch(descriptor).first
    }
    
    func registerUser(name: String, email: String, password: String, context: ModelContext) -> Bool {
        if getUser(email: email, context: context) != nil {
            return false
        }
        let newUser = User(name: name, email: email, password: password, clothing_categories: [])
        context.insert(newUser)
        return true
    }
    
    func authenticateUser(email: String, password: String, context: ModelContext) -> Bool {
        if let user = getUser(email: email, context: context), user.password == password {
            return true
        }
        return false
    }
    
    func updateCategories(email: String, new_categories: [String], context: ModelContext) {
        if let user = getUser(email: email, context: context) {
            user.clothing_categories = new_categories
            try? context.save()
        }
    }
    
    func addItem(email: String, item_name: String, category: String, context: ModelContext) {
        if let user = getUser(email: email, context: context) {
            let new_item = ClothingItem(name: item_name, category: category, owner: user)
            user.clothing_items.append(new_item)
            try? context.save()
        }
        
    }
    
    func getItem(email: String, category: String, context: ModelContext) -> [ClothingItem] {
        if let user = getUser(email: email, context: context) {
            return user.clothing_items.filter { $0.category == category }
        }
        return []
    }
    
    func createGroup(name: String, context: ModelContext) -> Group {
        let new_group = Group(name: name, joinCode: UUID().uuidString.prefix(6).uppercased())
        context.insert(new_group)
        try? context.save()
        return new_group
    }
    
    func joinGroup(user: User, joinCode: String, context: ModelContext) -> Bool {
        do {
            if let group = try context.fetch(FetchDescriptor<Group>()).first(where: { $0.joinCode == joinCode }) {
                if !group.members.contains(user.email) {
                    group.members.append(user.email)
                    user.groups.append(group.id)
                    try? context.save()
                    return true
                }
            }
        } catch {
            print("Error joining group: \(joinCode)")
        }
        return false
    }
    
    func getUsersGroup(user: User, context: ModelContext) -> [Group] {
        do {
            return try context.fetch(FetchDescriptor<Group>()).filter { user.groups.contains($0.id) }
            
        } catch {
            print("Error fetching groups")
            return []
        }
        
    }
}

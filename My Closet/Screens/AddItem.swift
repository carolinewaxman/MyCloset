//
//  New.swift
//  My Closet
//
//  Created by Caroline Waxman on 1/31/25.
//

import SwiftUI
import SwiftData

struct AddItemPage: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    
    @State private var selectedUser: User?
    @State private var showImagePicker: Bool = false
    @State private var itemName: String = ""
    @State private var selectedCategory: String = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                TextStyle(text: "Add Item", color: .black)
                if let user = selectedUser {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(user.clothing_categories, id: \.self) { category in
                            TextStyle(text: category, color: .white).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    TextField("Item Name", text: $itemName)
                    Button("Add Item") {
                        addItem()
                    }
                }
                
            }
        }
        .onAppear {
            fetchUser()
        }
    }
    func fetchUser() {
        selectedUser = users.first
    }
    
    func addItem() {
        guard let user = selectedUser, !itemName.isEmpty else { return }
        UserManager.shared.addItem(email: user.email, item_name: itemName, category: selectedCategory, context: modelContext)
        itemName = ""
    }
}

#Preview {
    AddItemPage()
}

//
//  EditCategories.swift
//  My Closet
//
//  Created by Caroline Waxman on 2/9/25.
//

import SwiftData
import SwiftUI


struct EditCategoriesPage: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("currentUserEmail") private var currentUserEmail: String = ""
    @Query private var users: [User]
    
    @State private var new_category: String = ""
    @State private var selected_user: User?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    EditButton().foregroundColor(.white)
                }
                
                if let user = selected_user {
                    List {
                        ForEach(user.clothing_categories.indices, id: \.self) { index in
                            TextStyle(text: "Category:", color: .white)
                            Binding (
                                get: { user.clothing_categories[index] },
                                set: { user.clothing_categories[index] = $0 }
                            )
//                            .listRowBackground(Color.black)
                        }
                        .onDelete(perform: removeCategory)
                    }
                }
                Button(action: addCategory) {
                    TextStyle(text: "Add", color: .white)
                }
            }
            .padding()
            .onAppear {
                fetchUser()
            }
        }
    }
    func fetchUser() {
        selected_user = users.first(where: { $0.email == currentUserEmail })
    }

    func addCategory() {
        guard let user = selected_user, !new_category.isEmpty else { return }
        user.clothing_categories.append(new_category)
        try? modelContext.save()
        new_category = ""
    }

    func removeCategory(at offsets: IndexSet) {
        guard let user = selected_user else { return }
        offsets.forEach {
            user.clothing_categories.remove(at: Int($0))
        }
        try? modelContext.save()
    }
}

#Preview {
    EditCategoriesPage()
}

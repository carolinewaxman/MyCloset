//
//  Clothing.swift
//  My Closet
//
//  Created by Caroline Waxman on 1/31/25.
//

import SwiftUI
import SwiftData

struct ClothingPage: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("currentUserEmail") private var currentUserEmail: String = ""
    @Query private var users: [User]
    @State private var selected_user: User?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                TextStyle(text: "Your Categories:", color: .white)
                if let user = selected_user {
                    VStack(alignment: .leading, spacing: 10) {
                        List {
                            ForEach(user.clothing_categories, id:\.self) { category in
                                VStack (alignment: .leading, spacing: 5) {
                                    TextStyle(text: category, color: .white)
                                        .font(.headline)
                                    ForEach(user.clothing_items.filter { $0.category == category }, id: \.name) { item in
                                        TextStyle(text: item.name, color: .white)
                                            .padding(.leading, 10)
                                    }
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .listStyle(InsetListStyle())
                        Spacer()
                        NavigationLink(destination: EditCategoriesPage()) {
                            Text("Edit Categories")
                        }
                    }
                }
            }
            .onAppear {
                fetchUser()
            }
        }
    }
    func fetchUser() {
        selected_user = users.first(where: { $0.email == currentUserEmail })
    }
}
#Preview {
    ClothingPage()
}

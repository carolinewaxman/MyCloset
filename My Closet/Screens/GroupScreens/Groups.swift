//
//  Groups.swift
//  My Closet
//
//  Created by Caroline Waxman on 2/19/25.
//

import SwiftUI
import SwiftData

struct GroupsPage: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var users: [User]
    
    @State private var selected_user: User?
    @State private var user_groups: [Group] = []
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                List( user_groups, id: \.id) { group in
                    TextStyle(text: group.name, color: .white)
                    Spacer()
                }
            }
            .onAppear {
                if let user = users.first {
                    selected_user = user
                    user_groups = UserManager.shared.getUsersGroup(user: user, context: modelContext)
                }
            }
        }
    }
}

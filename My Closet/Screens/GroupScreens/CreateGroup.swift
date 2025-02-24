//
//  CreateGroup.swift
//  My Closet
//
//  Created by Caroline Waxman on 2/19/25.
//

import SwiftUI
import SwiftData

struct CreateGroupPage: View {
    @Environment(\.modelContext) private var modelContext
    @State private var group_name: String = ""
    @State private var created_group: Group? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    TextStyle(text: "Enter Group Name", color: .white)
                    TextField("", text: $group_name)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .font(.custom("GowunBatang-Regular", size: 20))
                    Button(action: {
                        let new_group = UserManager.shared.createGroup(name: group_name, context: modelContext)
                        created_group = new_group
                    }) {
                        TextStyle(text: "Create Group", color: .white)
                            .underline()
                    }
                        
                    if let group = created_group {
                        Text("Group Created: \(group.name)")
                        Text("Join code \(group.joinCode)")
                    }
                }
            }
        }
    }
}


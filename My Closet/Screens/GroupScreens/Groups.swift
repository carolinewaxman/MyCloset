import SwiftUI
import SwiftData

struct GroupsPage: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("currentUserEmail") private var currentUserEmail: String = ""
    @Query private var users: [User]
    @Query private var allGroups: [Group]
    
    @State private var selected_user: User?
    
    var body: some View {
        SidebarLayout {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    TextStyle(text: "My Groups", color: .white)
                        .font(.title)
                    
                    if let user = users.first(where: { $0.email == currentUserEmail }) {
                        let userGroupObjects = allGroups.filter { group in
                            user.groups.contains(group.id)
                        }
                        
                        if userGroupObjects.isEmpty {
                            TextStyle(text: "You are not in any groups.", color: .white)
                        } else {
                            ForEach(userGroupObjects, id: \.id) { group in
                                VStack(alignment: .leading) {
                                    TextStyle(text: group.name, color: .white)
                                    TextStyle(text: "Join Code: \(group.joinCode)", color: .gray)
                                    
                                    Button(action: {
                                        if let user = users.first(where: { $0.email == currentUserEmail }) {
                                            UserManager.shared.leaveGroup(user: user, group: group, context: modelContext)
                                        }
                                    }) {
                                        TextStyle(text: "Leave Group", color: .red)
                                            .underline()
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                        HStack(spacing: 20) {
                            NavigationLink(destination: CreateGroupPage()) {
                                TextStyle(text: "Create Group", color: .green)
                                    .underline()
                            }
                            
                            NavigationLink(destination: JoinGroupPage()) {
                                TextStyle(text: "Join Group", color: .blue)
                                    .underline()
                            }
                        }
                        .padding(.bottom, 10)
                    } else {
                        TextStyle(text: "No user found", color: .red)
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

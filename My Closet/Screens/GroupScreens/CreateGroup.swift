import SwiftUI
import SwiftData

struct CreateGroupPage: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("currentUserEmail") private var currentUserEmail: String = ""
    @EnvironmentObject var navManager: NavigationManager
    @Query private var users: [User]

    @State private var group_name: String = ""
    @State private var created_group: Group? = nil

    var body: some View {
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
                    if let user = users.first(where: { $0.email == currentUserEmail }) {
                        let group = UserManager.shared.createGroup(name: group_name, context: modelContext)
                        user.groups.append(group.id)
                        group.members.append(user.email)
                        try? modelContext.save()
                        created_group = group
                        navManager.selectedPage = .groupDetails(group)
                    }
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

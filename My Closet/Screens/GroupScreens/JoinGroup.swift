import SwiftUI
import SwiftData

struct JoinGroupPage: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var users: [User]
    @State private var joinCode: String = ""
    @State private var selected_user: User?
    @State private var joinSuccess: Bool?
    
    var body: some View {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    TextStyle(text: "Enter Join Code", color: .white)
                    TextField("", text: $joinCode)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .font(.custom("GowunBatang-Regular", size: 20))
                    Button(action: {
                        if let user = selected_user {
                            joinSuccess = UserManager.shared.joinGroup(user: user, joinCode: joinCode, context: modelContext)
                        }
                    }) {
                        TextStyle(text: "Join Group", color: .white)
                            .underline()
                    }
                    
                    if let success = joinSuccess {
                        TextStyle(
                            text: success ? "Successfully joined the group!" : "Invalid join code or already a member.",
                            color: success ? .green : .red
                        )
                    }
                }
                .onAppear {
                    selected_user = users.first
                }
            }
    }
}

import SwiftUI
import SwiftData

struct LogInPage: View {
    @Environment(\.modelContext) private var ModelContext
    @AppStorage("currentUserEmail") private var currentUserEmail: String = ""
    @EnvironmentObject var navManager: NavigationManager
    @Query private var users: [User]
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginError: String?
    @State private var isLoggedIn = false
    @State private var showHome = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if showHome {
                    HomePage()
                        .transition(.slide)
                } else {
                    VStack {
                        TextStyle(text: "Email", color: .white)
                        TextField("", text: $email)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .font(.custom("GowunBatang-Regular", size: 20))
                        
                        TextStyle(text: "Password", color: .white)
                        SecureField("", text: $password)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .font(.custom("GowunBatang-Regular", size: 20))
                        
                        Button(action: {
                            guard !email.isEmpty, !password.isEmpty else {
                                loginError = "Please fill out all fields."
                                return
                            }
                            
                            if UserManager.shared.authenticateUser(email: email, password: password, context: ModelContext) {
                                print("Successful login")
                                currentUserEmail = email
                                isLoggedIn = true
                                loginError = nil
                                withAnimation {
                                    navManager.selectedPage = .home
                                    showHome = true
                                }
                            } else {
                                loginError = "Incorrect email or password."
                            }
                        }) {
                            TextStyle(text: "Log In", color: .white)
                                .underline()
                        }
                        
                        if let error = loginError {
                            Text(error)
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                    .navigationDestination(isPresented: $isLoggedIn) {
                        HomePage()
                    }
                }
            }
        }
    }
}

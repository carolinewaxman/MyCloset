//
//  LogIn.swift
//  My Closet
//
//  Created by Caroline Waxman on 1/31/25.
//

import SwiftUI
import SwiftData

struct LogInPage: View {
    @Environment(\.modelContext) private var ModelContext
    @AppStorage("currentUserEmail") private var currentUserEmail: String = ""
    @Query private var users: [User] // fetches all existing users
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginError: Bool = false
    @State private var isLoggedIn = false
    @State private var showHome = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                if showHome {
                    HomePage()
                        .transition(.slide)
                }
                else {
                    VStack {
                        TextStyle(text: "Email", color: .white)
                        TextField("", text: $email)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .font(.custom("GowunBatang-Regular", size: 20))
                        
                        TextStyle(text: "Password", color: .white)
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .font(.custom("GowunBatang-Regular", size: 20))
                        
                        Button(action: {
                            if UserManager.shared.authenticateUser(email: email, password: password, context: ModelContext) {
                                print("successful log in")
                                currentUserEmail = email
                                isLoggedIn = true
                                withAnimation {
                                    showHome = true
                                }
                            }
                            else {
                                loginError = true
                            }
                        }) {
                            TextStyle(text: "Log In", color: .white)
                                .underline()
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

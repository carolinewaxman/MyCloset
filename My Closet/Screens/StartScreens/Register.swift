//
//  Register.swift
//  My Closet
//
//  Created by Caroline Waxman on 1/31/25.
//

import SwiftUI
import SwiftData

struct RegisterPage: View {
    @Environment(\.modelContext) private var ModelContext
    @AppStorage("currentUserEmail") private var currentUserEmail: String = ""
    @Query private var users: [User] // fetches all existing users
    
    @State private var Name: String = ""
    @State private var Email: String = ""
    @State private var Password: String = ""
    @State private var ConfirmPassword: String = ""
    @State private var isValid: Bool = false
    @State private var registrationError: String?
    @State private var path = NavigationPath()
    @State private var isRegistered = false
    @State private var showHome = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                if showHome {
                    HomePage()
                        .transition(.slide)
                }
                VStack {
                    TextStyle(text: "Name", color: .white)
                    TextField("", text: $Name)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .font(.custom("GowunBatang-Regular", size: 20))
                    TextStyle(text: "Email", color: .white)
                    TextField("", text: $Email)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .font(.custom("GowunBatang-Regular", size: 20))
                    TextStyle(text: "Password", color: .white)
                    SecureField("", text: $Password)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .font(.custom("GowunBatang-Regular", size: 20))
                    TextStyle(text: "Confirm Password", color: .white)
                    SecureField("", text: $ConfirmPassword)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .font(.custom("GowunBatang-Regular", size: 20))

                    Button(action: {
                        if !UserManager.shared.registerUser(name: Name, email: Email, password: Password, context: ModelContext) {
                            registrationError = "Account already in use"
                            
                        }
                        else {
                            print("Successful registration")
                            currentUserEmail = Email
                            isRegistered = true
                            registrationError = nil
                            withAnimation {
                                showHome = true
                            }
                        }
                    }) {
                        TextStyle(text: "Register", color: .white)
                            .underline()
                    }
                
                    if let error = registrationError {
                        Text(error).foregroundStyle(.red)
                        }
                }
                .navigationDestination(isPresented: $isRegistered) {
                    HomePage()
                }
            }
        }
    }
    func registerUser() {
        if users.contains(where: {$0.email == Email }) {
            registrationError = "Email in use already"
            return
        }
        
        if Password != ConfirmPassword {
            registrationError = "Passwords don't match"
            return
        }
        
        let newUser = User(name: Name, email: Email, password: Password)
        ModelContext.insert(newUser)
        
        print("Registered: \(newUser.name)")
        registrationError = nil
    }
}

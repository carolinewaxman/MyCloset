//
//  Loading.swift
//  My Closet
//
//  Created by Caroline Waxman on 1/31/25.
//
import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            // if already signed in, should go straight to HomePage() not WelcomePage()
            WelcomePage()
        }
        else {
            VStack {
                Image("MessyCloset")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                Spacer()
                TextStyle(text: "Your closet might look like this, but not anymore...", color: .black)
                    
            }
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isActive = true
                }
            }
        }
    }
}
#Preview {
    SplashScreen()
}

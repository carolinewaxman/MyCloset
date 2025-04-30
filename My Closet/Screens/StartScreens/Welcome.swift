import SwiftUI

struct WelcomePage: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    TextStyle(text: "It's good to see you, Gorgeous.", color: .white)
                        .font(.title)
                    Spacer()
                    TextStyle(text: "New User?", color: .white)
                        .font(.headline)
                    NavigationLink(destination: RegisterPage()) {
                        TextStyle(text: "Get Started!", color: .white)
                            .underline()
                    }
                    Spacer()
                    TextStyle(text: "Coming back?", color: .white)
                        .font(.headline)
                    NavigationLink(destination: LogInPage()) {
                        TextStyle(text: "Log In!", color: .white)
                            .underline()
                    }
                }
            }
        }
    }
}
//#Preview {
//    WelcomePage()
//}
        

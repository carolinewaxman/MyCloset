import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @Binding var selectedPage: ClosetPage
    var body: some View {
        if isActive {
            // if already signed in, should go straight to Home not Welcome
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
//#Preview {
//    SplashScreen()
//}

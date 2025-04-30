import SwiftUI

struct HomePage: View {
    @AppStorage("currentUserEmail") private var currentUserEmail: String = ""
    @EnvironmentObject var navManager: NavigationManager

    var body: some View {
        SidebarLayout {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    TextStyle(text: "You already look hot but you're about to look a lot", color: .white)
                    HStack {
                        Spacer()
                        TextStyle(text: "hotter.", color: .red)
                    }
                }
            }
        }
    }
}
#Preview {
    HomePage()
}


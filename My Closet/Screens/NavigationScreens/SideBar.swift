import SwiftUI
import SwiftData

struct SidebarView: View {
    @AppStorage("currentUserEmail") private var currentUserEmail: String = ""
    @Query private var users: [User]
    @EnvironmentObject var navManager: NavigationManager

    // deffine static pages with labels
    let staticPages: [(label: String, page: ClosetPage)] = [
        ("My Closet", .home),
        ("My Clothes", .clothing),
        ("Search", .search),
        ("Add Item", .addItem),
        ("My Groups", .groups)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(staticPages, id: \.page) { item in
                sidebarButton(label: item.label, page: item.page, isTitle: item.page == .home)
            }

            Button(action: {
                currentUserEmail = ""
            }) {
                TextStyle(text: "Log Out", color: .white)
                    .padding(.vertical, 8)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.red)
        .ignoresSafeArea()
    }

    func sidebarButton(label: String, page: ClosetPage, isTitle: Bool = false) -> some View {
        Button(action: {
            navManager.selectedPage = page
        }) {
            TextStyle(text: label, color: .white)
                .font(isTitle ? .title : .body)
                .padding(.top, isTitle ? 50 : 0)
                .padding(.vertical, 8)
        }
    }
}

struct SidebarLayout<Content: View>: View {
    @State private var isSidebarVisible: Bool = false
    @EnvironmentObject var navManager: NavigationManager

    let content: () -> Content

    var body: some View {
        ZStack {
            content()
                .blur(radius: isSidebarVisible ? 5 : 0)
                .disabled(isSidebarVisible)

            if isSidebarVisible {
                SidebarView()
                    .frame(width: 250)
                    .transition(.move(edge: .leading))
                    .zIndex(1)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -100 {
                        withAnimation {
                            isSidebarVisible = false
                        }
                    }
                }
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    withAnimation {
                        isSidebarVisible.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .foregroundColor(.white)
                }
            }
        }
    }
}


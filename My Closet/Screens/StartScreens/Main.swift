import SwiftUI

enum ClosetPage: Hashable {
    case search
    case clothing
    case addItem
    case editCategories
    case groups
    case home
    case CategoryDetails(String)
    case groupDetails(Group)
}

struct MainAppView: View {
    @State private var isSidebarVisible: Bool = false
    @EnvironmentObject var navManager: NavigationManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                ZStack {
                    switch navManager.selectedPage {
                    case .home:
                        HomePage()
                    case .search:
                        SearchPage()
                    case .clothing:
                        ClothingPage()
                    case .addItem:
                        AddItemPage()
                    case .editCategories:
                        EditCategoriesPage()
                    case .groups:
                        GroupsPage()
                    case .CategoryDetails(let category):
                        CategoryDetailsPage(category:category)
                    case .groupDetails(let group):
                        GroupDetailsPage(group: group)
                    }
                }
                .blur(radius: isSidebarVisible ? 5 : 0)
                .disabled(isSidebarVisible)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                
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
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        withAnimation {
//                            isSidebarVisible.toggle()
//                        }
//                    }) {
//                        Image(systemName: "line.horizontal.3")
//                            .foregroundColor(.white)
//                    }
//                }
//            }
        }
    }
}

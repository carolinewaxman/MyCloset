import SwiftUI
import SwiftData

struct SearchPage: View {
    @AppStorage("currentUserEmail") private var currentUserEmail: String = ""
    @Query private var users: [User]
    @State private var searchText: String = ""
    @EnvironmentObject var navManager: NavigationManager

    
    var filteredItems: [ClothingItem] {
        guard let user = users.first(where: { $0.email == currentUserEmail }) else { return [] }
        return user.clothing_items.filter {
            NormalizeCategory($0.category).contains(NormalizeCategory(searchText))
        }
    }

    var body: some View {
        SidebarLayout {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 10) {
                    TextStyle(text: "Soooo what's in your closet?", color: .white)
                        .font(.title2)
                        .padding(.bottom)

                    TextField("Search by category...", text: $searchText)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundColor(.white)

                    if filteredItems.isEmpty {
                        Spacer()
                        TextStyle(text: "No results yet...", color: .gray)
                            .padding(.top, 20)
                    } else {
                        ScrollView {
                            ForEach(filteredItems, id: \.id) { item in
                                HStack {
                                    if let data = item.image_data, let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(8)
                                    }
                                    VStack(alignment: .leading) {
                                        TextStyle(text: item.name, color: .white)
                                        TextStyle(text: item.category, color: .gray)
                                            .font(.caption)
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Search")
        }
    }
}

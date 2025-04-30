import SwiftUI
import SwiftData

struct CategoryDetailsPage: View {
    let category: String
    @AppStorage("currentUserEmail") private var currentUserEmail: String = ""
    @Query private var users: [User]
    @Query private var items: [ClothingItem]
    init(category: String) {
        self.category = category
        _items = Query(filter: #Predicate<ClothingItem> {item in
            item.category == category
        })
    }
    
    var userItems: [ClothingItem] {
        guard let user = users.first(where: { $0.email == currentUserEmail }) else { return [] }
        return user.clothing_items.filter { $0.category == category }
    }
    
    var body: some View {
        SidebarLayout {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(alignment: .leading) {
                    TextStyle(text: category, color: .white)
                        .font(.largeTitle)
                        .padding(.bottom, 10)
                    ScrollView {
                        ForEach(items, id: \.id) { item in
                            HStack {
                                if let data = item.image_data, let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(10)
                                }
                                TextStyle(text: item.name, color: .white)
                            }
                            .padding(.bottom, 8)
                        }
                    }
                    Spacer()
                    NavigationLink(destination: ManualAddItemPage(category: category)) {
                        TextStyle(text: "Add new item to \(category)", color: .white)
                        .padding()
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Your \(category)")
//            .navigationBarHidden(true)
        }
    }
}

#Preview {
    CategoryDetailsPage(category: "t-shirts")
}

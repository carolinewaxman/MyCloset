import SwiftUI
import SwiftData

struct GroupDetailsPage: View {
    @Bindable var group: Group
    @Environment(\.modelContext) private var modelContext
    
    @State private var itemName = ""
    @State private var itemCategory = ""
    @Query private var users: [User]
    
    var body: some View {
        SidebarLayout {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 20) {
                    TextStyle(text: "Group: \(group.name)", color: .white)
                    
                    TextField("Item name", text: $itemName)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    
                    TextField("Item category", text: $itemCategory)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    
                    Button("Add Item to Group") {
                        let owners = group.members.compactMap { email in
                            users.first(where: { $0.email == email })
                        }
                        
                        let item = ClothingItem(
                            name: itemName,
                            category: itemCategory,
                            image_data: Data(),
                            owners: owners,
                            location: nil
                        )
                        
                        group.clothing_items.append(item)
                        try? modelContext.save()
                    }
                    
                    Divider().background(Color.white)
                    
                    TextStyle(text: "Group Items", color: .white).bold()
                    ForEach(group.clothing_items, id: \.name) { item in
                        TextStyle(text: "\(item.name) (\(item.category))", color: .white)
                    }
                }
                .padding()
            }
        }
    }
}

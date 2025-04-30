import SwiftData
import SwiftUI

struct EditCategoriesPage: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("currentUserEmail") private var currentUserEmail: String = ""
    @Query private var users: [User]
    
    @State private var new_category: String = ""
    @State private var selected_user: User?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    EditButton().foregroundColor(.white)
                }
                
                if let user = selected_user {
                    List {
                        ForEach(user.clothing_categories.indices, id: \.self) { index in
                            TextField("Category:", text: Binding (
                                get: { user.clothing_categories[index] },
                                set: { newValue in
                                    if !defaultCategories.contains(user.clothing_categories[index]) {
                                        user.clothing_categories[index] = newValue
                                    }
                                }
                            ))
                            .disabled(defaultCategories.contains(user.clothing_categories[index]))
                            .listRowBackground(Color.black)
                        }
                        .onDelete(perform: removeCategory)
                    }
                }
                Button(action: addCategory) {
                    TextStyle(text: "Edit", color: .white)
                }
            }
            .padding()
            .onAppear {
                fetchUser()
            }
        }
    }
    func fetchUser() {
        if var user = users.first(where: { $0.email == currentUserEmail }) {
            if user.clothing_categories.isEmpty {
                user.clothing_categories = defaultCategories
                try? modelContext.save()
            }
            selected_user = user
        }
    }

    func addCategory() {
        guard let user = selected_user, !new_category.isEmpty else { return }
        user.clothing_categories.append(new_category)
        try? modelContext.save()
        new_category = ""
    }

    func removeCategory(at offsets: IndexSet) {
        guard let user = selected_user else { return }
        for index in offsets {
            let category = user.clothing_categories[index]
            if !defaultCategories.contains(category) {
                user.clothing_categories.remove(at: index)
            }
        }
        try? modelContext.save()
    }
}

#Preview {
    EditCategoriesPage()
}
 

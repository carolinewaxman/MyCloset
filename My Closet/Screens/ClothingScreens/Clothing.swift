import SwiftUI
import SwiftData
import Foundation

struct ClothingPage: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("currentUserEmail") private var currentUserEmail: String = ""
    @Query private var users: [User]
    @State private var selected_user: User?
    @State private var new_category: String = ""
    @State private var is_editing = false
    @EnvironmentObject var navManager: NavigationManager

    var body: some View {
        SidebarLayout {
            ClothingContentView(
                selected_user: selected_user,
                new_category: $new_category,
                is_editing: $is_editing,
                navManager: navManager,
                removeCategory: removeCategory,
                addCategory: addCategory
            )
        }
        .onAppear {
            fetchUser()
        }
    }

    func fetchUser() {
        guard let user = users.first(where: { $0.email == currentUserEmail }) else { return }
        selected_user = user
        if user.clothing_categories.isEmpty {
            user.clothing_categories = defaultCategories
            try? modelContext.save()
        }
    }

    func addCategory() {
        guard let user = selected_user, !new_category.isEmpty else { return }
        let normalized = NormalizeCategory(new_category)
        if !user.clothing_categories.contains(where: { NormalizeCategory($0) == normalized }) {
            user.clothing_categories.append(normalized)
            try? modelContext.save()
        }
        new_category = ""
    }

    func removeCategory(named normalized: String) {
        guard let user = selected_user else { return }
        user.clothing_categories.removeAll(where: { NormalizeCategory($0) == normalized })
        try? modelContext.save()
    }

    func normalizeExistingCategories() {
        guard let user = selected_user else { return }
        let unique = Dictionary(grouping: user.clothing_categories, by: NormalizeCategory).map { NormalizeCategory($0.key) }
        user.clothing_categories = Array(Set(unique))
    }
}

// index into arrays
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// extracted view
struct ClothingContentView: View {
    let selected_user: User?
    @Binding var new_category: String
    @Binding var is_editing: Bool
    var navManager: NavigationManager
    var removeCategory: (String) -> Void
    var addCategory: () -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    TextStyle(text: "Your Categories:", color: .white)
                        .font(.title)
                        .bold()
                    Spacer()
                }

                categoryList

                Spacer()

                Button(action: { is_editing.toggle() }) {
                    TextStyle(text: is_editing ? "Done" : "Edit", color: .blue)
                        .font(.title2)
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }
    }

    @ViewBuilder
    var categoryList: some View {
        if let user = selected_user {
            let groupedCategories = Dictionary(grouping: user.clothing_categories, by: NormalizeCategory)
            let normalizedSorted = groupedCategories.keys.sorted()

            List {
                ForEach(Array(normalizedSorted.enumerated()), id: \.offset) { (_, category) in
                    HStack {
                        if is_editing {
                            let categoryBinding = binding(for: category, in: user, groupedCategories: groupedCategories)

                            TextField("Category:", text: categoryBinding)
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                                .foregroundColor(.white)
                                .font(.headline)

                            Spacer()

                            Button(action: { removeCategory(category) }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title2)
                            }
                        } else {
                            Button(action: {
                                navManager.selectedPage = .CategoryDetails(category)
                            }) {
                                TextStyle(text: category, color: .white)
                                    .font(.headline)
                            }
                        }
                    }
                    .padding(.vertical, 5)
                    .listRowBackground(Color.black)
                }

                if is_editing {
                    HStack {
                        TextField("New Category", text: $new_category)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                            .foregroundColor(.white)
                            .font(.headline)

                        Button(action: addCategory) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .font(.title2)
                        }
                    }
                    .listRowBackground(Color.black)
                }
            }
            .listStyle(InsetListStyle())
            .scrollContentBackground(.hidden)
            .background(Color.black)
        }
    }
}

// extracted binding helper
func binding(for category: String, in user: User, groupedCategories: [String: [String]]) -> Binding<String> {
    Binding<String>(
        get: {
            groupedCategories[category]?.first ?? category
        },
        set: { new_val in
            if let oldIndex = user.clothing_categories.firstIndex(of: groupedCategories[category]?.first ?? category) {
                user.clothing_categories[oldIndex] = new_val
            }
        }
    )
}

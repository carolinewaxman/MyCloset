import SwiftUI
import SwiftData
import Foundation
struct AddItemPage: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @State private var selectedUser: User?
    @State private var showImagePicker: Bool = false
    @State private var itemName: String = ""
    @State private var selectedCategory: String = ""
    @State private var image: UIImage?
    @State private var predictedCategory: String = ""
    @State private var showConfirmation: Bool = false
    @State private var goToCategory: Bool = false
    @EnvironmentObject var navManager: NavigationManager

    
    var body: some View {
        SidebarLayout() {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    Button(action: {
                        showImagePicker = true
                    }) {
                        TextStyle(text: "Choose Photo", color: .white)
                    }
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(8)
                        TextStyle(text: "Predicted: \(predictedCategory)", color: .white)
                    }
                    if showConfirmation {
                        TextStyle(text: "Use '\(predictedCategory)' as the category?", color: .white)
                        HStack {
                            Button(action: {
                                selectedCategory = NormalizeCategory(predictedCategory)
                                if let user = selectedUser {
                                    if !user.clothing_categories.contains(where: { NormalizeCategory($0) == selectedCategory}) {
                                        user.clothing_categories.append(selectedCategory)
                                        try? modelContext.save()
                                    }
                                }
                                addItem()
                                goToCategory = true
                            }) {
                                TextStyle(text: "Yes", color: .white)
                            }
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            Button(action: {
                                showConfirmation = false
                            }) {
                                TextStyle(text: "No", color: .white)
                            }
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    NavigationLink(destination: CategoryDetailsPage(category: selectedCategory), isActive: $goToCategory) {
                        EmptyView()
                    }
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: $image, useCamera: false)
                        .onDisappear {
                            if let selectedImage = image {
                                predictedCategory = NormalizeCategory(detectCategory(from: selectedImage))
                                if let user = selectedUser {
                                    if user.clothing_categories.contains(predictedCategory) {
                                        selectedCategory = predictedCategory
                                    } else {
                                        selectedCategory = user.clothing_categories.first ?? ""
                                    }
                                }
                                showConfirmation = true
                            }
                        }
                }
            }
            .onAppear {
                fetchUser()
                if let user = users.first, user.clothing_categories.isEmpty {
                    user.clothing_categories = defaultCategories
                    try? modelContext.save()
                }
            }
        }
    }
    func fetchUser() {
        selectedUser = users.first
    }
    
    func addItem() {
        guard let user = selectedUser else { return }
        let name = itemName.isEmpty ? "Untitled Item" : itemName
        let image_data = image?.jpegData(compressionQuality: 0.8) ?? Data()
        
        UserManager.shared.addItem(email: user.email, item_name: itemName, category: selectedCategory, image_data: image_data, context: modelContext)
        itemName = ""
    }
}

//#Preview {
//    AddItemPage()
//}

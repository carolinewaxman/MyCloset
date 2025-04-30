import SwiftUI
import SwiftData

struct ManualAddItemPage: View {
    let category: String
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @AppStorage("currentUserEmail") private var currentUserEmail: String = ""
    @Query private var users: [User]

    @State private var selectedUser: User?
    @State private var itemName: String = ""
    @State private var image: UIImage?
    @State private var showImagePicker = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 20) {
                TextStyle(text: "Add to \(category)", color: .white)
                    .font(.title2)

                TextField("Item name", text: $itemName)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)

                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                }

                Button(action: {
                    showImagePicker = true
                }) {
                    TextStyle(text: image == nil ? "Choose Photo" : "Change Photo", color: .white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }

                Button(action: addItem) {
                    TextStyle(text: "Save", color: .white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
            .fullScreenCover(isPresented: $showImagePicker) {
                ImagePicker(image: $image, useCamera: false)
                    .onDisappear{print("Photo picker closed")}
            }
        }
        .onAppear {
            selectedUser = users.first(where: { $0.email == currentUserEmail })
        }
    }

    func addItem() {
        guard let user = selectedUser else { return }
        let name = itemName.isEmpty ? "Untitled Item" : itemName
        let imageData = image?.jpegData(compressionQuality: 0.8) ?? Data()

        UserManager.shared.addItem(
            email: user.email,
            item_name: name,
            category: NormalizeCategory(category),
            image_data: imageData,
            context: modelContext
        )

        dismiss() // go back to the category page
    }
}

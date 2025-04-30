import SwiftData
import Foundation

@Model
class ClothingItem {
    var name: String
    var category: String
    var owners: [User] = []
    var image_data: Data?
//    var location: String?
    
    init(name: String, category: String, image_data: Data, owners: [User], location: String?) {
        self.name = name
        self.owners = owners
        self.category = category
        self.image_data = image_data
//        self.locatioon = location
    }
}

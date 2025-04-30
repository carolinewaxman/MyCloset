import SwiftData
import Foundation

@Model
class Group {
    var id: String
    var name: String
    var joinCode: String
    var members: [String] = []
    var clothing_items: [ClothingItem] = []
    
    init(name: String, joinCode: String) {
        self.id = UUID().uuidString
        self.name = name
        self.joinCode = joinCode
        self.members = []
        self.clothing_items = []
    }
    
}

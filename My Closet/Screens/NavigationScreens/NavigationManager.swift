import Foundation
import SwiftUI

class NavigationManager: ObservableObject {
    @Published var selectedPage: ClosetPage = .home
}

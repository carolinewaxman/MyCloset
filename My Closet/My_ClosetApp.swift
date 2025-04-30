//
//  My_ClosetApp.swift
//  My Closet
//
//  Created by Caroline Waxman on 1/30/25.
//

import SwiftUI
import SwiftData

@main
struct My_ClosetApp: App {
    @AppStorage("currentUserEmail") private var currentUserEmail: String = ""
    @State private var selectedPage: ClosetPage = .home
    @StateObject private var navManager = NavigationManager()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([User.self, ClothingItem.self, Group.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if currentUserEmail.isEmpty {
                NavigationStack {
                    WelcomePage()
                }
                .environmentObject(navManager)
            }
            else {
                MainAppView()
                    .environmentObject(navManager)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}

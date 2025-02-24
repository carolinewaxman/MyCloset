//
//  Search.swift
//  My Closet
//
//  Created by Caroline Waxman on 1/30/25.
//

import SwiftUI

struct SearchPage: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    TextStyle(text: "Soooo what's in your closet?", color: .white)
                }
                .navigationTitle("Search")
            }
        }
    }
}

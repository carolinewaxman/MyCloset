//
//  HomePage.swift
//  My Closet
//
//  Created by Caroline Waxman on 1/30/25.
//

import SwiftUI

struct HomePage: View {
    @AppStorage("currentUserEmail") private var currentUserEmail: String = ""
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    TextStyle(text: "You already look hot but you're about to look a lot", color: .white)
                    HStack {
                        Spacer()
                        TextStyle(text: "hotter.", color: .red)
                    }
                    NavigationLink(destination: SearchPage()) {
                        TextStyle(text:"Search", color: .white)
                    }
                    NavigationLink(destination: ClothingPage()) {
                        TextStyle(text:"My Clothes", color: .white)
                    }
                    NavigationLink(destination: AddItemPage()) {
                        TextStyle(text:"New Stuff?", color: .white)
                    }
                    Button(action: {
                        currentUserEmail = ""
                    })
                    {
                        TextStyle(text: "Log Out", color: .white)
                    }
                }
            }
        }
    }
}
#Preview {
    HomePage()
}


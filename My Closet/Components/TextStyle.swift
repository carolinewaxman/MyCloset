//
//  TextStyle.swift
//  My Closet
//
//  Created by Caroline Waxman on 1/30/25.
//

import SwiftUI

struct TextStyle: View {
    var text: String
    var color: Color
    
    var body: some View {
        Text(text)
            .font(.custom("GowunBatang-Regular", size: 30))
            .foregroundStyle(color)
    }
}

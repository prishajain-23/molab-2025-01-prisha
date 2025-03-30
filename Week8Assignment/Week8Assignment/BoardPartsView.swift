//
//  BoardPartsView.swift
//  Week8Assignment
//
//  Created by Prisha Jain on 3/30/25.
//

import SwiftUI

struct BoardPartsView: View {
    var body: some View {
        ZStack {
            // 🟥 DJ board base (black rectangle)
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black)
                .frame(width: 700, height: 300)
                .shadow(radius: 10)
        }
    }
}

#Preview {
    BoardPartsView()
}

//
//  BoardPartsView.swift
//  Week8Assignment
//
//  Created by Prisha Jain on 3/30/25.
//

import SwiftUI

struct BoardPartsView: View {
    var body: some View {
        HStack(spacing: 20) {
            DeckView()
            DeckView()
        }
        .padding()
        .background(.black)
        .cornerRadius(12)
    }
}

#Preview {
    BoardPartsView()
}

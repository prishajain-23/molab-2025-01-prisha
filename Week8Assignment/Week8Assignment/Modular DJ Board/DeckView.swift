//
//  DeckView.swift
//  Week8Assignment
//
//  Created by Prisha Jain on 3/30/25.
//

import SwiftUI

struct DeckView: View {
    @State private var audioManager = AudioManager()

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.gray.opacity(0.9))
            .frame(width: 180, height: 260)
            .shadow(radius: 5)
            .overlay(
                Text("Deck")
                    .foregroundColor(.white)
                    .font(.headline)
            )
    }
}

#Preview {
    DeckView()
}

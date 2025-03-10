//
//  ContentView.swift
//  Week6Assignment
//
//  Created by Prisha Jain on 3/8/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink("Play Synth", destination: SynthView())
                    .frame(width: 200, height: 50)
                    .background(Color.blue.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()

                NavigationLink("Saved Compositions", destination: SavedCompositionsView())
                    .frame(width: 200, height: 50)
                    .background(Color.green.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
            .navigationTitle("Synth Brainstorm")
        }
    }
}

#Preview {
    ContentView()
}

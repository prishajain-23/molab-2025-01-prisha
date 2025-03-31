//
//  ContentView.swift
//  Week8Assignment
//
//  Created by Prisha Jain on 3/19/25.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("DJ Explorer")
                    .font(.largeTitle)
                    .padding()

                List {
                    NavigationLink("3D Board View") {
                        _3DBoardView()
                    }
                    NavigationLink("Modular Board") {
                        ModularBoardView()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

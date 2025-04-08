//
//  Week9AssignmentApp.swift
//  Week9Assignment
//
//  Created by Prisha Jain on 4/1/25.
//

import SwiftUI
import FirebaseCore

@main
struct Week9AssignmentApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

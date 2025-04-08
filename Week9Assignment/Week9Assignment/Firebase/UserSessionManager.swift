//
//  FirebaseAuthManager.swift
//  Week9Assignment
//
//  Created by Prisha Jain on 4/8/25.
//

// A shared session manager that stores the currently selected username.
// This replaces traditional Firebase Auth and gives us a custom user identity
// based on a simple string (the username).

import Foundation
import Observation

@Observable
@MainActor
final class UserSessionManager {
    /// Singleton instance used across the app
    static let shared = UserSessionManager()

    /// The current username selected by the user
    var currentUsername: String? = nil

    /// Sets the current username and prints it for debug
    func setUsername(_ name: String) {
        currentUsername = name
        print("🟢 Active user: \(name)")
    }

    /// Returns true if a user has been selected
    var isUserSelected: Bool {
        currentUsername != nil
    }
}

//
//  UserSelectView.swift
//  Week9Assignment
//
//  Created by Prisha Jain on 4/8/25.
//

// first username view
// right now actually saving

// This view allows the user to either:
// - Select an existing username from Firestore
// - Enter a new username and use it immediately
// It sets the username in the shared UserSessionManager.

import SwiftUI

struct UserSelectView: View {
    /// All existing usernames fetched from Firestore
    @State private var existingUsernames: [String] = []

    /// New username input by the user
    @State private var newUsername: String = ""

    /// Whether the usernames are currently loading
    @State private var isLoading = false

    /// To dismiss this sheet
    @Environment(\.dismiss) var dismiss

    /// Singleton user session manager to store active user
    let session = UserSessionManager.shared
    /// Firestore logic interface
    let storage = FirebaseAudioStorage()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Select or Create User")
                    .font(.headline)

                // Show list of previously used usernames
                List(existingUsernames, id: \.self) { name in
                    Button(name) {
                        session.setUsername(name)
                        dismiss()
                    }
                }

                Divider()

                // Text field for entering a brand-new username
                TextField("New Username", text: $newUsername)
                    .textFieldStyle(.roundedBorder)

                Button("Create and Use") {
                    guard !newUsername.isEmpty else { return }
                    session.setUsername(newUsername)
                    dismiss()
                }

                Spacer()
            }
            .padding()
            .navigationTitle("User Login")
            .task {
                // Load all usernames from Firestore when view appears
                isLoading = true
                existingUsernames = await storage.fetchAllUsernames()
                isLoading = false
            }
        }
    }
}

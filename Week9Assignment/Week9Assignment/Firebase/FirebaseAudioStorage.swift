//
//  FirebaseAudioStorage.swift
//  Week9Assignment
//
//  Created by Prisha Jain on 4/8/25.
//

// A Firestore interface for saving and loading EQ settings under specific usernames.
// This wraps async Firebase logic in a reusable class.

import FirebaseFirestore
import Observation

@Observable
@MainActor
final class FirebaseAudioStorage {
    /// Firestore client reference
    private let db = Firestore.firestore()

    /// Saves EQ settings to Firestore under the given username.
    /// Each file gets its own document inside the `tracks` subcollection.
    func saveEQSettings(username: String, settings: EQSettings) async {
        do {
            try db.collection("users")
                .document(username)
                .collection("tracks")
                .document(settings.fileName)
                .setData(from: settings)  // Uses Codable to convert EQSettings to Firestore data
            print("✅ Settings saved for \(username)")
        } catch {
            print("❌ Failed to save EQ: \(error)")
        }
    }

    /// Loads EQ settings for a given audio file and user.
    /// If no settings exist, returns nil.
    func loadEQSettings(username: String, fileName: String) async -> EQSettings? {
        do {
            let docRef = db.collection("users")
                .document(username)
                .collection("tracks")
                .document(fileName)

            let snapshot = try await docRef.getDocument()
            return try snapshot.data(as: EQSettings.self)
        } catch {
            print("⚠️ Couldn’t load settings for \(fileName): \(error)")
            return nil
        }
    }

    /// Fetches a list of all usernames (top-level document IDs under `users/`)
    func fetchAllUsernames() async -> [String] {
        do {
            let snapshot = try await db.collection("users").getDocuments()
            return snapshot.documents.map { $0.documentID }
        } catch {
            print("❌ Failed to fetch usernames: \(error)")
            return []
        }
    }
}

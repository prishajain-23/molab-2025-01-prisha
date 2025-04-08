//
//  EQSettings.swift
//  Week9Assignment
//
//  Created by Prisha Jain on 4/8/25.
//



import Foundation

// A model representing the EQ settings for a specific audio file.
// This gets encoded/decoded when saving to or loading from Firestore.

struct EQSettings: Codable, Identifiable {
    /// Firestore document ID — we use the filename for uniqueness
    var id: String { fileName }

    /// Name of the audio file (used as Firestore doc ID)
    var fileName: String

    /// Stored low-pass filter cutoff (Hz)
    var lowPass: Float

    /// Stored high-pass filter cutoff (Hz)
    var highPass: Float
}

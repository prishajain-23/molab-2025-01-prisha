//
//  MusicTheory.swift
//  Week6Assignment
//
//  Created by Prisha Jain on 3/8/25.
//

import Foundation
import AudioKit

// Enum for Different Scales
enum Scale: String, CaseIterable, Codable {
    case pentatonic, major, minor

    func notes(octave: Int) -> [NoteWithOctave] {
        let baseNotes: [Note]
        switch self {
        case .pentatonic:
            baseNotes = [.C, .D, .E, .G, .A]
        case .major:
            baseNotes = [.C, .D, .E, .F, .G, .A, .B]
        case .minor:
            baseNotes = [.C, .D, .EFlat, .F, .G, .AFlat, .BFlat]
        }
        return baseNotes.map { NoteWithOctave(note: $0, octave: octave) }
    }
}

// Enum for Musical Notes
enum Note: String, CaseIterable, Codable {
    case C = "C", D = "D", E = "E", F = "F", G = "G", A = "A", B = "B"
    case EFlat = "E♭", AFlat = "A♭", BFlat = "B♭"

    func frequency(octave: Int) -> AUValue {
        let baseFrequencies: [Note: AUValue] = [
            .C: 16.35, .D: 18.35, .E: 20.60, .F: 21.83, .G: 24.50, .A: 27.50, .B: 30.87,
            .EFlat: 19.45, .AFlat: 25.96, .BFlat: 29.14
        ]
        return (baseFrequencies[self] ?? 16.35) * pow(2, AUValue(octave))
    }
}

// Struct for Notes with Octave
struct NoteWithOctave: Hashable, Codable {
    let note: Note
    let octave: Int

    var rawValue: String {
        return "\(note.rawValue)\(octave)"
    }

    var frequency: AUValue {
        return note.frequency(octave: octave)
    }
}

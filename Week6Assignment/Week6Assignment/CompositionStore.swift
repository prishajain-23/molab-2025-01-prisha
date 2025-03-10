//
//  CompositionStore.swift
//  Week6Assignment
//
//  Created by Prisha Jain on 3/8/25.
//

import Foundation

@Observable
class CompositionStore {
    var compositions: [Composition] = []

    init() {
        loadCompositions()
    }

    // Save a new composition
    func saveComposition(notes: [String]) {
        let composition = Composition(name: "Untitled", notes: notes, timestamp: Date())
        compositions.append(composition)
        saveToFile()
    }

    // Rename an existing composition
    func renameComposition(id: UUID, newName: String) {
        if let index = compositions.firstIndex(where: { $0.id == id }) {
            compositions[index].name = newName
            saveToFile()
        }
    }

    // Delete a composition
    func deleteComposition(id: UUID) {
        compositions.removeAll { $0.id == id }
        saveToFile()
    }

    // Save to JSON file
    private func saveToFile() {
        do {
            let jsonData = try JSONEncoder().encode(compositions)
            let fileURL = getDocumentsDirectory().appendingPathComponent("compositions.json")
            try jsonData.write(to: fileURL)
        } catch {
            print("❌ Failed to save compositions: \(error.localizedDescription)")
        }
    }

    // Load compositions from JSON file
    func loadCompositions() {
        let fileURL = getDocumentsDirectory().appendingPathComponent("compositions.json")
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }

        do {
            let jsonData = try Data(contentsOf: fileURL)
            compositions = try JSONDecoder().decode([Composition].self, from: jsonData)
        } catch {
            print("❌ Failed to load compositions: \(error.localizedDescription)")
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

// Composition Model
struct Composition: Codable, Identifiable {
    var id = UUID()
    var name: String
    let notes: [String]
    let timestamp: Date
}

// Extension to format timestamp
extension Composition {
    var timestampFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
}

//
//  SavedCompositionsView.swift
//  Week6Assignment
//
//  Created by Prisha Jain on 3/8/25.
//

import SwiftUI

struct SavedCompositionsView: View {
    @State private var compositionStore = CompositionStore()
    @State private var editingComposition: Composition? = nil
    @State private var newName: String = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(compositionStore.compositions.sorted(by: { $0.timestamp > $1.timestamp })) { composition in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            if editingComposition?.id == composition.id {
                                TextField("Enter name", text: $newName, onCommit: {
                                    compositionStore.renameComposition(id: composition.id, newName: newName)
                                    editingComposition = nil
                                })
                                .textFieldStyle(.roundedBorder)
                            } else {
                                Text(composition.name)
                                    .font(.headline)
                                    .onTapGesture {
                                        newName = composition.name
                                        editingComposition = composition
                                    }
                            }

                            Spacer()
                        }

                        Text("Notes: \(composition.notes.joined(separator: ", "))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .truncationMode(.tail)

                        Text(composition.timestampFormatted)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.systemBackground)).shadow(radius: 1))
                    .padding(.vertical, 5)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let composition = compositionStore.compositions[index]
                        compositionStore.deleteComposition(id: composition.id)
                    }
                }
            }
            .navigationTitle("Saved Compositions")
            .toolbar {
                EditButton() // Enables swipe-to-delete
            }
            .onAppear {
                compositionStore.loadCompositions()
            }
        }
    }
}


#Preview {
    SavedCompositionsView()
}

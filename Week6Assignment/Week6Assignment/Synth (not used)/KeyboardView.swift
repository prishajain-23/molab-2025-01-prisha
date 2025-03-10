//
//  KeyboardView.swift
//  Week6Assignment
//
//  Created by Prisha Jain on 3/8/25.
//

import SwiftUI

struct KeyboardView: View {
    var noteOn: (_ midiNote: UInt8) -> Void
    var noteOff: (_ midiNote: UInt8) -> Void

    var body: some View {
        ZStack {
            // White keys
            HStack(spacing: 0) {
                ForEach(KeyboardLayout.keys.filter { !$0.isBlack }) { key in
                    KeyView(note: key.note, isBlack: false, noteOn: noteOn, noteOff: noteOff)
                }
            }
            
            // Black keys (placed on top)
            HStack(spacing: 0) {
                ForEach(KeyboardLayout.keys.filter { $0.isBlack }) { key in
                    KeyView(note: key.note, isBlack: true, noteOn: noteOn, noteOff: noteOff)
                        .offset(x: blackKeyOffset(for: key.note))
                }
            }
        }
        .frame(height: 150) // Adjust as needed
        .padding()
    }

    // Adjusts black key position relative to white keys
    private func blackKeyOffset(for note: UInt8) -> CGFloat {
        let position = (note % 12)
        let blackKeyOffsets: [UInt8: CGFloat] = [1: -15, 3: 15, 6: -10, 8: 10, 10: 30]
        return blackKeyOffsets[position] ?? 0
    }
}

//
//  KeyView.swift
//  Week6Assignment
//
//  Created by Prisha Jain on 3/8/25.
//

import SwiftUI

struct KeyView: View {
    let note: UInt8
    let isBlack: Bool
    var noteOn: (_ midiNote: UInt8) -> Void
    var noteOff: (_ midiNote: UInt8) -> Void

    @State private var isPressed = false

    var body: some View {
        Rectangle()
            .fill(isBlack ? Color.black : Color.white)
            .frame(width: isBlack ? 30 : 50, height: isBlack ? 90 : 150)
            .overlay(
                Rectangle()
                    .stroke(Color.gray, lineWidth: 1)
            )
            .shadow(radius: isBlack ? 2 : 5)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            isPressed = true
                            noteOn(note)
                        }
                    }
                    .onEnded { _ in
                        isPressed = false
                        noteOff(note)
                    }
            )
    }
}

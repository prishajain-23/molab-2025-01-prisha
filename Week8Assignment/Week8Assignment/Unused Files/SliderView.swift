//
//  SliderView.swift
//  Week8Assignment
//
//  Created by Prisha Jain on 3/21/25.
//

import SwiftUI
import AudioKit

struct SliderView: View {
    let label: String
    @Binding var value: AUValue
    let range: ClosedRange<AUValue>

    var body: some View {
        VStack {
            Text(label).bold()
            Slider(value: $value, in: range)
        }
    }
}

#Preview {
    SliderView(
        label: "Volume",
        value: .constant(0.5),
        range: 0...1
    )
}

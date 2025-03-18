//
//  SliderView.swift
//  Week7Assignment
//
//  Created by Prisha Jain on 3/17/25.
//

import SwiftUI

struct SliderView: View {
    @Binding var amplitude: Float
    var color: Color

    var body: some View {
        VStack {
            Slider(value: $amplitude, in: 0...1)
                .accentColor(color)
        }
        .padding()
    }
}

#Preview {
    SliderView(amplitude: .constant(0.5), color: .blue)
}
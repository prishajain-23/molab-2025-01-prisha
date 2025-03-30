//
//  3DBoardView.swift
//  Week8Assignment
//
//  Created by Prisha Jain on 3/30/25.
//

import SwiftUI

struct _3DBoardView: View {
    @State private var resetRequested = false

    var body: some View {
        VStack {
            Text("Pioneer DJ Flx4")
            ModelViewer(modelName: "ddj_flx4_pioneer", resetRequested: $resetRequested)
                .frame(width: 400, height: 300)
            Button("Reset View") {
                resetRequested = true
                }
            .padding()
        }
    }
}

#Preview {
    _3DBoardView()
}

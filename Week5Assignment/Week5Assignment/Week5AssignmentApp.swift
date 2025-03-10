//
//  SeismometerDrumApp.swift
//  Seismometer
//
//  Created by Prisha Jain on 3/1/2025.
//

import SwiftUI

@main
struct Week5AssignmentApp: App {
    @State private var motionDetector = MotionDetector(updateInterval: 0.01)

    var body: some Scene {
        WindowGroup {
            MotionAudioView()
                .environment(motionDetector)
                .environment(DrumPlayer())
        }
    }
}


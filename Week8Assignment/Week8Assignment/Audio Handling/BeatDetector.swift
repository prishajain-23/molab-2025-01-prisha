//
//  BeatDetector.swift
//  Week8Assignment
//
//  Created by Prisha Jain on 3/30/25.
//

import Foundation
import AVFoundation
import Observation

@Observable
class BeatDetector {
    let tempi = TempiBeatDetector()
    private var bpmSamples: [Float] = []

    private(set) var currentBPM: Float = 0.0

    init() {
        tempi.delegate = self
        tempi.percussionOnly = false
        tempi.trackPeaks = true
    }

    func reset() {
        bpmSamples.removeAll()
        currentBPM = 0
    }
}

extension BeatDetector: TempiBeatDetectorDelegate {
    func tempiBeatDetector(_ detector: TempiBeatDetector!, didDetectTempo tempo: Float) {
        bpmSamples.append(tempo)
        if bpmSamples.count > 20 {
            bpmSamples.removeFirst()
        }

        let average = bpmSamples.reduce(0, +) / Float(bpmSamples.count)
        currentBPM = round(average * 10) / 10
    }
}

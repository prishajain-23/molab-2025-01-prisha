////
////  TempiPeakDetection.swift
////  Week8Assignment
////
////  Created by Prisha Jain on 3/30/25.
////
//
//import Foundation
//import Accelerate
//
//struct TempiPeak {
//    var timeStamp: Double
//    var magnitude: Float
//}
//
//typealias TempiPeakDetectionCallback = (_ timeStamp: Double, _ magnitude: Float) -> Void
//
//final class TempiPeakDetector {
//    
//    // MARK: - Configuration
//    var sampleRate: Float
//    var coalesceInterval: Double = 0.0
//    
//    private var sampleInterval: Double
//    private var recentMaxThresholdRatio: Float = 0.6
//    private var recentHistoryDuration: Float = 1.25
//    
//    // MARK: - State
//    private var trailingSamples: [Float] = []
//    private var peakQueue: [TempiPeak] = []
//    private var isOnsetting: Bool = false
//    private var counter: Int = 0
//    private var lastMagnitude: Float = 0.0
//    private var lastPeakTick: Int = 0
//    
//    private var peakDetectionCallback: TempiPeakDetectionCallback
//    
//    // MARK: - Init
//    init(peakDetectionCallback: @escaping TempiPeakDetectionCallback, sampleRate: Float) {
//        self.peakDetectionCallback = peakDetectionCallback
//        self.sampleRate = sampleRate
//        self.sampleInterval = 1.0 / Double(sampleRate)
//    }
//
//    // MARK: - Core Detection
//    func addMagnitude(timeStamp: Double, magnitude: Float) {
//        let trailingWindowSize = Int(sampleRate * recentHistoryDuration)
//        var recentMax: Float = 0.0
//
//        if !trailingSamples.isEmpty {
//            vDSP_maxv(trailingSamples, 1, &recentMax, UInt(trailingSamples.count))
//        }
//
//        let longWindowThreshold = recentMax * recentMaxThresholdRatio
//
//        trailingSamples.append(magnitude)
//        if trailingSamples.count > trailingWindowSize {
//            trailingSamples.removeFirst()
//        }
//
//        // Detect peak
//        if counter > Int(sampleRate), magnitude < lastMagnitude, isOnsetting {
//            let actualTimeStamp = timeStamp - sampleInterval
//            handlePeak(timeStamp: actualTimeStamp, magnitude: lastMagnitude, threshold: longWindowThreshold)
//        } else {
//            isOnsetting = magnitude > lastMagnitude
//        }
//
//        counter += 1
//        lastMagnitude = magnitude
//        evaluatePeakQueue(timeStamp: timeStamp)
//    }
//
//    // MARK: - Internal Methods
//    private func handlePeak(timeStamp: Double, magnitude: Float, threshold: Float) {
//        isOnsetting = false
//
//        guard magnitude >= threshold else { return }
//
//        if coalesceInterval == 0 {
//            peakDetectionCallback(timeStamp, magnitude)
//        } else {
//            peakQueue.append(TempiPeak(timeStamp: timeStamp, magnitude: magnitude))
//        }
//    }
//
//    private func evaluatePeakQueue(timeStamp: Double) {
//        guard coalesceInterval > 0, let oldestPeak = peakQueue.first else { return }
//
//        if timeStamp - oldestPeak.timeStamp > coalesceInterval {
//            if let maxPeak = peakQueue.max(by: { $0.magnitude < $1.magnitude }) {
//                peakQueue.removeAll()
//                peakDetectionCallback(maxPeak.timeStamp, maxPeak.magnitude)
//            }
//        }
//    }
//}

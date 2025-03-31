////
////  TempiBeatDetection.swift
////  Week8Assignment
////
////  Created by Prisha Jain on 3/30/25.
////
//
//import Foundation
//import Accelerate
//
//typealias TempiBeatDetectionCallback = (_ timeStamp: Double, _ bpm: Float) -> Void
//
//struct TempiPeakInterval {
//    var timeStamp: Double
//    var magnitude: Float
//    var interval: Float
//}
//
//class TempiBeatDetector: NSObject {
//    var sampleRate: Float = 22050
//    var chunkSize: Int = 2048
//    var hopSize: Int = 90
//    var minTempo: Float = 60
//    var maxTempo: Float = 220
//    var frequencyBands: Int = 12
//    var beatDetectionHandler: TempiBeatDetectionCallback!
//
//    private var audioInput: TempiAudioInput!
//    private var peakDetector: TempiPeakDetector!
//    private var lastMagnitudes: [Float]!
//    private var peakHistory: [TempiPeakInterval] = []
//    private var bucketCnt: Int = 10
//    private var queuedSamples: [Float] = []
//    private var queuedSamplesPtr: Int = 0
//    private var savedTimeStamp: Double!
//    private var lastPeakTimeStamp: Double!
//    private var confidence: Int = 0
//    private var lastMeasuredTempo: Float = 0.0
//    private var firstPass: Bool = true
//
//    func startFromMic() {
//        if self.audioInput == nil {
//            self.audioInput = TempiAudioInput(audioInputCallback: { [weak self] (timeStamp, numberOfFrames, samples) in
//                self?.handleMicAudio(timeStamp: timeStamp, numberOfFrames: numberOfFrames, samples: samples)
//            }, sampleRate: Double(self.sampleRate), numberOfChannels: 1)
//        }
//
//        self.setupCommon()
//        self.setupInput()
//        self.audioInput.startRecording()
//    }
//
//    func stop() {
//        self.audioInput.stopRecording()
//    }
//
//    private func handleMicAudio(timeStamp: Double, numberOfFrames: Int, samples: [Float]) {
//        if (self.queuedSamples.count + numberOfFrames < self.chunkSize) {
//            self.queuedSamples.append(contentsOf: samples)
//            if self.savedTimeStamp == nil {
//                self.savedTimeStamp = timeStamp
//            }
//            return
//        }
//
//        self.queuedSamples.append(contentsOf: samples)
//        var baseTimeStamp: Double = self.savedTimeStamp ?? timeStamp
//
//        while self.queuedSamples.count >= self.chunkSize {
//            let subArray: [Float] = Array(self.queuedSamples[0..<self.chunkSize])
//            self.analyzeAudioChunk(timeStamp: baseTimeStamp, samples: subArray)
//            self.queuedSamplesPtr += self.hopSize
//            self.queuedSamples.removeFirst(self.hopSize)
//            baseTimeStamp += Double(self.hopSize) / Double(self.sampleRate)
//        }
//
//        self.savedTimeStamp = nil
//    }
//
//    private func setupCommon() {
//        self.lastMagnitudes = [Float](repeating: 0, count: self.frequencyBands)
//        self.peakHistory = []
//
//        self.peakDetector = TempiPeakDetector(peakDetectionCallback: { [weak self] (timeStamp, magnitude) in
//            self?.handlePeak(timeStamp: timeStamp, magnitude: magnitude)
//        }, sampleRate: self.sampleRate / Float(self.hopSize))
//
//        self.peakDetector.coalesceInterval = 0.1
//        self.lastPeakTimeStamp = nil
//        self.lastMeasuredTempo = 0
//        self.confidence = 0
//        self.firstPass = true
//    }
//
//    private func setupInput() {
//        self.queuedSamples = []
//        self.queuedSamplesPtr = 0
//    }
//
//    func analyzeAudioChunk(timeStamp: Double, samples: [Float]) {
//        let (magnitude, success) = self.calculateMagnitude(timeStamp: timeStamp, samples: samples)
//        if (!success) {
//            return
//        }
//
//        self.peakDetector.addMagnitude(timeStamp: timeStamp, magnitude: magnitude)
//    }
//
//    private func handlePeak(timeStamp: Double, magnitude: Float) {
//        if (self.lastPeakTimeStamp == nil) {
//            self.lastPeakTimeStamp = timeStamp
//            return
//        }
//
//        let interval: Double = timeStamp - self.lastPeakTimeStamp!
//
//        let mappedInterval = self.mapInterval(interval)
//        let peakInterval = TempiPeakInterval(timeStamp: timeStamp, magnitude: magnitude, interval: Float(mappedInterval))
//        self.peakHistory.append(peakInterval)
//
//        if self.peakHistory.count >= 2 &&
//            (self.peakHistory.last?.timeStamp)! - (self.peakHistory.first?.timeStamp)! >= self.peakHistoryLength {
//            self.performBucketAnalysisAtTimeStamp(timeStamp: timeStamp)
//        }
//
//        self.lastPeakTimeStamp = timeStamp
//    }
//
//    private func calculateMagnitude(timeStamp: Double, samples: [Float]) -> (magnitude: Float, success: Bool) {
//        let fft = TempiFFT(withSize: self.chunkSize, sampleRate: self.sampleRate)
//        fft.windowType = .hanning
//        fft.fftForward(samples)
//
//        switch self.frequencyBands {
//        case 6:
//            fft.calculateLogarithmicBands(minFrequency: 100, maxFrequency: 5512, bandsPerOctave: 1)
//        case 12:
//            fft.calculateLogarithmicBands(minFrequency: 100, maxFrequency: 5512, bandsPerOctave: 2)
//        case 30:
//            fft.calculateLogarithmicBands(minFrequency: 100, maxFrequency: 5512, bandsPerOctave: 5)
//        default:
//            assertionFailure("Unsupported number of bands.")
//        }
//
//        var diffs: [Float] = []
//        for i in 0..<self.frequencyBands {
//            var mag = fft.magnitudeAtBand(i)
//
//            if mag > 0.0 {
//                mag = log10f(mag)
//            }
//
//            let diff: Float = 1000.0 * max(0.0, mag - self.lastMagnitudes[i])
//
//            self.lastMagnitudes[i] = mag
//            diffs.append(diff)
//        }
//
//        if self.firstPass {
//            self.firstPass = false
//            return (0.0, false)
//        }
//
//        return (tempi_median(diffs), true)
//    }
//
//    private func performBucketAnalysisAtTimeStamp(timeStamp: Double) {
//        var buckets = [[Float]](repeating: [], count: self.bucketCnt)
//
//        let minInterval: Float = 60.0 / self.maxTempo
//        let maxInterval: Float = 60.0 / self.minTempo
//        let range = maxInterval - minInterval
//        var originalBPM: Float = 0.0
//        var adjusted = false
//
//        for interval in self.peakHistory {
//            var bucketIdx:
//::contentReference[oaicite:4]{index=4}
// 

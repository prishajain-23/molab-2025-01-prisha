////
////  TempiFFT.swift
////  Week8Assignment
////
////  Created by Prisha Jain on 3/30/25.
////
//
//import Foundation
//import Accelerate
//
//@objc enum TempiFFTWindowType: Int {
//    case none
//    case hanning
//    case hamming
//}
//
//@objc class TempiFFT: NSObject {
//
//    private(set) var size: Int
//    private(set) var sampleRate: Float
//    private var halfSize: Int
//    private var log2Size: Int
//
//    private var dft: vDSP.DFT<  >?
//    private var window: [Float]?
//
//    private var realParts: [Float]
//    private var imagParts: [Float]
//    private(set) var magnitudes: [Float] = []
//
//    var windowType: TempiFFTWindowType = .none
//    var hasPerformedFFT = false
//
//    var nyquistFrequency: Float {
//        sampleRate / 2.0
//    }
//
//    var bandwidth: Float {
//        nyquistFrequency / Float(magnitudes.count)
//    }
//
//    private(set) var bandMagnitudes: [Float] = []
//    private(set) var bandFrequencies: [Float] = []
//    private(set) var numberOfBands: Int = 0
//    private(set) var bandMinFreq: Float = 0
//    private(set) var bandMaxFreq: Float = 0
//
//    init(withSize inSize: Int, sampleRate inSampleRate: Float) {
//        precondition((inSize & (inSize - 1)) == 0, "Size must be a power of 2")
//
//        self.size = inSize
//        self.sampleRate = inSampleRate
//        self.halfSize = inSize / 2
//        self.log2Size = Int(log2(Float(inSize)))
//
//        self.realParts = [Float](repeating: 0, count: halfSize)
//        self.imagParts = [Float](repeating: 0, count: halfSize)
//
//        super.init()
//
//        self.dft = vDSP.DFT(count: size,
//                            direction: .forward,
//                            transformType: .complexReal,
//                            ofType: Float.self)
//    }
//
//    func fftForward(_ input: [Float]) {
//        precondition(input.count == size, "Input size mismatch")
//
//        var inputCopy = input
//        if windowType != .none {
//            applyWindow(&inputCopy)
//        }
//
//        var imagZero = [Float](repeating: 0, count: size)
//        dft?.transform(inputReal: inputCopy,
//                       inputImaginary: imagZero,
//                       outputReal: &realParts,
//                       outputImaginary: &imagParts)
//
//        magnitudes = zip(realParts, imagParts).map { sqrt($0 * $0 + $1 * $1) }
//        hasPerformedFFT = true
//    }
//
//    func applyWindow(_ buffer: inout [Float]) {
//        window = [Float](repeating: 0.0, count: size)
//
//        switch windowType {
//        case .hanning:
//            vDSP_hann_window(&window!, vDSP_Length(size), Int32(vDSP_HANN_NORM))
//        case .hamming:
//            vDSP_hamm_window(&window!, vDSP_Length(size), Int32(0))
//        case .none:
//            return
//        }
//
//        vDSP_vmul(buffer, 1, window!, 1, &buffer, 1, vDSP_Length(size))
//    }
//
//    func calculateLinearBands(minFrequency: Float, maxFrequency: Float, numberOfBands: Int) {
//        guard hasPerformedFFT else { return }
//
//        let actualMaxFreq = min(nyquistFrequency, maxFrequency)
//        self.numberOfBands = numberOfBands
//        bandMagnitudes = [Float](repeating: 0.0, count: numberOfBands)
//        bandFrequencies = [Float](repeating: 0.0, count: numberOfBands)
//
//        let lowerIndex = frequencyToIndex(minFrequency)
//        let upperIndex = frequencyToIndex(actualMaxFreq)
//        let binRange = upperIndex - lowerIndex
//        let binSize = binRange / numberOfBands
//
//        for i in 0..<numberOfBands {
//            let start = lowerIndex + i * binSize
//            let end = start + binSize
//            let avg = fastAverage(magnitudes[start..<min(end, magnitudes.count)])
//            bandMagnitudes[i] = avg
//            bandFrequencies[i] = averageFrequency(startIndex: start, endIndex: end)
//        }
//
//        bandMinFreq = bandFrequencies.first ?? 0
//        bandMaxFreq = bandFrequencies.last ?? 0
//    }
//
//    func calculateLogarithmicBands(minFrequency: Float, maxFrequency: Float, bandsPerOctave: Int) {
//        guard hasPerformedFFT else { return }
//
//        let minFreq = max(1, minFrequency)
//        let maxFreq = min(nyquistFrequency, maxFrequency)
//
//        var boundaries: [Float] = []
//        var freq = maxFreq
//        while freq > minFreq {
//            boundaries.insert(freq, at: 0)
//            freq /= 2
//        }
//        boundaries.insert(minFreq, at: 0)
//
//        bandMagnitudes = []
//        bandFrequencies = []
//
//        for i in 0..<boundaries.count - 1 {
//            let low = boundaries[i]
//            let high = boundaries[i + 1]
//
//            let lowIdx = frequencyToIndex(low)
//            let highIdx = frequencyToIndex(high)
//            let range = max(1, highIdx - lowIdx)
//            let ratio = Float(range) / Float(bandsPerOctave)
//
//            for j in 0..<bandsPerOctave {
//                let start = lowIdx + Int(Float(j) * ratio)
//                let end = min(lowIdx + Int(Float(j + 1) * ratio), magnitudes.count)
//                let avg = fastAverage(magnitudes[start..<end])
//                bandMagnitudes.append(avg)
//                bandFrequencies.append(averageFrequency(startIndex: start, endIndex: end))
//            }
//        }
//
//        numberOfBands = bandMagnitudes.count
//        bandMinFreq = bandFrequencies.first ?? 0
//        bandMaxFreq = bandFrequencies.last ?? 0
//    }
//
//    func magnitudeAtBand(_ band: Int) -> Float {
//        guard hasPerformedFFT, band < bandMagnitudes.count else { return 0 }
//        return bandMagnitudes[band]
//    }
//
//    func frequencyAtBand(_ band: Int) -> Float {
//        guard hasPerformedFFT, band < bandFrequencies.count else { return 0 }
//        return bandFrequencies[band]
//    }
//
//    func magnitudeAtFrequency(_ frequency: Float) -> Float {
//        let index = frequencyToIndex(frequency)
//        return index < magnitudes.count ? magnitudes[index] : 0
//    }
//
//    func averageMagnitude(lowFreq: Float, highFreq: Float) -> Float {
//        var total: Float = 0
//        var count: Int = 0
//        var freq = lowFreq
//        while freq <= highFreq {
//            total += magnitudeAtFrequency(freq)
//            freq += bandwidth
//            count += 1
//        }
//        return count > 0 ? total / Float(count) : 0
//    }
//
//    func sumMagnitudes(lowFreq: Float, highFreq: Float, useDB: Bool = false) -> Float {
//        var total: Float = 0
//        var freq = lowFreq
//        while freq <= highFreq {
//            var mag = magnitudeAtFrequency(freq)
//            if useDB {
//                mag = max(0, TempiFFT.toDB(mag))
//            }
//            total += mag
//            freq += bandwidth
//        }
//        return total
//    }
//
//    private func frequencyToIndex(_ frequency: Float) -> Int {
//        return Int((frequency / nyquistFrequency) * Float(magnitudes.count))
//    }
//
//    private func fastAverage(_ slice: ArraySlice<Float>) -> Float {
//        var mean: Float = 0
//        vDSP_meanv(slice.withUnsafeBufferPointer { $0.baseAddress! }, 1, &mean, vDSP_Length(slice.count))
//        return mean
//    }
//
//    private func averageFrequency(startIndex: Int, endIndex: Int) -> Float {
//        let start = Float(startIndex) * bandwidth
//        let end = Float(endIndex) * bandwidth
//        return (start + end) / 2
//    }
//
//    class func toDB(_ magnitude: Float) -> Float {
//        let clamped = max(magnitude, 1e-12)
//        return 10 * log10f(clamped)
//    }
//}

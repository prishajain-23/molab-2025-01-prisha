////
////  TempiAudioInput.swift
////  Week8Assignment
////
////  Created by Prisha Jain on 3/30/25.
////
//
//import AVFoundation
//
//typealias TempiAudioInputCallback = (
//    _ timeStamp: Double,
//    _ numberOfFrames: Int,
//    _ samples: [Float]
//) -> Void
//
//final class TempiAudioInput: NSObject {
//    private var audioUnit: AudioUnit?
//    private let audioSession = AVAudioSession.sharedInstance()
//    private let sampleRate: Double
//    private let numberOfChannels: UInt32
//    private let audioInputCallback: TempiAudioInputCallback
//
//    var shouldPerformDCOffsetRejection: Bool = false
//
//    private let outputBus: UInt32 = 0
//    private let inputBus: UInt32 = 1
//
//    init(audioInputCallback callback: @escaping TempiAudioInputCallback, sampleRate: Double = 44100.0, numberOfChannels: UInt32 = 1) {
//        self.audioInputCallback = callback
//        self.sampleRate = sampleRate
//        self.numberOfChannels = numberOfChannels
//        super.init()
//    }
//
//    func startRecording() {
//        do {
//            if audioUnit == nil {
//                try setupAudioSession()
//                try setupAudioUnit()
//            }
//
//            try audioSession.setActive(true)
//
//            if let audioUnit = audioUnit {
//                let osErr = AudioOutputUnitStart(audioUnit)
//                if osErr != noErr {
//                    print("❌ AudioOutputUnitStart error: \(osErr)")
//                }
//            }
//        } catch {
//            print("❌ startRecording error: \(error)")
//        }
//    }
//
//    func stopRecording() {
//        do {
//            if let audioUnit = audioUnit {
//                let osErr = AudioOutputUnitStop(audioUnit)
//                if osErr != noErr {
//                    print("❌ AudioOutputUnitStop error: \(osErr)")
//                }
//            }
//
//            try audioSession.setActive(false)
//        } catch {
//            print("❌ stopRecording error: \(error)")
//        }
//    }
//
//    private func setupAudioSession() throws {
//        try audioSession.setCategory(.record, mode: .measurement, options: [])
//        try audioSession.setPreferredSampleRate(sampleRate)
//        try audioSession.setPreferredIOBufferDuration(0.01)
//
//        if #available(iOS 17.0, *) {
//            AVAudioApplication.requestRecordPermission { granted in
//                if !granted {
//                    print("❌ Microphone permission denied.")
//                }
//            }
//        } else {
//            audioSession.requestRecordPermission { granted in
//                if !granted {
//                    print("❌ Microphone permission denied.")
//                }
//            }
//        }
//
//    }
//
//    private func setupAudioUnit() throws {
//        var componentDesc = AudioComponentDescription(
//            componentType: kAudioUnitType_Output,
//            componentSubType: kAudioUnitSubType_RemoteIO,
//            componentManufacturer: kAudioUnitManufacturer_Apple,
//            componentFlags: 0,
//            componentFlagsMask: 0
//        )
//
//        guard let component = AudioComponentFindNext(nil, &componentDesc) else {
//            throw NSError(domain: "TempiAudioInput", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find audio component"])
//        }
//
//        var tempAudioUnit: AudioUnit?
//        let result = AudioComponentInstanceNew(component, &tempAudioUnit)
//        guard result == noErr, let unit = tempAudioUnit else {
//            throw NSError(domain: "TempiAudioInput", code: Int(result), userInfo: [NSLocalizedDescriptionKey: "AudioComponentInstanceNew failed"])
//        }
//
//        audioUnit = unit
//
//        var enableIO: UInt32 = 1
//        AudioUnitSetProperty(unit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, inputBus, &enableIO, UInt32(MemoryLayout<UInt32>.size))
//        AudioUnitSetProperty(unit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Output, outputBus, &enableIO, UInt32(MemoryLayout<UInt32>.size))
//
//        var format = AudioStreamBasicDescription(
//            mSampleRate: sampleRate,
//            mFormatID: kAudioFormatLinearPCM,
//            mFormatFlags: kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved,
//            mBytesPerPacket: 4,
//            mFramesPerPacket: 1,
//            mBytesPerFrame: 4,
//            mChannelsPerFrame: numberOfChannels,
//            mBitsPerChannel: 32,
//            mReserved: 0
//        )
//
//        AudioUnitSetProperty(unit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, outputBus, &format, UInt32(MemoryLayout<AudioStreamBasicDescription>.size))
//        AudioUnitSetProperty(unit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, inputBus, &format, UInt32(MemoryLayout<AudioStreamBasicDescription>.size))
//
//        var callbackStruct = AURenderCallbackStruct(
//            inputProc: recordingCallback,
//            inputProcRefCon: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
//        )
//
//        AudioUnitSetProperty(unit, kAudioOutputUnitProperty_SetInputCallback, kAudioUnitScope_Global, inputBus, &callbackStruct, UInt32(MemoryLayout<AURenderCallbackStruct>.size))
//
//        var shouldAllocate: UInt32 = 1
//        AudioUnitSetProperty(unit, kAudioUnitProperty_ShouldAllocateBuffer, kAudioUnitScope_Output, inputBus, &shouldAllocate, UInt32(MemoryLayout<UInt32>.size))
//    }
//
//    private let recordingCallback: AURenderCallback = { inRefCon, _, inTimeStamp, inBusNumber, inNumberFrames, _ in
//        let audioInput = Unmanaged<TempiAudioInput>.fromOpaque(inRefCon).takeUnretainedValue()
//
//        guard let audioUnit = audioInput.audioUnit else {
//            return -1
//        }
//
//        var bufferList = AudioBufferList(
//            mNumberBuffers: 1,
//            mBuffers: AudioBuffer(
//                mNumberChannels: audioInput.numberOfChannels,
//                mDataByteSize: 4 * inNumberFrames,
//                mData: nil
//            )
//        )
//
//        let osErr = AudioUnitRender(audioUnit, nil, inTimeStamp, inBusNumber, inNumberFrames, &bufferList)
//        guard osErr == noErr else {
//            print("❌ AudioUnitRender error: \(osErr)")
//            return osErr
//        }
//
//        guard let data = bufferList.mBuffers.mData else {
//            return -1
//        }
//
//        let pointer = data.bindMemory(to: Float.self, capacity: Int(inNumberFrames))
//        var samples = Array(UnsafeBufferPointer(start: pointer, count: Int(inNumberFrames)))
//
//        if audioInput.shouldPerformDCOffsetRejection {
//            DCRejectionFilter.process(&samples)
//        }
//
//        let timestamp = inTimeStamp.pointee.mSampleTime / audioInput.sampleRate
//        audioInput.audioInputCallback(timestamp, Int(inNumberFrames), samples)
//
//        return noErr
//    }
//}
//
//// MARK: - DC Offset Filter
//
//enum DCRejectionFilter {
//    static func process(_ audioData: inout [Float]) {
//        let poleDist: Float = 0.975
//        var mX1: Float = 0
//        var mY1: Float = 0
//
//        for i in 0..<audioData.count {
//            let xCurr = audioData[i]
//            audioData[i] = xCurr - mX1 + (poleDist * mY1)
//            mX1 = xCurr
//            mY1 = audioData[i]
//        }
//    }
//}

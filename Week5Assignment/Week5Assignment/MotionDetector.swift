import CoreMotion
import SwiftUI

@Observable
class MotionDetector {
    private let motionManager = CMMotionManager()
    private var timer: Timer?
    private var updateInterval: TimeInterval
    
    // 🎵 Audio Player for Effects
    private let drumPlayer = DrumPlayer()
    
    // 🌍 UI-Observable Motion Properties
    var pitch: Double = 0
    var roll: Double = 0
    var zAcceleration: Double = 0
    var reverb: Float = 0  // ✅ Added to track real-time effect
    var delayTime: TimeInterval = 0  // ✅ Added to track real-time effect
    
    private var previousZAcceleration: Double = 0
    var onUpdate: (() -> Void) = {}

    private var currentOrientation: UIDeviceOrientation = .landscapeLeft
    private var orientationObserver: NSObjectProtocol?
    
    let notification = UIDevice.orientationDidChangeNotification

    init(updateInterval: TimeInterval = 0.01) {
        self.updateInterval = updateInterval
    }

    func start() {
        print("📡 Motion detection started")
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates()

            timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { _ in
                self.updateMotionData()
            }
        } else {
            print("❌ Motion data isn't available on this device.")
        }

        UIDevice.current.beginGeneratingDeviceOrientationNotifications()

        orientationObserver = NotificationCenter.default.addObserver(forName: notification, object: nil, queue: .main) { [weak self] _ in
            switch UIDevice.current.orientation {
            case .faceUp, .faceDown, .unknown:
                break
            default:
                self?.currentOrientation = UIDevice.current.orientation
            }
        }
    }

    func updateMotionData() {
        guard let data = motionManager.deviceMotion else { return }

        previousZAcceleration = zAcceleration
        let newZAcceleration = data.userAcceleration.z
        let (newRoll, newPitch) = currentOrientation.adjustedRollAndPitch(data.attitude)

        // 🎛️ Apply effects to DrumPlayer
        let (newReverb, newDelay) = drumPlayer.updateEffects(roll: newRoll, pitch: newPitch)

        // ✅ Ensure UI updates on the main thread
        DispatchQueue.main.async {
            self.zAcceleration = newZAcceleration
            self.roll = newRoll
            self.pitch = newPitch
            self.reverb = newReverb
            self.delayTime = newDelay
        }

        onUpdate()
    }

    func stop() {
        motionManager.stopDeviceMotionUpdates()
        timer?.invalidate()
        if let observer = orientationObserver {
            NotificationCenter.default.removeObserver(observer, name: notification, object: nil)
        }
        orientationObserver = nil
    }

    deinit {
        stop()
    }
}

extension MotionDetector {
    func started() -> MotionDetector {
        start()
        return self
    }
}

extension UIDeviceOrientation {
    func adjustedRollAndPitch(_ attitude: CMAttitude) -> (roll: Double, pitch: Double) {
        switch self {
        case .unknown, .faceUp, .faceDown:
            return (attitude.roll, -attitude.pitch)
        case .landscapeLeft:
            return (attitude.pitch, -attitude.roll)
        case .portrait:
            return (attitude.roll, attitude.pitch)
        case .portraitUpsideDown:
            return (-attitude.roll, -attitude.pitch)
        case .landscapeRight:
            return (-attitude.pitch, attitude.roll)
        @unknown default:
            return (attitude.roll, attitude.pitch)
        }
    }
}

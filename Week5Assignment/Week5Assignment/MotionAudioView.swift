import SwiftUI

struct MotionAudioView: View {
    @Environment(MotionDetector.self) private var motionDetector
    @State private var drumPlayer = DrumPlayer()

    var body: some View {
        VStack(spacing: 20) {
            // 🎵 Play/Pause Button with Smaller Symbol
            Button(action: {
                drumPlayer.togglePlayPause()
            }) {
                Image(systemName: drumPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 50)) // ✅ Adjusted for smaller icon
                    .foregroundStyle(.blue)
            }

            // 📡 Display Motion Data & Effects
            VStack {
                Text("Motion Data")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                HStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("Roll: \(motionDetector.roll, specifier: "%.2f")")
                        Text("Pitch: \(motionDetector.pitch, specifier: "%.2f")")
                    }
                    VStack(alignment: .leading) {
                        Text("Reverb: \(motionDetector.reverb, specifier: "%.0f")%")
                        Text("Delay: \(motionDetector.delayTime, specifier: "%.2f")s")
                    }
                }

                AudioVisualization()
                    .frame(height: 300)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .multilineTextAlignment(.center)
        .onAppear { motionDetector.start() }
        .onDisappear { motionDetector.stop() }
    }
}

#Preview {
    MotionAudioView()
        .environment(MotionDetector(updateInterval: 0.01))
        .environment(DrumPlayer())
}

import SwiftUI
import AVFoundation

struct SongSampleView: View {
    let track1Title: String
    let track1FileName: String
    let track1ImageName: String  // New parameter for track 1 image
    let track2Title: String
    let track2FileName: String
    let track2ImageName: String  // New parameter for track 2 image

    @State private var track1Player: AVAudioPlayer?
    @State private var track2Player: AVAudioPlayer?

    @State private var track1Volume: Float = 0.5
    @State private var track2Volume: Float = 0.5
    @State private var crossfader: Float = 0.5

    @State private var track1IsPlaying: Bool = false
    @State private var track2IsPlaying: Bool = false

    @State private var track1Waveform: [CGFloat] = Array(repeating: 0.1, count: 30)
    @State private var track2Waveform: [CGFloat] = Array(repeating: 0.1, count: 30)

    @State private var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                HStack(spacing: 50) {
                    TrackView(
                        trackName: track1Title,
                        trackImageName: track1ImageName, // Pass the image name for track 1
                        volume: $track1Volume,
                        waveformData: $track1Waveform,
                        buttonColor: .blue,
                        isPlaying: $track1IsPlaying,
                        togglePlayback: {
                            if let player = track1Player {
                                if player.isPlaying {
                                    player.pause()
                                    track1IsPlaying = false
                                } else {
                                    player.play()
                                    track1IsPlaying = true
                                }
                            }
                        }
                    )
                    TrackView(
                        trackName: track2Title,
                        trackImageName: track2ImageName, // Pass the image name for track 2
                        volume: $track2Volume,
                        waveformData: $track2Waveform,
                        buttonColor: .red,
                        isPlaying: $track2IsPlaying,
                        togglePlayback: {
                            if let player = track2Player {
                                if player.isPlaying {
                                    player.pause()
                                    track2IsPlaying = false
                                } else {
                                    player.play()
                                    track2IsPlaying = true
                                }
                            }
                        }
                    )
                }

                Spacer()

                VStack {
                    Text("Master Crossfader")
                        .foregroundColor(.white)
                        .font(.caption)
                    
                    Slider(value: $crossfader, in: 0...1)
                        .accentColor(.white)
                        .frame(width: 300)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                        )
                        .onChange(of: crossfader) { newValue, transaction in
                            updatePlayerVolumes()
                        }
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear(perform: setupAudioPlayers)
        .onDisappear(perform: stopAudioPlayers)
        .onChange(of: track1Volume) { newValue, transaction in
            updatePlayerVolumes()
        }
        .onChange(of: track2Volume) { newValue, transaction in
            updatePlayerVolumes()
        }
        .onReceive(timer) { _ in
            updateWaveform(for: track1Player, waveformData: &track1Waveform)
            updateWaveform(for: track2Player, waveformData: &track2Waveform)
        }
    }
    
    func setupAudioPlayers() {
        track1Player = loadAudio(fileName: track1FileName)
        track2Player = loadAudio(fileName: track2FileName)
        
        track1Player?.isMeteringEnabled = true
        track2Player?.isMeteringEnabled = true
        
        updatePlayerVolumes()
        
        track1Player?.play()
        track2Player?.play()
        track1IsPlaying = true
        track2IsPlaying = true
    }
    
    func loadAudio(fileName: String) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("Error: \(fileName).mp3 not found")
            return nil
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            return player
        } catch {
            print("Error loading \(fileName): \(error.localizedDescription)")
            return nil
        }
    }
    
    func updatePlayerVolumes() {
        let actualVolume1 = track1Volume * (1.0 - crossfader)
        let actualVolume2 = track2Volume * crossfader
        track1Player?.volume = actualVolume1
        track2Player?.volume = actualVolume2
    }
    
    func updateWaveform(for player: AVAudioPlayer?, waveformData: inout [CGFloat]) {
        guard let player = player, player.isPlaying else { return }
        player.updateMeters()
        let level = CGFloat(player.averagePower(forChannel: 0) + 60) / 60
        withAnimation(.linear(duration: 0.05)) {
            waveformData.append(level)
            if waveformData.count > 30 {
                waveformData.removeFirst()
            }
        }
    }
    
    func stopAudioPlayers() {
        track1Player?.stop()
        track2Player?.stop()
        track1IsPlaying = false
        track2IsPlaying = false
    }
}

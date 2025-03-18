import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var backgroundColor: Color = .clear
    @State private var selectedItem: PhotosPickerItem?
    @State private var userImage: UIImage?
    @State private var showPhotoPicker: Bool = false // Controls when the picker is shown

    @State private var extractedColors: [Color] = [.red, .green, .blue] // Default colors
    @State private var amplitudes: [Float] = [0.2, 0.2, 0.2] // Default volume
    @State private var isPlaying = false // Tracks oscillator state

    // Drag Gesture
    @State private var imagePosition: CGSize = .zero
    @GestureState private var dragOffset: CGSize = .zero

    // Scale Gesture
    @State private var currentAmount: CGFloat = 0
    @State private var finalAmount: CGFloat = 1

    let audioManager = AudioManager()

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            // VStack for stacking WaveformViews
            VStack {
                ForEach(0..<3, id: \.self) { index in
                    WaveformView(node: audioManager.getOscillatorNode(for: index), color: extractedColors[index])
                        .blendMode(.screen) // Enhances visual effect
                }
                // Sliders for controlling amplitude of each frequency
                ForEach(Array(amplitudes.enumerated()), id: \.offset) { index, _ in
                    SliderView(amplitude: $amplitudes[index], color: extractedColors[index])
                        .onChange(of: amplitudes[index]) { _, newValue in
                            audioManager.setAmplitude(for: index, amplitude: newValue)
                        }
                }
            }
            .frame(maxWidth: 300, maxHeight: 300)

            VStack {
                Spacer()

                if let userImage {
                    Image(uiImage: userImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .offset(x: imagePosition.width + dragOffset.width, y: imagePosition.height + dragOffset.height)
                        .scaleEffect(currentAmount + finalAmount)
                        .onTapGesture {
                            showPhotoPicker = true // Open picker when tapped
                        }
                        .gesture(
                            DragGesture()
                                .updating($dragOffset) { (value, state, _) in
                                    state = value.translation
                                }
                                .onEnded { value in
                                    imagePosition.width += value.translation.width
                                    imagePosition.height += value.translation.height
                                    updatePan()
                                }
                        )
                        .gesture(
                            MagnificationGesture()
                                .onChanged { amount in
                                    currentAmount = amount - 1
                                }
                                .onEnded { amount in
                                    finalAmount += currentAmount
                                    currentAmount = 0
                                }
                        )
                } else {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 50)
                }

                // Play/Pause Button
                Button(action: toggleAudio) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                        .background(extractedColors.first ?? .blue)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            audioManager.startAudioEngine()
        }
        // Show the PhotosPicker when tapped
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem, loadImage)
    }

    // Updates the stereo pan based on horizontal movement
    func updatePan() {
        let screenWidth = UIScreen.main.bounds.width / 2 // Half screen width
        let panValue = (imagePosition.width / screenWidth) * 1.5 // Scale to [-1, 1]
        let clampedPan = max(-1, min(1, panValue)) // Ensure it stays in range

        audioManager.setPan(Float(clampedPan))
    }

    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }

            userImage = inputImage

            let colors = ImageProcessor.extractDominantColors(from: inputImage).map { Color($0) }
            extractedColors = colors

            if let firstColor = colors.first {
                backgroundColor = firstColor
            }

            for (index, color) in colors.prefix(3).enumerated() {
                let frequency = ImageProcessor.mapColorToFrequency(UIColor(color))
                audioManager.setFrequency(for: index, frequency: frequency)
                print("🎵 Frequency \(index): \(frequency) Hz")
            }
        }
    }

    func toggleAudio() {
        isPlaying.toggle()
        if isPlaying {
            audioManager.startOscillators()
        } else {
            audioManager.stopOscillators()
        }
    }
}

#Preview {
    ContentView()
}

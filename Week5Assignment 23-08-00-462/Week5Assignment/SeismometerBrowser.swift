/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct SeismometerBrowser: View {
  @Environment(MotionDetector.self) private var detector

  var body: some View {
    NavigationSplitView {
      List {
        NavigationLink(destination: NeedleSeismometer()) {
          HStack {
            Image(systemName: "gauge")
              .foregroundColor(Color.accentColor)
              .padding()
              .font(.title2)

            VStack(alignment: .leading, spacing: 8) {
              Text("Needle")
                .font(.headline)
              Text("A needle that responds to the device’s vibration.")
                .font(.caption)
            }
            .padding(.trailing)
          }
        }.padding([.top, .bottom])

        NavigationLink(destination: GraphSeismometer()) {
          HStack {
            Image(systemName: "waveform.path.ecg.rectangle")
              .foregroundColor(Color.accentColor)
              .padding()
              .font(.title2)

            VStack(alignment: .leading, spacing: 8) {
              Text("Graph")
                .font(.headline)
              Text(
                "Watch the device’s vibrations charted on a graph. Adjust the sensitivity using a slider."
              )
              .font(.caption)
            }
            .padding(.trailing)
          }
        }.padding([.top, .bottom])
      }
      .listStyle(.plain)
      .navigationTitle(Text("Seismometer"))
    } detail: {
      Text("Select a Seismometer Example")
        .foregroundColor(.secondary)
    }
    .onAppear {
      detector.start()
    }
    .onDisappear {
      detector.stop()
    }
  }
}

#Preview {
  SeismometerBrowser()
    .environment(MotionDetector(updateInterval: 0.01).started())
}

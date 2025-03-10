/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct GraphSeismometer: View {
  @Environment(MotionDetector.self) private var detector
  @State private var data = [Double]()
  let maxData = 1000

  @State private var sensitivity = 0.0
  let graphMaxValueMostSensitive = 0.01
  let graphMaxValueLeastSensitive = 1.0

  var graphMaxValue: Double {
    graphMaxValueMostSensitive + (1 - sensitivity)
      * (graphMaxValueLeastSensitive - graphMaxValueMostSensitive)
  }

  var graphMinValue: Double {
    -graphMaxValue
  }

  var body: some View {
    VStack {
      Spacer()
      LineGraph(
        data: data, maxData: maxData, minValue: graphMinValue,
        maxValue: graphMaxValue
      )
      .clipped()
      .background(Color.accentColor.opacity(0.1))
      .cornerRadius(20)
      .padding()
      .aspectRatio(1, contentMode: .fit)

      Spacer()

      Text("Sensitivity")
        .font(.headline)

      Slider(
        value: $sensitivity, in: 0...1, minimumValueLabel: Text("Min"),
        maximumValueLabel: Text("Max")
      ) {
        Text("Sensitivity")
      }
      .padding()

      Spacer()

      Text(
        "Set your device on a flat surface to record vibrations using its motion sensors."
      )
      .padding()

      Spacer()
    }
    .onAppear {
      detector.onUpdate = {
        data.append(-detector.zAcceleration)
        if data.count > maxData {
          data = Array(data.dropFirst())
//          print("Data:\(data)")
//          print("zAcceleration: \(detector.zAcceleration)")
        }
      }
    }
  }
}

#Preview {
  GraphSeismometer()
    .environment(MotionDetector(updateInterval: 0.01).started())
}

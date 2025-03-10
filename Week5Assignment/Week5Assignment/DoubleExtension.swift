/*
See the License.txt file for this sample’s licensing information.
*/

extension Double {
  func describeAsFixedLengthString(
    integerDigits: Int = 2, fractionDigits: Int = 2
  ) -> String {
    self.formatted(
      .number
        .sign(strategy: .always())
        .precision(
          .integerAndFractionLength(
            integer: integerDigits, fraction: fractionDigits)
        )
    )
  }
}

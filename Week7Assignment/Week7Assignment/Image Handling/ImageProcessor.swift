//
//  ImageProcessor.swift
//  Week7Assignment
//
//  Created by Prisha Jain on 3/11/25.
//

// takes the pixel data from the loaded image and converts to frequency

import UIKit

struct ImageProcessor {
    /// Extracts the dominant colors from an image using color binning
    static func extractDominantColors(from image: UIImage) -> [UIColor] {
        return image.dominantColors()
    }

    /// Converts UIColor to a frequency (Hz)
    static func mapColorToFrequency(_ color: UIColor) -> Float {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let minFreq: Float = 100
        let maxFreq: Float = 1000
        return Float(red * 0.5 + green * 0.3 + blue * 0.2) * (maxFreq - minFreq) + minFreq
    }
}

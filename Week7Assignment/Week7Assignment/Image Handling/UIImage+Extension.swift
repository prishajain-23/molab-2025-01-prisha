//
//  UIImage+Extension.swift
//  Week7Assignment
//
//  Created by Brandon Baars on 5/23/20.
//  Modified by ChatGPT to extract 3 colors on 3/11/25
//

import UIKit

extension UIImage {
    /// Extracts the 3 most common colors using histogram binning
    func dominantColors(count: Int = 3) -> [UIColor] {
        guard self.cgImage != nil else { return [] }

        let width = 50
        let height = 50
        guard let resizedImage = self.resize(to: CGSize(width: width, height: height))?.cgImage else { return [] }

        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: &pixelData,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return [] }

        context.draw(resizedImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        var colorCounts: [UInt32: Int] = [:]

        for i in stride(from: 0, to: pixelData.count, by: bytesPerPixel) {
            let r = pixelData[i] & 0xF0
            let g = pixelData[i + 1] & 0xF0
            let b = pixelData[i + 2] & 0xF0
            let colorKey = UInt32(r) << 16 | UInt32(g) << 8 | UInt32(b)

            colorCounts[colorKey, default: 0] += 1
        }

        let sortedColors = colorCounts.sorted { $0.value > $1.value }.prefix(count)
        return sortedColors.map { key, _ in
            let r = CGFloat((key >> 16) & 0xF0) / 255.0
            let g = CGFloat((key >> 8) & 0xF0) / 255.0
            let b = CGFloat(key & 0xF0) / 255.0
            return UIColor(red: r, green: g, blue: b, alpha: 1)
        }
    }

    /// Resizes an image to a target size
    func resize(to targetSize: CGSize) -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1 // Keep the original scale
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

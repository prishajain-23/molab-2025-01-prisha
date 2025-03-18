//
//  UIImage+Extension.swift
//  Week7Assignment
//
//  Created by Brandon Baars on 5/23/20.
//  Modified by ChatGPT to extract 3 colors on 3/11/25
//

import UIKit

// Extension to UIImage to add functionality for extracting dominant colors
extension UIImage {
    
    /// Extracts the `count` most common colors from the image using histogram binning.
    /// - Parameter count: The number of dominant colors to extract (default is 3).
    /// - Returns: An array of `UIColor` objects representing the most common colors.
    func dominantColors(count: Int = 3) -> [UIColor] {
        // Ensure the image has a valid CGImage representation, otherwise return an empty array.
        guard self.cgImage != nil else { return [] }

        // Resize the image to a smaller size to reduce computation
        let width = 50
        let height = 50
        guard let resizedImage = self.resize(to: CGSize(width: width, height: height))?.cgImage else { return [] }

        // Byte and color space settings for processing the image data
        let bytesPerPixel = 4           // Each pixel contains 4 bytes (RGBA)
        let bytesPerRow = bytesPerPixel * width // Total bytes per row of pixels
        let bitsPerComponent = 8        // Each color component (R, G, B, A) uses 8 bits (1 byte)
        
        // Initialize an empty pixel data array with enough space for all pixels
        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)

        // Create a color space (RGB) for image processing
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Create a CGContext to draw the image and extract pixel data
        guard let context = CGContext(
            data: &pixelData,  // Pointer to the pixel data buffer
            width: width,      // Width of the image
            height: height,    // Height of the image
            bitsPerComponent: bitsPerComponent,  // Bits per color component (8 bits for R, G, B, A)
            bytesPerRow: bytesPerRow,  // Total bytes per row
            space: colorSpace, // Color space (RGB)
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue // Bitmap info for alpha channel
        ) else { return [] }

        // Draw the resized image into the graphics context to populate pixel data
        context.draw(resizedImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        // Dictionary to store color frequencies
        var colorCounts: [UInt32: Int] = [:]

        // Loop through pixel data and count unique colors
        for i in stride(from: 0, to: pixelData.count, by: bytesPerPixel) {
            // Extract RGB values from pixel data with reduced precision (4 bits per channel)
            let r = pixelData[i] & 0xF0      // Red component (round down to nearest 16)
            let g = pixelData[i + 1] & 0xF0  // Green component
            let b = pixelData[i + 2] & 0xF0  // Blue component
            
            // Combine the RGB components into a single 32-bit integer as a unique key
            let colorKey = UInt32(r) << 16 | UInt32(g) << 8 | UInt32(b)

            // Increment the frequency count for this color
            colorCounts[colorKey, default: 0] += 1
        }

        // Sort the colors by frequency in descending order and take the top `count` colors
        let sortedColors = colorCounts.sorted { $0.value > $1.value }.prefix(count)
        
        // Map the sorted colors to UIColor objects and return them
        return sortedColors.map { key, _ in
            // Extract RGB components from the color key
            let r = CGFloat((key >> 16) & 0xF0) / 255.0
            let g = CGFloat((key >> 8) & 0xF0) / 255.0
            let b = CGFloat(key & 0xF0) / 255.0
            
            // Create and return a UIColor from the RGB components
            return UIColor(red: r, green: g, blue: b, alpha: 1)
        }
    }

    /// Resizes the image to the specified target size.
    /// - Parameter targetSize: The size to resize the image to.
    /// - Returns: A new resized `UIImage`, or `nil` if resizing fails.
    func resize(to targetSize: CGSize) -> UIImage? {
        // Configure the image renderer format to maintain original scale
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        
        // Create an image renderer with the target size
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        
        // Render the resized image and return it
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
